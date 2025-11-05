//
//  InfoViewModel.swift
//  MovieDiary
//
//  Created by openobject2 on 10/14/25.
//
//  영화 정보 관련 상태 관리
//

import os
import Foundation
import Combine
import SwiftUI

final class InfoViewModel: ObservableObject {
    private let logger = Logger(subsystem: "com.MovieDiary.MovieViewModel", category: "ViewModel")
    
    private var nowPlaying: ViewState<[Movie]> = .idle  // 현재 상영 중
    private var topRated: ViewState<[Movie]> = .idle    // 역대 인기
    @Published var movies: ViewState<[Movie]> = .idle   // 화면에 반영되는 영화 목록
    @Published var detail: ViewState<MovieDetail> = .idle   // 영화 상세 정보
    @Published var watchProviders: ViewState<CountryProvider> = .idle   // 다시보기 플랫폼
    @Published var searchResults: ViewState<[Movie]> = .idle    // 검색 결과
    
    private let service: MovieServiceProtocol
    
    init(service: MovieServiceProtocol) {
        self.service = service
    }
    
    // 현재 상영 중인 작품 목록 요청
    func requestNowPlaying(page: Int = 1) {
        requestWithCache(cacheKeyPath: \.nowPlaying, publishedKeyPath: \.movies) {
            try await self.service.requestNowPlayingList(page: page).results
        }
    }
    
    // 역대 인기 작품 목록 요청
    func requestTopRated(page: Int = 1) {
        requestWithCache(cacheKeyPath: \.topRated, publishedKeyPath: \.movies) {
            try await self.service.requestTopRatedList(page: page).results
        }
    }
    
    // 특정 영화의 다시보기 플랫폼 목록 요청
    func requestWatchProviders(id: Int) {
        request(keyPath: \.watchProviders) {
            guard let providers = try await self.service.requestWatchProviders(movieId: id).results["KR"] else {
                 throw NSError(domain: "InfoViewModel", code: 404, userInfo: [NSLocalizedDescriptionKey: "한국의 시청 정보를 찾을 수 없습니다."])
             }
            return providers
        }
    }
    
    // 영화 상세 정보 요청
    func requestMovieDetail(id: Int) {
        request(keyPath: \.detail) {
            let detail = try await self.service.requestDetail(movieId: id)
            let directors = detail.credits.crew.filter { credit in
                credit.job == "Director"
            }
            return detail
        }
    }
    
    // 키워드 검색 요청
    func requestSearch(query: String, page: Int) {
        request(keyPath: \.searchResults) {
            try await self.service.requestSearch(query: query, page: page).results
        }
    }
    
    private func request<T>(keyPath: ReferenceWritableKeyPath<InfoViewModel, ViewState<T>>, perform: @escaping () async throws -> T) {
        Task {
            await MainActor.run {
                self[keyPath: keyPath] = .loading
            }
            
            do {
                let result = try await perform()
                await MainActor.run {
                     self[keyPath: keyPath] = .success(result)
                }
            } catch {
                await MainActor.run {
                    self[keyPath: keyPath] = .failure(error)
                }
                logger.error("네트워크 응답을 받지 못했습니다:\(error)")
            }
        }
    }
    
    private func requestWithCache<T>(
            cacheKeyPath: ReferenceWritableKeyPath<InfoViewModel, ViewState<T>>,
            publishedKeyPath: ReferenceWritableKeyPath<InfoViewModel, ViewState<T>>,
            perform: @escaping () async throws -> T
        ) {
            // 기존 데이터가 있으면 호출 x, 바로 뷰에 반영
            if case .success(let cachedResult) = self[keyPath: cacheKeyPath] {
                self[keyPath: publishedKeyPath] = .success(cachedResult)
                return
            }
            
            // 기존 데이터가 없으면 네트워크 요청
            Task {
                // 메인 스레드에서 ui 업데이트
                await MainActor.run {
                    self[keyPath: publishedKeyPath] = .loading
                }
                
                do {
                    let result = try await perform()
                    await MainActor.run {
                        let successState = ViewState.success(result)
                        self[keyPath: cacheKeyPath] = successState
                        self[keyPath: publishedKeyPath] = successState
                    }
                } catch {
                    await MainActor.run {
                        let failureState = ViewState<T>.failure(error)
                        self[keyPath: cacheKeyPath] = failureState
                        self[keyPath: publishedKeyPath] = failureState
                    }
                }
            }
        }
}
