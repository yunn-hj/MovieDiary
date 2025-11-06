//
//  Diary.swift
//  MovieDiary
//
//  Created by openobject2 on 10/20/25.
//

import Foundation
import SwiftData
import UIKit

@Model
class Diary {
    @Attribute(.unique) var id: UUID
    var movieId: Int    // 영화 id (tmdb)
    var title: String   // 영화 제목
    var content: String // 감상평 내용
    var genres: [Genre] // 영화 장르
    var ratings: Double // 별점
    var location: String?       // 감상 장소
    var posterPath: String?     // 영화 포스터 경로 (tmdb)
    @Attribute(.externalStorage) var images: [Data] // 첨부 사진
    var createdAt: Date // 작성 시간
    var updatedAt: Date // 수정 시간
    
    init(
        id: UUID = UUID(),
        movieId: Int,
        title: String,
        content: String,
        genres: [Genre],
        ratings: Double,
        location: String? = nil,
        posterPath: String? = nil,
        images: [Data] = [],
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.movieId = movieId
        self.title = title
        self.content = content
        self.genres = genres
        self.ratings = ratings
        self.location = location
        self.posterPath = posterPath
        self.images = images
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
