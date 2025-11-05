//
//  MovieDetailView.swift
//  MovieDiary
//
//  Created by openobject2 on 10/13/25.
//
//  영화 상세 정보 화면
//

import os
import SwiftUI
import SwiftData
import Kingfisher
import YouTubePlayerKit

enum MovieDetailType: String, Codable {
    case summary
    case all
}

enum CreditType {
    case actor
    case director
}

struct MovieDetailView: View {
    private let logger = Logger(subsystem: "com.MovieDiary.MovieDetailView", category: "View")
    
    let detailState: ViewState<MovieDetail>
    let providerState: ViewState<CountryProvider>
    
    @EnvironmentObject var infoViewModel: InfoViewModel
    @EnvironmentObject var diaryViewModel: DiaryViewModel
    @EnvironmentObject var locationViewModel: LocationViewModel
    @EnvironmentObject var cameraViewModel: CameraViewModel
    
    @Environment(\.isInsideDiaryDetail) private var isInsideDiaryDetail: Bool
    
    var body: some View {
        ZStack {
            ScrollView(.vertical) {
                VStack(spacing: 20) {
                    switch (detailState, providerState) {
                        
                    case (.loading, _), (_, .loading):
                        ProgressView()
                        
                    case (.success(let detail), .failure(_)):
                        movieDetail(detail: detail)
                        
                    case (.success(let detail), .success(let providers)):
                        movieDetail(detail: detail, providers: providers)
                        
                    case (.failure(let error), _), (_, .failure(let error)):
                        Text("영화 정보를 불러오지 못했습니다.\n\(error.localizedDescription)")
                            .multilineTextAlignment(.center)
                        
                    default:
                        EmptyView()
                    }
                }
                .padding()
                .padding(.bottom, 80)
            }
            .scrollContentBackground(.hidden)
            
            VStack {
                Spacer()
                if case .success(let detail) = detailState, !isInsideDiaryDetail {
                    FloatingDiaryButton(detail: detail)
                }
            }
            .padding(.bottom, 20)
        }
        .navigationTitle("상세 정보")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarVisibility(.hidden, for: .tabBar)
    }
    
    @ViewBuilder
    func movieDetail(detail: MovieDetail, providers: CountryProvider? = nil) -> some View {
        VStack {
            OriginalImage(path: detail.posterPath)
                .padding(.bottom)
                .frame(maxWidth: .infinity)
            
            Text(detail.title)
                .font(.title)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            
            subInfo(detail: detail)
            
            Text(detail.overview)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom)
            
            latestVideo(videos: detail.videos.results)
            reviews(detail.reviews.results)
            credits(detail.credits.crew, type: .director)
            credits(detail.credits.cast, type: .actor)
            watchProviders(providers?.flatrate ?? [], title: "구독").padding(.bottom, 40)
            watchProviders(providers?.buy ?? [], title: "구매")
            tmdbLink(providers?.link ?? "")
        }
    }
    
    @ViewBuilder
    func subInfo(detail: MovieDetail) -> some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center, spacing: 5) {
                Text(detail.genres.map { $0.name }.joined(separator: "·"))
                    .font(.caption)
                    .foregroundStyle(.gray)
                Text("|")
                    .font(.caption)
                    .foregroundStyle(.gray)
                Text("\(detail.releaseDate.formatDate())")
                    .font(.caption)
                    .foregroundStyle(.gray)
                Spacer()
            }
            
            Text("\(String(format: "%.1f", detail.voteAverage))점(\(detail.voteCount)명)")
                .font(.caption)
                .foregroundStyle(.gray)
                .padding(.bottom)
        }
    }
    
    @ViewBuilder
    func latestVideo(videos: [Video]) -> some View {
        if let latest = videos.max(by: { v0, v1 in
            v0.publishedAt < v1.publishedAt
        }) {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(alignment: .center) {
                    VideoView(type: .summary, videos: [latest])
                    
                    NavigationLink {
                        VideoView(type: .all, videos: videos).padding()
                    } label: {
                        Text("관련 영상 더보기")
                    }.padding(.bottom, 40)
                }
            }
        }
    }
    
    @ViewBuilder
    func reviews(_ reviews: [Review]) -> some View {
        if reviews.isEmpty {
            EmptyView()
        } else {
            VStack {
                Text("리뷰")
                    .font(.title3)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                ReviewView(type: .summary, reviews: reviews)
                
                NavigationLink {
                    ReviewView(type: .all, reviews: reviews).padding()
                } label: {
                    Text("리뷰 더보기")
                }.padding(.bottom, 40)
            }
        }
    }
    
    @ViewBuilder
    func credits(_ list: [Credit], type: CreditType) -> some View {
        let localDepartment = switch type {
        case .director: "감독"
        case .actor: "배우"
        }
        
        let condition: (Credit) -> Bool = switch type {
        case .director:
            { credit in credit.job == "Director" }
        case .actor:
            { credit in credit.knownForDepartment == "Acting" }
        }
        
        let filtered = list.filter(condition)
        
        if !filtered.isEmpty {
            VStack {
                Text(localDepartment)
                    .font(.title3)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                ScrollView(.horizontal) {
                    HStack(alignment: .top, spacing: 10) {
                        ForEach(filtered) { credit in
                            let url = URL(string: "https://google.com/search?q=\(credit.name)")!
                            
                            Link(destination: url) {
                                VStack(alignment: .center) {
                                    LowImage(path: credit.profilePath ?? "", defaultName: "person.slash")
                                        .frame(height: 120)
                                    
                                   if let character = credit.character {
                                        Text("\(character) 역")
                                           .foregroundStyle(.gray)
                                           .frame(width: 90)
                                           .lineLimit(2)
                                           .multilineTextAlignment(.center)
                                    }
                                    
                                    Text(credit.name)
                                        .foregroundStyle(Color.primary)
                                        .frame(width: 90)
                                        .lineLimit(3)
                                        .multilineTextAlignment(.center)
                                }
                            }
                        }
                    }
                }
                .scrollIndicators(.hidden, axes: .horizontal)
                .padding(.bottom, 40)
            }
        }
    }
    
    @ViewBuilder
    func watchProviders(_ providers: [WatchProvider], title: String) -> some View {
        if !providers.isEmpty {
            Text(title)
                .font(.title3)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ScrollView(.horizontal) {
                HStack(alignment: .top, spacing: 30) {
                    ForEach(providers, id: \.id) { item in
                        VStack(alignment: .center) {
                            LowImage(path: item.logoPath, defaultName: "movieclapper")
                                .frame(height: 60)
                            
                            Text(item.providerName)
                                .foregroundStyle(.gray)
                                .frame(width: 60)
                                .lineLimit(3)
                                .multilineTextAlignment(.center)
                        }
                    }
                }
            }
            .scrollIndicators(.hidden, axes: .horizontal)
        }
    }
    
    @ViewBuilder
    func tmdbLink(_ urlString: String) -> some View {
        if let url = URL(string: urlString) {
            Link(destination: url) {
                Text("TMDB에서 더 확인하기")
                    .foregroundStyle(.link)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .padding(.bottom)
        }
    }
}
