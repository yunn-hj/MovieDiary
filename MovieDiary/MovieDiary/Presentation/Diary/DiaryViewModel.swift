//
//  DiaryViewModel.swift
//  MovieDiary
//
//  Created by openobject2 on 10/14/25.
//
//  감상평 관련 로직
//

import Combine
import SwiftUI
import SwiftData

final class DiaryViewModel: ObservableObject {
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func insertDiary(_ diary: Diary) {
        modelContext.insert(diary)
    }
    
    func updateDiary(_ diary: Diary, title: String? = nil, content: String? = nil, ratings: Double? = nil, location: String? = nil, images: [Data]? = nil) {
        if title != nil {
            diary.title = title!
        }
        if content != nil {
            diary.content = content!
        }
        if ratings != nil {
            diary.ratings = ratings!
        }
        if location != nil {
            diary.location = location!
        }
        if images != nil {
            diary.images = images!
        }
    }
    
    func deleteDiary(_ diary: Diary) {
        modelContext.delete(diary)
    }
}
