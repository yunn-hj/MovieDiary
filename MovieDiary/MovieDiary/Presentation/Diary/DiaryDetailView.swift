//
//  DiaryDetailView.swift
//  MovieDiary
//
//  Created by openobject2 on 10/17/25.
//

import os
import SwiftUI

struct DiaryDetailView: View {
    private let logger = Logger(subsystem: "com.MovieDiary.DiaryDetailView", category: "View")
    
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject private var infoViewModel: InfoViewModel
    @EnvironmentObject private var diaryViewModel: DiaryViewModel
    
    @State private var ratings: Double
    @State private var content: String
    @State private var placeName: String = ""
    @State private var images: [UIImage] = []
    @State private var showLocationSheet: Bool = false
    
    let diary: Diary
    private var isCreating: Bool = false
    
    init(diary: Diary) {
        self.diary = diary
        self.isCreating = diary.content.isEmpty
        
        self._ratings = State(initialValue: diary.ratings)
        self._content = State(initialValue: diary.content)
        self._placeName = State(initialValue: diary.location ?? "장소 추가")
        
        let initialImages = diary.images.compactMap { data in
            UIImage(data: data)
        }
        self._images = State(initialValue: initialImages)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                NavigationLink {
                    MovieDetailView(
                        detailState: infoViewModel.detail,
                        providerState: infoViewModel.watchProviders
                    )
                    .onAppear {
                        infoViewModel.requestMovieDetail(id: diary.movieId)
                        infoViewModel.requestWatchProviders(id: diary.movieId)
                    }
                    .environment(\.isInsideDiaryDetail, true)
                } label: {
                    VStack(alignment: .leading) {
                        OriginalImage(path: diary.posterPath ?? "", defaultName: "photo")
                            .padding(.bottom)
                        
                        Text(diary.title)
                            .bold()
                            .font(.title)
                            .foregroundStyle(Color.primary)
                    }
                }
                
                let genres = diary.genres.map { genre in
                    genre.name
                }.joined(separator: ",")
                
                Text(genres)
                    .foregroundStyle(.gray)
                    .padding(.bottom)
                
                HStack(alignment: .center) {
                    StarRatingsView(ratings: $ratings).padding(.bottom, 10)
                    Text(String(format: "(%.1f점)", ratings)).foregroundStyle(.gray)
                }

                TextField("내용", text: $content, axis: .vertical)
                    .submitLabel(.continue)
                    .padding(.bottom)
                
                location.padding(.bottom, 5)
                addImagesButton.padding(.bottom)
                addedImages
                
                Spacer()
            }
            .padding()
        }
        .toolbar {
            ToolbarItem {
                Button(action: saveChanges) {
                    Image(systemName: "checkmark")
                }
            }
        }
        .toolbarVisibility(.hidden, for: .tabBar)
        .sheet(isPresented: $showLocationSheet) {
            LocationSheet(placeName: $placeName)
        }
    }
    
    @ViewBuilder
    var location: some View {
        Button(action: {
            _showLocationSheet.wrappedValue.toggle()
        }, label: {
            Label(placeName, systemImage: "location.fill").foregroundStyle(.blue)
        })
    }
    
    @ViewBuilder
    var addImagesButton: some View {
        PhotoPicker(selectedImages: $images) {
            Label("사진 첨부", systemImage: "photo").foregroundStyle(.blue)
        }
    }
    
    @ViewBuilder
    var addedImages: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .center, spacing: 5) {
                ForEach(images, id: \.self) { image in
                    addedImage(image)
                }
            }
        }
    }
    
    @ViewBuilder
    func addedImage(_ image: UIImage) -> some View {
        // .topTrailing으로 정렬하면 오른쪽 위 상단의 버튼 클릭 시 좌우 스크롤의 시작 동작으로 판단함
        // -> 삭제 버튼 클릭 영역이 버튼을 벗어남
        // -> .topLeading으로 정렬 시 발생 x
        ZStack(alignment: .topLeading) {
            NavigationLink {
                PhotoDetailView(image: image)
            } label: {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 200, height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
            }

            Button(action: {
                if let index = images.firstIndex(of: image) {
                    images.remove(at: index)
                }
            }, label: {
                Image(systemName: "xmark.circle.fill")
                    .foregroundStyle(.gray)
                    .padding(10)
            })
        }
    }
    
    private func saveChanges() {
        Task {
            diary.content = content
            diary.ratings = ratings
            diary.location = placeName
            diary.images = images.compactMap { image in
                image.jpegData(compressionQuality: 0.8)
            }
            diary.updatedAt = Date()
            
            if isCreating {
                diaryViewModel.insertDiary(diary)
            }
            
            await MainActor.run {
                dismiss()
            }
        }
    }
    
    
}
