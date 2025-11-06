//
//  ChartSamples.swift
//  MovieDiary
//
//  Created by openobject2 on 10/30/25.
//

import os
import SwiftUI
import HorizonCalendar
import EventKit
import Charts
import SwiftData
import Kingfisher

struct ChartData: Identifiable {
    let genre: Genre
    let count: Int
    
    let id: UUID = UUID()
}

struct ChartViews: View {
    @EnvironmentObject private var viewModel: InfoViewModel
    
    // bar chart
    @State private var selectedGenre: Genre? = nil
    @State private var selectedGenreAngle: Int? = nil
    
    // line chart
    @State var xSelection: String? = nil
    @State var genreSelection: Genre? = nil
    
    @State private var showSheet: Bool = false
    
    let diaries: [Diary]
    
    private var groupedDiaries: [Genre: [Diary]] {
        var grouped = [Genre: [Diary]]()
        
        diaries.forEach { diary in
            diary.genres.forEach { genre in
                grouped[genre] = (grouped[genre] ?? []) + [diary]
            }
        }
        return grouped
    }
    
    private var selectedGenreDiaries: [Diary] {
        return groupedDiaries
            .filter { $0.key.id == selectedGenre?.id }
            .first?
            .value ?? []
    }
    
    private var chartData: Array<ChartData> {
        let sorted = groupedDiaries.sorted { data0, data1 in
            if data0.value.count > data1.value.count {
                return true
            } else if data0.value.count < data1.value.count {
                return false
            } else {
                return data0.key.name < data1.key.name
            }
        }
        var array = Array<ChartData>()
        
        for i in sorted.indices {
            array.append(ChartData(genre: sorted[i].key, count: sorted[i].value.count))
        }
        return array
    }
    
    var body: some View {
        
    }
    
    @ViewBuilder
    private var barChart: some View {
        Chart(chartData, id: \.id) { data in
            BarMark(
                x: .value("장르", data.genre.name),
                yStart: .value("개수", 0),
                yEnd: .value("개수", data.count),
                width: .fixed(20)
            )
//            .annotation(position: .bottom) {
//                VStack(alignment: .center) {
//                    Rectangle()
//                        .frame(width: 1, height: 5)
//                    Text(data.genre.name)
//                        .font(.caption)
//                        .frame(maxWidth: 40)
//                }
//            }
            .foregroundStyle(by: .value("장르", data.genre.name))
        }
        .chartScrollableAxes(.horizontal)
        .chartLegend(.hidden)
        .chartXVisibleDomain(length: 8)
        .chartXAxis {
            AxisMarks { value in
                // x축에 라벨만 표시
                AxisValueLabel()
                    .foregroundStyle(Color.primary)
                
                // y=0 그리드 라인만 표시
                if value.index == 0 {
                    AxisGridLine(stroke: StrokeStyle(lineWidth: 1))
                        .foregroundStyle(Color.primary)
                }
            }
        }
        .chartYAxis {
            AxisMarks { value in
                // x=0 그리드 라인만 표시
                if value.index == 0 {
                    AxisGridLine(stroke: StrokeStyle(lineWidth: 1))
                        .foregroundStyle(Color.primary)
                }
            }
        }
    }
    
    @ViewBuilder
    var lineChart: some View {
        let gradient = LinearGradient(
            gradient: Gradient(colors: [.indigo, .clear]),
            startPoint: .top,
            endPoint: .bottom
        )
        
        Chart(chartData, id: \.genre.id) { data in
            let x = PlottableValue.value("장르", data.genre.name)
            let y = PlottableValue.value("개수", data.count)
            
            // 선택한 장르 하이라이트 선
            if genreSelection?.id == data.genre.id {
                RuleMark(x: x)
                    .lineStyle(StrokeStyle(lineWidth: 1))
                    .foregroundStyle(.gray)
                
                RuleMark(y: y).foregroundStyle(.gray)
                    .lineStyle(StrokeStyle(lineWidth: 1))
                    .foregroundStyle(.gray)
            }
            
            // 라인 차트 배경 그라데이션
            AreaMark(x: x, y: y)
                .interpolationMethod(.cardinal(tension: 0.1))
                .foregroundStyle(gradient)
            
            // 라인 차트
            LineMark(x: x, y: y)
                .interpolationMethod(.cardinal(tension: 0.1))
                .foregroundStyle(.indigo)
                .foregroundStyle(by: .value("", "장르"))
                .symbol {
                    ChartSymbolWithMarker(
                        genreName: data.genre.name,
                        count: data.count,
                        isSelected: genreSelection?.id == data.genre.id
                    )
                }
        }
        .chartXVisibleDomain(length: 8)
        .chartYVisibleDomain(length: 5)
        .chartScrollableAxes(.horizontal)
        .chartLegend(.hidden)
        .chartXSelection(value: $xSelection)
        .onChange(of: xSelection, { oldValue, newValue in
            if let selected = chartData.first(where: { data in
                data.genre.name == newValue
            }) {
                genreSelection = selected.genre
            }
        })
        .chartXAxis {
            AxisMarks { value in
                AxisValueLabel()
                
                AxisTick(centered: true, length: 5, stroke: StrokeStyle(lineWidth: 1))
                    .offset(y: -2.5)
                
                if value.index == 0 {
                    AxisGridLine(stroke: StrokeStyle(lineWidth: 1))
                }
            }
            
        }
        .chartYAxis {
            AxisMarks(position: .leading) { value in
                AxisValueLabel()
                
                if value.index == 0 {
                    AxisGridLine(stroke: StrokeStyle(lineWidth: 1))
                } else {
                    AxisGridLine(stroke: StrokeStyle(lineWidth: 1, dash: [3, 2]))
                }
            }
        }
    }
}

// 심볼 마커
struct ChartSymbolWithMarker: View {
    let genreName: String
    let count: Int
    let isSelected: Bool
    private let symbolOffset: CGSize
    
    init(genreName: String, count: Int, isSelected: Bool) {
        self.genreName = genreName
        self.count = count
        self.isSelected = isSelected
        self.symbolOffset = if isSelected {
            if count > 2 {
                .init(width: 0, height: 35)
            } else {
                .init(width: 0, height: -35)
            }
        } else {
            .zero
        }
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            if isSelected {
                tooltip.offset(symbolOffset)
            }
            Circle()
                .fill(.white)
                .strokeBorder(.indigo, lineWidth: 2)
                .shadow(color: .gray, radius: 1)
                .frame(width: 10, height: 10)
        }
    }
    
    @ViewBuilder
    var tooltip: some View {
        ZStack(alignment: .center) {
            RoundedRectangle(cornerRadius: 5)
                .foregroundStyle(.gray.opacity(0.8))
            Text("\(genreName)\n\(count)")
                .font(.caption)
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: 60)
                .frame(height: 40)
        }
        .fixedSize(horizontal: false, vertical: true)
        .frame(maxWidth: 60)
        .frame(height: 30)
    }
}
