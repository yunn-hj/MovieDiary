//
//  Movies.swift
//  MovieDiary
//
//  Created by openobject2 on 10/13/25.
//
//  영화 요약 정보
//

nonisolated struct Movies: Codable, Hashable {
    var dates: Dates? = nil
    let page: Int
    let results: [Movie]
    let totalPages: Int?
    let totalResults: Int?
}

struct Dates: Codable, Hashable {
    let maximum: String
    let minimum: String
}

struct Movie: Codable, Identifiable, Hashable {
    let adult: Bool
    let backdropPath: String?
    let genreIds: [Int]?
    let id: Int
    let originalLanguage: String
    let overview: String
    let popularity: Double?
    let posterPath: String?
    let releaseDate: String?
    let title: String
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?
}
