//
//  MovieDetail.swift
//  MovieDiary
//
//  Created by openobject2 on 10/13/25.
//
//  영화 상세 정보
//

nonisolated struct MovieDetail: Codable {
    let adult: Bool
    let backdropPath: String
    let belongsToCollection: BelongsToCollection?
    let budget: Int
    let genres: [Genre]
    let homepage: String
    let id: Int
    let imdbId: String
    let originalLanguage: String
    let originalTitle: String
    let overview: String
    let popularity: Double
    let posterPath: String
    let productionCompanies: [ProductionCompany]
    let productionCountries: [ProductionCountry]
    let releaseDate: String
    let revenue: Int
    let runtime: Int
    let spokenLanguages: [SpokenLanguage]
    let status: String
    let tagline: String
    let title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int
    let videos: Videos
    let credits: Credits
    let reviews: Reviews
}

struct BelongsToCollection: Codable {
    let id: Int
    let backdropPath: String
    let name: String
    let posterPath: String
}

struct Genre: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
}

struct ProductionCompany: Codable, Identifiable {
    let id: Int
    let logoPath: String?
    let name: String
    let originCountry: String
}

struct ProductionCountry: Codable, Identifiable {
    let iso31661: String
    let name: String
    
    var id: String { iso31661 }
}

struct SpokenLanguage: Codable, Identifiable {
    let englishName: String
    let iso6391: String
    let name: String
    
    var id: String { iso6391 }
}

struct Videos: Codable {
    let results: [Video]
}

struct Video: Codable, Identifiable {
    let iso6391: String
    let iso31661: String
    let name: String
    let key: String
    let site: String
    let size: Int
    let type: String
    let official: Bool
    let publishedAt: String
    let id: String
}

struct Credits: Codable {
    let cast: [Credit]
    let crew: [Credit]
}

struct Credit: Codable, Identifiable {
    let adult: Bool
    let gender: Int
    let id: Int
    let knownForDepartment: String?
    let name: String
    let originalName: String?
    let popularity: Double
    let profilePath: String?
    let castId: Int?
    let character: String?
    let creditId: String?
    let order: Int?
    let department: String?
    let job: String?
}
