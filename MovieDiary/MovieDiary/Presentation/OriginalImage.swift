//
//  OriginalImage.swift
//  MovieDiary
//
//  Created by openobject2 on 10/16/25.
//

import SwiftUI
import Kingfisher

struct OriginalImage: View {
    let path: String
    let defaultName: String?
    let ratio: CGFloat
    let radius: CGFloat
    private let url: URL?
    private let processor: DefaultImageProcessor
    
    init(path: String, defaultName: String? = nil, ratio: CGFloat = 515/728, radius: CGFloat = 10) {
        self.path = path
        self.defaultName = defaultName
        self.ratio = ratio
        self.radius = radius
        self.url = URL(string: "https://image.tmdb.org/t/p/original/\(path)")
        self.processor = DefaultImageProcessor()
    }
    
    var body: some View {
        KFImage.url(url)
            .placeholder {
                if defaultName != nil {
                    Image(systemName: defaultName!).foregroundStyle(.gray)
                } else {
                    ProgressView()
                }
            }
            .setProcessor(processor)
            .loadDiskFileSynchronously()
            .cacheMemoryOnly()
            .fade(duration: 0.25)
            .onProgress { receivedSize, totalSize in  }
            .onSuccess { result in  }
            .onFailure { error in }
            .resizable()
            .scaledToFit()
            .aspectRatio(ratio, contentMode: .fill)
            .clipShape(RoundedRectangle(cornerRadius: radius))
    }
}
