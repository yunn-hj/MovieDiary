//
//  Location.swift
//  MovieDiary
//
//  Created by openobject2 on 10/21/25.
//

nonisolated struct Location: Codable {
    let meta: Meta
    let documents: [Document]
}

struct Meta: Codable {
    let totalCount: Int
    let pageableCount: Int
    let isEnd: Bool
    let sameName: SameName
}

struct SameName: Codable {
    let region: [String]
    let keyword: String
    let selectedRegion: String
}

struct Document: Codable {
    let id: String
    let placeName: String
    let categoryName: String
    let categoryGroupCode: String
    let categoryGroupName: String
    let phone: String
    let addressName: String
    let roadAddressName: String
    let x: String
    let y: String
    let placeUrl: String
    let distance: String
}
