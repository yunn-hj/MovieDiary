//
//  PhotoDetailView.swift
//  MovieDiary
//
//  Created by openobject2 on 10/22/25.
//

import SwiftUI

struct PhotoDetailView: View {
    @Environment(\.dismiss) private var dismiss
    let image: UIImage
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                Spacer()
            }
        }
        .toolbarVisibility(.hidden, for: .tabBar)
    }
}
