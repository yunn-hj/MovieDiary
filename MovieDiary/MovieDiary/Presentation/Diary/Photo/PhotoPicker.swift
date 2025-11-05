//
//  PhotoPicker.swift
//  MovieDiary
//
//  Created by openobject2 on 10/21/25.
//

import SwiftUI
import PhotosUI

struct PhotoPicker<Content: View>: View {
    @State private var selectedPhotos: [PhotosPickerItem] = []
    @Binding var selectedImages: [UIImage]
    private var content: () -> Content
    
    init(
        selectedImages: Binding<[UIImage]>,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self._selectedImages = selectedImages
        self.content = content
    }
    
    var body: some View {
        PhotosPicker(
            selection: $selectedPhotos,
            maxSelectionCount: 5
        ) {
            content()
        }
        .onChange(of: selectedPhotos) { oldValue, newValue in
            Task {
                var newImages: [UIImage] = []
                
                for item in newValue {
                    // 선택한 photosPickerItem의 data를 비동기 로드
                    if let data = try? await item.loadTransferable(type: Data.self) {
                        // Data -> UIImage 변환
                        if let image = UIImage(data: data) {
                            newImages.append(image)
                        }
                    }
                }
                
                // 로딩 완료 시 메인 스레드에서 선택한 이미지들로 배열 교체
                await MainActor.run {
                    selectedImages = newImages
                }
            }
        }
    }
}
