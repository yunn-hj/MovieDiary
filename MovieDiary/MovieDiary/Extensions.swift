//
//  Extensions.swift
//  MovieDiary
//
//  Created by openobject2 on 10/14/25.
//

import Foundation
import SwiftUI

extension String {
    var byCharWrapping: Self {
        map(String.init).joined(separator: "\u{200B}")
    }
    
    /**
     yyyy-MM-dd -> yyyy년 M월 d일 변환
     */
    func formatDate(_ format: String = "yyyy년 M월 d일") -> String {
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale.current
         
        guard let date = formatter.date(from: self) else {
            return ""
        }
        
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
}

extension Date {
    func toString(_ format: String = "yyyy년 M월 d일") -> String {
        let formatter = DateFormatter()
        
        formatter.dateFormat = format
        formatter.locale = Locale.current
        
        return formatter.string(from: self)
    }
}

// 감상평 -> 영화 상세 정보로 이동했는지 여부
// 감상평 <-> 영화 상세 정보 중첩 이동을 막기 위함
private struct IsInsideDiaryDetailKey: EnvironmentKey {
    static let defaultValue: Bool = false
}

extension EnvironmentValues {
    var isInsideDiaryDetail: Bool {
        get { self[IsInsideDiaryDetailKey.self] }
        set { self[IsInsideDiaryDetailKey.self] = newValue }
    }
}
