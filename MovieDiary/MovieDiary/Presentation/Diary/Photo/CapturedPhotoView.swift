//
//  CapturedPhotoView.swift
//  MovieDiary
//
//  Created by openobject2 on 10/24/25.
//

import SwiftUI
import AVFoundation

struct CapturedPhotoView: View {
    @Environment(\.dismiss) var dismiss
    var image: UIImage
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.black.ignoresSafeArea()
            
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
            
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark")
                        .font(.title)
                        .foregroundStyle(.white)
                        .padding()
                }
                
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "checkmark")
                        .font(.title)
                        .foregroundStyle(.white)
                        .padding()
                }
            }
        }
        .navigationBarBackButtonHidden()
    }
}
