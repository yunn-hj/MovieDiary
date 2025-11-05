//
//  VideoView.swift
//  MovieDiary
//
//  Created by openobject2 on 10/27/25.
//

import SwiftUI
import YouTubePlayerKit

struct VideoView: View {
    let type: MovieDetailType
    let videos: [Video]
    private let title: String
    
    init(type: MovieDetailType, videos: [Video]) {
        self.type = type
        self.videos = videos
        
        self.title = switch type {
        case .summary: "상세 정보"
        case .all: "관련 영상"
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ForEach(videos, id: \.id) { video in
                    let player = YouTubePlayer(urlString: "https://youtube.com/watch?v=\(video.key)")
                    
                    YouTubePlayerView(player)
                        .frame(maxWidth: .infinity)
                        .aspectRatio(16/9, contentMode: .fill)
                        .padding(.bottom)
                }
                Spacer()
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .frame(maxWidth: .infinity)
        }
    }
}
