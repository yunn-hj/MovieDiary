//
//  CameraViewModel.swift
//  MovieDiary
//
//  Created by openobject2 on 10/22/25.
//

import Combine
import AVFoundation
import UIKit
import SwiftUI

enum CameraRatio {
    case ratio_1_1
    case ratio_3_4
    case ratio_9_16
    
    var value: [Int: Int] {
        switch self {
        case .ratio_1_1: return [1: 1]
        case .ratio_3_4: return [4: 3]
        case .ratio_9_16: return [16: 9]
        }
    }
}

final class CameraViewModel: ObservableObject {
    private let camera: Camera
    private let session: AVCaptureSession
    var preview: CameraPreview
    
    @Published var isFlashOn: Bool = false
    @Published var isFrontCamera: Bool = false
    @Published var ratio: CameraRatio = .ratio_3_4
    @Published var capturedImage: UIImage? = nil
    
    private var cancallables = Set<AnyCancellable>()
    
    init() {
        self.camera = Camera()
        self.session = camera.session
        self.preview = CameraPreview(session: session)
        
        camera.$recentImage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in
                self?.capturedImage = image
            }
            .store(in: &cancallables)
    }
    
    func checkPermission() {
        camera.checkPermission()
    }
    
    func switchFlash() {
        isFlashOn.toggle()
    }
    
    func switchCamera() {
        isFrontCamera.toggle()
    }
    
    func switchRatio() {
        let nextRatio: CameraRatio = switch(self.ratio) {
        case .ratio_1_1: .ratio_3_4
        case .ratio_3_4: .ratio_9_16
        case .ratio_9_16: .ratio_1_1
        }
        self.ratio = nextRatio
    }
    
    func capturePhoto() {
        camera.capturePhoto()
    }
    
    func clearCapturedImage() {
        capturedImage = nil
    }
}
