//
//  ContentViewWrapper.swift
//  MovieDiary
//
//  Created by openobject2 on 10/20/25.
//

import SwiftUI
import SwiftData
import Swinject

struct ContentViewWrapper: View {
    // 앱 진입점에서 resolver를 전달받음
    let resolver: Resolver
    
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        // modelContext가 준비된 시점에 DiaryViewModel을 생성
        let diaryViewModel = resolver.resolve(DiaryViewModel.self, argument: modelContext)!
        let infoViewModel = resolver.resolve(InfoViewModel.self)!
        let locationViewModel = resolver.resolve(LocationViewModel.self)!
        let cameraViewModel = resolver.resolve(CameraViewModel.self)!
        
        // 생성된 ViewModel들을 실제 ContentView에 주입
        ContentView(
            infoViewModel: infoViewModel,
            diaryViewModel: diaryViewModel,
            locationViewModel: locationViewModel,
            cameraViewModel: cameraViewModel
        )
    }
}
