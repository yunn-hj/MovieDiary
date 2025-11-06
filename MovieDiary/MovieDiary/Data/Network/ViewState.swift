//
//  ViewState.swift
//  MovieDiary
//
//  Created by openobject2 on 10/21/25.
//

enum ViewState<T> {
    case idle           // 대기
    case loading        // 로딩 중
    case success(T)     // 성공
    case failure(Error) // 실패
}
