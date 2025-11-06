//
//  Review.swift
//  MovieDiary
//
//  Created by openobject2 on 10/27/25.
//

import Foundation

struct Reviews: Codable {
    let results: [Review]
}

struct Review: Codable, Hashable {
    let author: String
    let authorDetails: AuthorDetails
    let content: String
    let createdAt: String
    let updatedAt: String
    let url: String
    
    private func toDate(dateString: String) -> Date? {
        let format = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale.current
        
        return dateFormatter.date(from: dateString)
    }
    
    func createdDate() -> Date? {
        return toDate(dateString: createdAt)
    }
    
    func updatedDate() -> Date? {
        return toDate(dateString: updatedAt)
    }
}

struct AuthorDetails: Codable, Hashable {
    let name: String
    let username: String
    let avatarPath: String?
    let rating: Int?
}
