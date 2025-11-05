//
//  LocationViewModel.swift
//  MovieDiary
//
//  Created by openobject2 on 10/21/25.
//
//  장소 검색 관련 상태 관리
//

import Combine
import SwiftUI
import Alamofire

final class LocationViewModel: ObservableObject {
    @Published var location: ViewState<Location> = .idle
    private let service: LocationServiceProtocol
    
    init(service: LocationServiceProtocol) {
        self.service = service
    }
    
    func requestLocation(query: String) {
        Task {
            await MainActor.run {
                self.location = .loading
            }
            
            do {
                let result = try await self.service.requestSearch(query: query)
                await MainActor.run {
                    self.location = .success(result)
                }
            } catch {
                await MainActor.run {
                    self.location = .failure(error)
                }
            }
        }
    }
}
