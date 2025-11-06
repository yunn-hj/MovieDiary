//
//  LocationService.swift
//  MovieDiary
//
//  Created by openobject2 on 10/21/25.
//

import Foundation
import Alamofire

protocol LocationServiceProtocol: Actor {
    func requestSearch(query: String) async throws -> Location
}

actor LocationService: LocationServiceProtocol {
    private let url = "https://dapi.kakao.com/v2/local/search/keyword.json"
    private var apiKey: String {
        guard let token = Bundle.main.object(forInfoDictionaryKey: "KAKAO_REST_API_KEY") as? String else {
            fatalError("KAKAO_REST_API_KEY가 Info.plist에 존재하지 않습니다.")
        }
        return token
    }
    private let decoder: JSONDecoder
    
    init() {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        self.decoder = decoder
    }
    
    func requestSearch(query: String) async throws -> Location {
        let headers: HTTPHeaders = [
            "Authorization": "KakaoAK \(apiKey)"
        ]
        let parameters = [
            "query": query
        ]
        
        return try await AF.request(
            url,
            method: .get,
            parameters: parameters,
            encoding: URLEncoding.default, // get 요청 -> URLEncoding
            headers: headers
        )
            .validate() // 상태 코드 200...299: 성공, 그외: 에러 리턴
            .serializingDecodable(Location.self, decoder: decoder)
            .value
    }
}
