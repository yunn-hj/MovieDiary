//
//  FloatingDiaryButton.swift
//  MovieDiary
//
//  Created by openobject2 on 10/20/25.
//

import SwiftUI
import SwiftData

struct FloatingDiaryButton: View {
    private let detail: MovieDetail
    @Query private var diaries: [Diary]
    
    private var diary: Diary {
        if diaries.isEmpty {
            Diary(
                movieId: detail.id,
                title: detail.title,
                content: "",
                genres: detail.genres,
                ratings: 0,
                posterPath: detail.posterPath
            )
        } else {
            diaries.first!
        }
    }
    
    init(detail: MovieDetail) {
        let predicate = #Predicate<Diary> { $0.movieId == detail.id }
        _diaries = Query(filter: predicate, sort: \.createdAt, order: .reverse)
        self.detail = detail
    }
    
    var body: some View {
        NavigationLink {
            DiaryDetailView(diary: diary)
        } label: {
            HStack {
                Spacer()
                Text(diary.content.isEmpty ? "감상평 쓰러가기" : "감상평 보러가기")
                    .bold()
                    .font(.headline)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 16)
                    .background(.blue)
                    .foregroundStyle(.white)
                    .clipShape(Capsule())
                    .shadow(radius: 5, y: 3)
                Spacer()
            }
        }
    }
}
