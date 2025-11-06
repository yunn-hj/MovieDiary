//
//  DiaryCalendar.swift
//  MovieDiary
//
//  Created by openobject2 on 10/28/25.
//

import os
import SwiftUI
import HorizonCalendar
import EventKit

struct DiarySheetData: Identifiable {
    let id = UUID()
    let date: Date
    let diaries: [Diary]
}

struct DiaryCalendar: View {
    private let logger = Logger(subsystem: "com.MovieDiary.DiaryCalendar", category: "View")
    
    @StateObject private var proxy = CalendarViewProxy()
    private let calendar: Calendar
    private let startDate: Date
    private let endDate: Date
    private let dateFormatter: DateFormatter
    
    let diaries: [Diary]
    private let diaryDays: [String]
    
    @State private var sheetData: DiarySheetData? = nil
    @State private var selectedDate: Date? = nil

    init(diaries: [Diary]) {
        self.calendar = Calendar.current
        self.startDate = calendar.date(from: DateComponents(year: 1970, month: 01, day: 01))!
        self.endDate = Date()
        self.diaries = diaries
        self.diaryDays = diaries.map { diary in
            diary.createdAt.toString("yyyyMMdd")
        }
        self.dateFormatter = DateFormatter()
        self.dateFormatter.locale = Locale(identifier: "ko_KR")
    }
    
    var body: some View {
        CalendarViewRepresentable(
          calendar: calendar,
          visibleDateRange: startDate...endDate,
          monthsLayout: .vertical(options: VerticalMonthsLayoutOptions()),
          dataDependency: nil,
          proxy: proxy
        )
        .monthHeaders { month in
            HStack(alignment: .bottom) {
                Text("\(month.month)월").font(.title)
                Text("\(String(month.year))년").font(.headline)
                Spacer()
            }
            .padding(.bottom)
            .padding(.leading)
        }
        .dayOfWeekHeaders { month, weekdayIndex in
            if let shortSymbols = dateFormatter.shortWeekdaySymbols, (0...6).contains(weekdayIndex) {
                let shortDayName = shortSymbols[weekdayIndex]
                let color = getTextColor(weekdayIndex: weekdayIndex)
                
                Text(shortDayName).foregroundStyle(color)
            }
        }
        .days { day in
            let dateString = toDateString(day: day)
            
            Text("\(day.day)")
                .font(.system(size: 18))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .overlay {
                    if diaryDays.contains(dateString) {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(UIColor.systemBlue), lineWidth: 1)
                    }
                }
        }
        // 날짜 선택
        .onDaySelection { day in
            let dateString = toDateString(day: day)
            
            if diaryDays.contains(dateString) {
                let selectedDate = calendar.date(from: day.components)!
                let filtered = diaries.filter {
                    $0.createdAt.toString("yyyyMMdd") == dateString
                }
                self.sheetData = DiarySheetData(date: selectedDate, diaries: filtered)
            } else {
                self.sheetData = nil
            }
        }
        .backgroundColor(.clear)
        .layoutMargins(.init(top: 8, leading: 0, bottom: 8, trailing: 0))
        .interMonthSpacing(36)
        .verticalDayMargin(8)
        .horizontalDayMargin(8)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            proxy.scrollToDay(containing: .now, scrollPosition: .centered, animated: false)
        }
        .sheet(
            item: $sheetData,
            onDismiss: {
                sheetData = nil
            },
            content: { data in
                DiaryListSheet(diaries: data.diaries, title: data.date.toString("yyyy년 M월 d일"))
            }
        )
    }
    
    private func getTextColor(weekdayIndex: Int) -> Color {
        return switch weekdayIndex {
        case 0: Color.red
        case 6: Color.blue
        default: Color.primary
        }
    }
    
    private func toDateString(day: DayComponents) -> String {
        let monthString = if day.month.month < 10 {
            "0\(day.month.month)"
        } else {
            "\(day.month.month)"
        }
        let dayString = if day.day < 10 {
            "0\(day.day)"
        } else {
            "\(day.day)"
        }
        return "\(day.month.year)\(monthString)\(dayString)"
    }
}
