//
//  DiaryListView.swift
//  MovieDiary
//
//  Created by openobject2 on 10/17/25.
//

import SwiftUI
import SwiftData

enum DiaryListType: CaseIterable {
    case list       // 업데이트순 리스트
    case calendar   // 작성일 달력 표시
    case chart      // 장르별 파이 차트
    
    var title: String {
        switch self {
        case .list: return "목록"
        case .calendar: return "달력"
        case .chart: return "통계"
        }
    }
}

struct DiaryListView: View {
    
    @Query(sort: \Diary.updatedAt, order: .reverse) private var diaries: [Diary]
    @EnvironmentObject private var diaryViewModel: DiaryViewModel
    @Binding private var selectedTab: SelectedTab
    @State private var pickerSelection: DiaryListType
    
    init(selectedTab: Binding<SelectedTab>) {
        self._selectedTab = selectedTab
        self._pickerSelection = State(wrappedValue: .list)
    }
    
    var body: some View {
        List {
            Picker("보기 방식", selection: $pickerSelection) {
                ForEach(DiaryListType.allCases, id: \.self) { type in
                    Text(type.title).tag(type)
                }
            }
            .pickerStyle(.menu)
            
            switch pickerSelection {
            case .list:
                normalList
            case .calendar:
                DiaryCalendar(diaries: diaries)
            case .chart:
                GenreChartView(diaries: diaries)
            }
        }
        .navigationTitle("영화 기록")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(for: Diary.self, destination: { diary in
            DiaryDetailView(diary: diary)
        })
        .toolbar {
            ToolbarItem {
                Button {
                    selectedTab = .info
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
    }
    
    @ViewBuilder
    var normalList: some View {
        ForEach(diaries) { diary in
            NavigationLink(value: diary) {
                DiaryItemView(diary: diary)
            }
        }
        .onDelete(perform: deleteDiaries)
    }
    
    private func deleteDiaries(_ offsets: IndexSet) {
        offsets.forEach { index in
            diaryViewModel.deleteDiary(diaries[index])
        }
    }
}

struct DiaryItemView: View {
    let diary: Diary
    
    var body: some View {
        HStack(alignment: .center) {
            LowImage(path: diary.posterPath ?? "", clipShape: RoundedRectangle(cornerRadius: 5))
                .frame(width: 70)
                .padding(.trailing)
            
            VStack(alignment: .leading) {
                Text(diary.title).lineLimit(1)
                HStack(alignment: .center) {
                    StarRatingsView(ratings: diary.ratings, width: 100)
                    Text(String(format: "(%.1f점)", diary.ratings))
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
                Text(diary.createdAt.toString())
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
        }
    }
}
