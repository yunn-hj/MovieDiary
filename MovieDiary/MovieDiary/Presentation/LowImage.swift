//
//  LowImage.swift
//  MovieDiary
//
//  Created by openobject2 on 10/28/25.
//

import SwiftUI
import Kingfisher

struct LowImage: View {
    let path: String
    let defaultName: String?
    let clipShape: AnyShape?
    private let url: URL?
    private let processor: DefaultImageProcessor
    
    init(path: String, defaultName: String? = nil) {
        self.path = path
        self.defaultName = defaultName
        self.clipShape = nil
        self.url = URL(string: "https://image.tmdb.org/t/p/w500/\(path)")
        self.processor = DefaultImageProcessor()
    }
    
    init<S: Shape>(path: String, defaultName: String? = nil, clipShape: S) {
        self.path = path
        self.defaultName = defaultName
        self.clipShape = AnyShape(clipShape)
        self.url = URL(string: "https://image.tmdb.org/t/p/w500/\(path)")
        self.processor = DefaultImageProcessor()
    }
    
    var body: some View {
        let image = KFImage.url(url)
            .placeholder { _ in
                if defaultName == nil {
                    ProgressView()
                } else {
                    Image(systemName: defaultName!).foregroundStyle(.gray)
                }
            }
            .setProcessor(processor)
            .loadDiskFileSynchronously()
            .cacheMemoryOnly()
            .fade(duration: 0.25)
            .resizable()
            .scaledToFit()
            
        if clipShape == nil {
            image
        } else {
            image.clipShape(clipShape!)
        }
    }
}
