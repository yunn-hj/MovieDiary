//
//  ReviewView.swift
//  MovieDiary
//
//  Created by openobject2 on 10/27/25.
//

import SwiftUI
import Kingfisher

struct ReviewView: View {
    let type: MovieDetailType
    let reviews: [Review]
    private let count: Int
    private let title: String
    
    init(type: MovieDetailType, reviews: [Review]) {
        self.type = type
        self.reviews = reviews
        
        self.title = switch type {
        case .summary: "상세 정보"
        case .all: "리뷰"
        }
        
        self.count = switch type {
        case .summary: if reviews.count > 3 {
            3
        } else if reviews.count <= 0 {
            0
        } else {
            reviews.count - 1
        }
        case .all: reviews.count - 1
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(reviews[0...count], id: \.self) { review in
                reviewItem(review, type: type)
            }
            Spacer()
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder
    func reviewItem(_ review: Review, type: MovieDetailType) -> some View {
        if let url = URL(string: review.url) {
            Link(destination: url) {
                VStack(alignment: .leading) {
                    HStack(alignment: .center) {
                        LowImage(
                            path: review.authorDetails.avatarPath ?? "",
                            defaultName: "person.fill",
                            clipShape: .circle
                        )
                        .frame(width: 20, height: 20)
                        Text(review.author).foregroundStyle(Color.primary)
                        Spacer()
                    }
                    
                    switch type {
                    case .summary:
                        Text(review.content)
                            .foregroundStyle(Color.primary)
                            .lineLimit(2)
                    case .all:
                        Text(review.content)
                            .foregroundStyle(Color.primary)
                    }
                    
                    if let date = review.createdDate() {
                        Text(date.toString("yyyy년 MM월 dd일 HH시 mm분"))
                            .font(.caption)
                            .foregroundStyle(.gray)
                    }
                }
                .padding(.bottom)
            }
        } else {
            EmptyView()
        }
    }
}
