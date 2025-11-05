//
//  MovieService.swift
//  MovieDiary
//
//  Created by openobject2 on 10/13/25.
//

import Foundation
import Alamofire

private nonisolated enum QueryParameter {
    static let languageKey = "language"
    static let languageValue = "ko-KR"
    static let pageKey = "page"
    static let regionKey = "region"
    static let regionValue = "kr"
    static let movieIdKey = "movie_id"
    static let queryKey = "query"
    static let adultKey = "include_adult"
    static let adultValue = false
    static let appendToResponseKey = "append_to_response"
    static let detailValue = "videos,images,credits,reviews"
}

private nonisolated enum Endpoint {
    case nowPlaying
    case topRated
    case detail(id: Int)
    case watchProviders(id: Int)
    case search(query: String)
    
    var path: String {
        switch self {
        case .nowPlaying: return "/movie/now_playing"
        case .topRated:   return "/movie/top_rated"
        case .detail(let id):   return "/movie/\(id)"
        case .watchProviders(let id): return "/movie/\(id)/watch/providers"
        case .search: return "/search/movie"
        }
    }
}

protocol MovieServiceProtocol: Actor {
    func requestNowPlayingList(page: Int) async throws -> Movies
    func requestTopRatedList(page: Int) async throws -> Movies
    func requestDetail(movieId: Int) async throws -> MovieDetail
    func requestWatchProviders(movieId: Int) async throws -> WatchProviders
    func requestSearch(query: String, page: Int) async throws -> Movies
}

// WeatherApiImpl 역할
actor MovieService: MovieServiceProtocol {
    private let baseUrl = "https://api.themoviedb.org/3"
    private var accessToken: String {
        // plist에서 access token 가져옴
        guard let token = Bundle.main.object(forInfoDictionaryKey: "TMDB_ACCESS_TOKEN") as? String else {
            fatalError("TMDB_ACCESS_TOKEN이 Info.plist에 존재하지 않습니다.")
        }
        return token
    }
    private let decoder: JSONDecoder
    
    init() {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        self.decoder = decoder
    }
    
    func requestNowPlayingList(page: Int = 1) async throws -> Movies {
        try await request(endpoint: .nowPlaying, parameters: createListParameters(page: page))
    }
    
    func requestTopRatedList(page: Int = 1) async throws -> Movies {
        try await request(endpoint: .topRated, parameters: createListParameters(page: page))
    }
    
    func requestDetail(movieId: Int) async throws -> MovieDetail {
        try await request(
            endpoint: .detail(id: movieId),
            parameters: [
                QueryParameter.languageKey: QueryParameter.languageValue,
                QueryParameter.appendToResponseKey: QueryParameter.detailValue
            ]
        )
    }
    
    func requestWatchProviders(movieId: Int) async throws -> WatchProviders {
        try await request(
            endpoint: .watchProviders(id: movieId),
            parameters: [
                QueryParameter.languageKey: QueryParameter.languageValue
            ]
        )
    }
    
    func requestSearch(query: String, page: Int = 1) async throws -> Movies {
        try await request(
            endpoint: .search(query: query),
            parameters: [
                QueryParameter.languageKey: QueryParameter.languageValue,
                QueryParameter.queryKey: query,
                QueryParameter.adultKey: QueryParameter.adultValue,
                QueryParameter.pageKey: page
            ]
        )
    }
    
    private func createListParameters(page: Int) -> [String: Any] {
        return [
            QueryParameter.languageKey: QueryParameter.languageValue,
            QueryParameter.pageKey: page,
            QueryParameter.regionKey: QueryParameter.regionValue
        ]
    }
    
    private func createDetailParameters(movieId: Int) -> [String: Any] {
        return [
            QueryParameter.movieIdKey: movieId,
            QueryParameter.languageKey: QueryParameter.languageValue
        ]
    }
    
    private func request<T: Codable>(endpoint: Endpoint, parameters: [String: Any]) async throws -> T {
        let url = "\(baseUrl)\(endpoint.path)"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "accept": "application/json"
        ]
        
        return try await AF.request(
            url,
            method: .get,
            parameters: parameters,
            encoding: URLEncoding.default, // get 요청 -> URLEncoding
            headers: headers
        )
            .validate() // 상태 코드 200...299: 성공, 그외: 에러 리턴
            .serializingDecodable(T.self, decoder: decoder)
            .value
    }
}
