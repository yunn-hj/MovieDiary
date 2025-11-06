//
//  DiaryListSheet.swift
//  MovieDiary
//
//  Created by openobject2 on 10/29/25.
//

import SwiftUI

struct DiaryListSheet: View {
    let diaries: [Diary]
    let title: String
    
    var body: some View {
        NavigationStack {
            List(diaries) { diary in
                NavigationLink(value: diary) {
                    DiaryItemView(diary: diary)
                }
            }
            .navigationDestination(for: Diary.self) { diary in
                DiaryDetailView(diary: diary)
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
