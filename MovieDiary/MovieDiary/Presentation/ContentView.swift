//
//  ContentView.swift
//  MovieDiary
//
//  Created by openobject2 on 10/2/25.
//

import SwiftUI
import SwiftData

enum SelectedTab {
    case diary
    case info
}

struct ContentView: View {
    @StateObject private var infoViewModel: InfoViewModel
    @StateObject private var diaryViewModel: DiaryViewModel
    @StateObject private var locationViewModel: LocationViewModel
    @StateObject private var cameraViewModel: CameraViewModel
    @State private var selectedTab: SelectedTab = .diary
    
    init(
        infoViewModel: InfoViewModel,
        diaryViewModel: DiaryViewModel,
        locationViewModel: LocationViewModel,
        cameraViewModel: CameraViewModel
    ) {
        _infoViewModel = StateObject(wrappedValue: infoViewModel)
        _diaryViewModel = StateObject(wrappedValue: diaryViewModel)
        _locationViewModel = StateObject(wrappedValue: locationViewModel)
        _cameraViewModel = StateObject(wrappedValue: cameraViewModel)
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                DiaryListView(selectedTab: $selectedTab)
            }
            .tabItem {
                Label("기록", systemImage: "long.text.page.and.pencil")
            }
            .tag(SelectedTab.diary)
            
            NavigationStack {
                MovieListView()
            }.tabItem {
                Label("영화 정보", systemImage: "movieclapper")
            }
            .tag(SelectedTab.info)
        }
        // 최상위 뷰에서 뷰모델을 environment에 주입, 하위 뷰 전체에 의존성 공유
        // environment: 뷰의 환경값. 하위 뷰와 공유 가능
        .environmentObject(diaryViewModel)
        .environmentObject(infoViewModel)
        .environmentObject(locationViewModel)
        .environmentObject(cameraViewModel)
    }
    
    private func fetchMovies(for type: MovieListType) {
        switch type {
        case .nowPlaying:
            infoViewModel.requestNowPlaying()
        case .topRated:
            infoViewModel.requestTopRated()
        }
    }
}
