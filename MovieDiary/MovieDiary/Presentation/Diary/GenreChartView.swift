//
//  GenreChartView.swift
//  MovieDiary
//
//  Created by openobject2 on 10/29/25.
//
//  장르별 파이차트
//

import SwiftUI
import Charts

struct GenreData: Identifiable {
    let genre: Genre
    let range: Range<Int>
    
    let id: UUID = UUID()
}

struct GenreChartView: View {
    @EnvironmentObject private var viewModel: InfoViewModel
    @State private var selectedGenre: Genre? = nil
    @State private var selectedGenreAngle: Int? = nil
    @State private var showSheet: Bool = false
    
    let diaries: [Diary]
    
    // 감상평 목록을 장르별로 묶음
    private var groupedDiaries: [Genre: [Diary]] {
        var grouped = [Genre: [Diary]]()
        
        diaries.forEach { diary in
            diary.genres.forEach { genre in
                grouped[genre] = (grouped[genre] ?? []) + [diary]
            }
        }
        return grouped
    }
    
    // 선택한 장르의 감상평 목록
    private var selectedGenreDiaries: [Diary] {
        return groupedDiaries
            .filter { $0.key.id == selectedGenre?.id }
            .first?
            .value ?? []
    }
    
    // selectedGenreDiaries를 차트에 사용할 수 있도록 변환
    private var chartData: Array<GenreData> {
        let sorted = groupedDiaries.sorted { data0, data1 in
            if data0.value.count > data1.value.count {
                return true
            } else if data0.value.count < data1.value.count {
                return false
            } else {
                return data0.key.name < data1.key.name
            }
        }
        var data = Array<GenreData>()
        var size = 0
        
        for i in sorted.indices {
            let genre = sorted[i].key
            let range = size ..< (size + sorted[i].value.count)
            
            data.append(GenreData(genre: genre, range: range))
            size += sorted[i].value.count
        }
        return data
    }
    
    
    var body: some View {
        Chart {
            ForEach(chartData) { data in
                SectorMark(
                    angle: .value("리뷰 수", data.range),
                    angularInset: 1.5 // 섹터 사이 간격
                )
                .cornerRadius(5)
                .foregroundStyle(by: .value("장르", data.genre.name))
            }
        }
        // 차트 조각 선택
        .chartAngleSelection(value: $selectedGenreAngle)
        .chartLegend(position: .bottom, alignment: .center, spacing: 20)
        .onChange(of: selectedGenreAngle) { oldValue, newValue in
            if let angle = newValue {
                let selected = chartData.first { data in
                    data.range.contains(angle)
                }
                
                if let selectedData = selected {
                    selectedGenre = selectedData.genre
                    showSheet = true
                } else {
                    selectedGenre = nil
                    showSheet = false
                }
            }
        }
        .frame(height: 300)
        .frame(maxWidth: .infinity)
        .sheet(
            isPresented: $showSheet,
            content: {
                DiaryListSheet(diaries: selectedGenreDiaries, title: selectedGenre?.name ?? "")
            }
        )
    }
}
