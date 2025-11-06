//
//  MovieListView.swift
//  MovieDiary
//
//  Created by openobject2 on 10/15/25.
//
//  영화 정보 탭 메인 화면
//

import os
import SwiftUI
import Alamofire

enum MovieListType: CaseIterable {
    case nowPlaying
    case topRated
    
    var title: String {
        switch self {
        case .nowPlaying: return "상영 중인 영화"
        case .topRated: return "역대 인기 영화"
        }
    }
}

struct MovieListView: View {
    private let logger = Logger(subsystem: "com.MovieDiary.MovieListView", category: "View")
    
    @State private var pickerSelection: MovieListType = .nowPlaying
    @State private var movieSelection: Movie.ID?
    @State private var searchQuery: String = ""
    
    @EnvironmentObject private var infoViewModel: InfoViewModel
    
    var body: some View {
        let movies = getSearchResults()
            
        VStack {
            picker()
            
            switch movies {
            case .idle, .loading:
                ProgressView()
            case .success(let movies):
                movieListView(movies: movies)
            case .failure(let error):
                Text("에러 발생: \(error.localizedDescription)")
            }
            Spacer()
        }
        .navigationTitle(searchQuery.isEmpty ? "영화 정보" : "검색 결과")
        .navigationBarTitleDisplayMode(.inline)
        .searchable(
            text: $searchQuery,
            placement: .navigationBarDrawer(displayMode: .automatic),
            prompt: "검색어를 입력하세요"
        )
        .onSubmit(of: .search) {
            guard !searchQuery.isEmpty else { return }
            infoViewModel.requestSearch(query: searchQuery, page: 1)
        }
        .onAppear {
            fetchMovies(for: pickerSelection)
        }
        .onChange(of: pickerSelection) { _, newSelection in
            fetchMovies(for: pickerSelection)
        }
    }
    
    @ViewBuilder
    private func picker() -> some View {
        Picker("", selection: $pickerSelection) {
            ForEach(MovieListType.allCases, id: \.self) { type in
                Text(type.title).tag(type)
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)
    }
    
    @ViewBuilder
    private func movieListView(movies: [Movie]) -> some View {
        if movies.isEmpty {
            Text(searchQuery.isEmpty ? "영화를 불러올 수 없습니다." : "검색 결과가 없습니다.")
                .padding()
            Spacer()
        } else {
            let columns = [
                GridItem(.flexible()),
                GridItem(.flexible())
            ]
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(movies) { movie in
                        NavigationLink(value: movie) {
                            MovieItemView(movie: movie)
                        }
                    }
                }
                .padding()
                Spacer()
            }
            .frame(maxHeight: .infinity)
            .scrollIndicators(.hidden)
            .navigationDestination(for: Movie.self) { movie in
                MovieDetailView(
                    detailState: infoViewModel.detail,
                    providerState: infoViewModel.watchProviders
                )
                .onAppear {
                    infoViewModel.requestMovieDetail(id: movie.id)
                    infoViewModel.requestWatchProviders(id: movie.id)
                }
                .environment(\.isInsideDiaryDetail, false)
            }
        }
    }
    
    private func fetchMovies(for type: MovieListType) {
        switch type {
        case .nowPlaying:
            infoViewModel.requestNowPlaying()
        case .topRated:
            infoViewModel.requestTopRated()
        }
    }
    
    private func getSearchResults() -> ViewState<[Movie]> {
        if searchQuery.isEmpty {
            infoViewModel.movies
        } else {
            switch infoViewModel.searchResults {
            case .success, .failure:
                infoViewModel.searchResults
            case .idle, .loading:
                infoViewModel.movies
            }
        }
    }
}

struct MovieItemView: View {
    let movie: Movie
    
    var body: some View {
        VStack(alignment: .leading) {
            OriginalImage(path: movie.posterPath ?? "photo")
                .padding(.bottom, 10)
            
            Text(movie.title)
                .lineLimit(1)
                .font(.title3)
                .foregroundStyle(Color.primary)
                .frame(maxWidth: 200, alignment: .leading)
                .padding(.bottom, 3)
            
            if let popularity = movie.popularity {
                Text("인기도 \(String(format: "%.1f", popularity))")
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
            
            if let releaseDate = movie.releaseDate {
                Text("개봉일 \(releaseDate.formatDate())")
                    .font(.caption)
                    .foregroundStyle(.gray)
                    .padding(.bottom, 20)
            }
        }
    }
}
