//
//  WatchProviders.swift
//  MovieDiary
//
//  Created by openobject2 on 10/13/25.
//
//  다시보기 목록
//

struct WatchProvider: Codable, Identifiable {
    let logoPath: String
    let providerId: Int
    let providerName: String
    let displayPriority: Int
    
    var id: Int { providerId }
}

struct CountryProvider: Codable {
    let link: String
    let flatrate: [WatchProvider]?
    let buy: [WatchProvider]?
}

nonisolated struct WatchProviders: Codable {
    let id: Int
    let results: [String : CountryProvider]
}
