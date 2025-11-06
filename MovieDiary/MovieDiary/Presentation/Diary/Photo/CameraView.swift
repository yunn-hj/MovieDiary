//
//  CameraView.swift
//  MovieDiary
//
//  Created by openobject2 on 10/22/25.
//

import SwiftUI
import AVFoundation

struct CameraView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var viewModel: CameraViewModel
    
    private var isRecentImageAvailable: Binding<Bool> {
        Binding(
            get: { viewModel.capturedImage != nil },
            set: { isAvailable in
                if !isAvailable {
                    viewModel.clearCapturedImage()
                }
            }
        )
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.black.ignoresSafeArea()
            viewModel.preview
            VStack {
                upperButtons
                Spacer()
                captureButton
            }
            .frame(maxHeight: .infinity)
        }
        .onAppear {
            viewModel.checkPermission()
        }
        .navigationDestination(isPresented: isRecentImageAvailable) {
            if let image = viewModel.capturedImage {
                CapturedPhotoView(image: image)
            }
        }
    }
    
    @ViewBuilder
    var upperButtons: some View {
        HStack {
            Spacer()
            Button(action: viewModel.switchRatio) {
                let ratio = switch(viewModel.ratio) {
                case .ratio_1_1: "1:1"
                case .ratio_3_4: "3:4"
                case .ratio_9_16: "9:16"
                }
                
                Text(ratio)
                    .font(.caption)
                    .foregroundStyle(.white)
                    .frame(width: 30)
                    .padding()
            }
            Spacer()
            
            Button(action: viewModel.switchFlash) {
                let image = switch(viewModel.isFlashOn) {
                case true: "bolt.fill"
                case false: "bolt.slash"
                }
                
                Image(systemName: image)
                    .foregroundStyle(.white)
                    .padding()
            }
            Spacer()
            
            Button(action: viewModel.switchCamera) {
                Image(systemName: "arrow.trianglehead.2.clockwise.rotate.90.camera")
                    .foregroundStyle(.white)
                    .padding()
            }
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
    
    @ViewBuilder
    var captureButton: some View {
        Button(action: { dismiss() }) {
            Circle()
                .stroke(lineWidth: 5)
                .frame(width: 75, height: 75)
                .foregroundStyle(.white)
                .padding()
        }
    }
}
