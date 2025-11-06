//
//  DataStore.swift
//  MovieDiary
//
//  Created by openobject2 on 10/20/25.
//

import SwiftData

@MainActor
class DataStore {
    static let shared = DataStore()
    let container: ModelContainer
    
    private init() {
        let schema = Schema([
            Diary.self
        ])
        
        let config = ModelConfiguration(schema: schema)
        
        do {
            container = try ModelContainer(for: schema, configurations: config)
        } catch {
            fatalError("ModelContainer를 생성하는데 실패했습니다: \(error)")
        }
    }
}
