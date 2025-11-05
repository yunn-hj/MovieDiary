//
//  MovieDiaryApp.swift
//  MovieDiary
//
//  Created by openobject2 on 10/2/25.
//

import SwiftUI
import SwiftData
import Swinject

@main
struct MovieDiaryApp: App {
    // swinject assembler
    let assembler: Assembler
    let modelContainer = DataStore.shared.container

    init() {
        assembler = Assembler([AppAssembly()])
    }
    
    var body: some Scene {
        WindowGroup {
            ContentViewWrapper(resolver: assembler.resolver)
        }
        .modelContainer(modelContainer)
    }
}
