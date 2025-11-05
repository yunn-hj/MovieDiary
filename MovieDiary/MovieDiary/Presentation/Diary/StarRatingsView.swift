//
//  StarRatingsView.swift
//  MovieDiary
//
//  Created by openobject2 on 10/20/25.
//
//  드래그로 별점 설정
//

import SwiftUI

struct StarRatingsView: View {
    @Binding private var ratings: Double
    private var maxRatings: Int
    private var width: CGFloat
    private var starSize: CGFloat
    private var starSpacing: CGFloat = 8
    
    init(ratings: Double, maxRatings: Int = 5, width: CGFloat = 150) {
        self._ratings = .constant(ratings)
        self.maxRatings = maxRatings
        self.width = width
        self.starSize = (width - starSpacing * CGFloat(maxRatings - 1)) / CGFloat(maxRatings)
    }
    
    init(ratings: Binding<Double>, maxRatings: Int = 5, width: CGFloat = 150) {
        self._ratings = ratings
        self.maxRatings = maxRatings
        self.width = width
        self.starSize = (width - starSpacing * CGFloat(maxRatings - 1)) / CGFloat(maxRatings)
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: starSpacing) {
            ForEach(1...maxRatings, id: \.self) { index in
                starImage(for: index)
                    .resizable()
                    .foregroundStyle(.yellow)
                    .frame(width: starSize, height: starSize)
            }
        }
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    // 드래그 위치에 따라 별점을 업데이트
                    updateRating(at: value.location, in: self.width)
                }
        )
        .frame(width: width, height: starSize)
    }
    
    private func starImage(for index: Int) -> Image {
        let ratings = self.ratings
        let starIndex = Double(index)
        
        if ratings >= starIndex {
            return Image(systemName: "star.fill")
        } else if ratings >= starIndex - 0.5 {
            return Image(systemName: "star.leadinghalf.fill")
        } else {
            return Image(systemName: "star")
        }
    }
    
    /// 드래그 위치(x좌표)를 0.5 단위의 별점으로 변환하는 함수
    private func updateRating(at point: CGPoint, in width: CGFloat) {
        let percentage = point.x / width    // 전체 너비 중 탭 좌표의 위치 비율
        let rating = percentage * Double(maxRatings)    // 비율을 점수로 변환
        let roundedRating = round(rating * 2) / 2.0     // 점수를 0.5 단위로 변환
        
        // 0 ~ 5점 사이로 보정
        self.ratings = max(0, min(Double(maxRatings), roundedRating))
    }
}
