//
//  CameraView.swift
//  MyLive
//
//  Created by Kwaw Annan on 2/11/24.
//

import SwiftUI
import AVFoundation

struct CameraView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        guard let captureSession = setupCaptureSession() else {
            return viewController
        }
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = viewController.view.bounds
        previewLayer.videoGravity = .resizeAspectFill
        viewController.view.layer.addSublayer(previewLayer)
        DispatchQueue.global(qos: .userInitiated).async {
            captureSession.startRunning()
        }
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
    
    private func setupCaptureSession() -> AVCaptureSession? {
        let session = AVCaptureSession()
        guard let device = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: device) else {
            return nil
        }
        
        if session.canAddInput(input) {
            session.addInput(input)
        } else {
            return nil
        }
        
        return session
    }
}
