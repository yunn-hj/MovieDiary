//  AppAssembly.swift
//  MovieDiary
//
//  Created by openobject2 on 10/14/25.
//
//  의존성 등록
//

import Foundation
import Swinject
import SwiftData

// 의존성 등록
final class AppAssembly: Assembly {
    func assemble(container: Container) {
        
        // MovieServiceProtocol을 요청하면 MovieService 싱글턴 인스턴스를 반환
        container.register(MovieServiceProtocol.self) { _ in
            MovieService()
        }.inObjectScope(.container) // 앱이 실행되는 동안 하나의 인스턴스만 유지
        
        container.register(LocationServiceProtocol.self) { _ in
            LocationService()
        }.inObjectScope(.container)
        
        // InfoViewModel을 요청하면 MovieServiceProtocol을 주입해서 생성
        container.register(InfoViewModel.self) { resolver in
            let service = resolver.resolve(MovieServiceProtocol.self)!
            return InfoViewModel(service: service)
        }
        
        container.register(DiaryViewModel.self) { (resolver: Resolver, modelContext: ModelContext) in
            return DiaryViewModel(modelContext: modelContext)
        }
        
        container.register(LocationViewModel.self) { resolver in
            let service = resolver.resolve(LocationServiceProtocol.self)!
            return LocationViewModel(service: service)
        }
        
        container.register(CameraViewModel.self) { resolver in
            return CameraViewModel()
        }
        
        // ContentView를 요청하면 ViewModel을 주입해서 생성
        container.register(ContentView.self) { resolver in
            let infoViewModel = resolver.resolve(InfoViewModel.self)!
            let diaryViewModel = resolver.resolve(DiaryViewModel.self)!
            let locationViewModel = resolver.resolve(LocationViewModel.self)!
            let cameraViewModel = resolver.resolve(CameraViewModel.self)!
            
            return ContentView(
                infoViewModel: infoViewModel,
                diaryViewModel: diaryViewModel,
                locationViewModel: locationViewModel,
                cameraViewModel: cameraViewModel
            )
        }
    }
}
