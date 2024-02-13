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
        let captureSession = AVCaptureSession()
        
        // Setup the initial camera
        if let initialCamera = getCamera(withPosition: .back) {
            addCameraInput(toSession: captureSession, withCamera: initialCamera)
        }
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = viewController.view.bounds
        previewLayer.videoGravity = .resizeAspectFill
        viewController.view.layer.addSublayer(previewLayer)
        
        // Setup tap gesture recognizer
        let doubleTapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.switchCamera))
        doubleTapGesture.numberOfTapsRequired = 2
        viewController.view.addGestureRecognizer(doubleTapGesture)
        
        DispatchQueue.global(qos: .userInitiated).async {
            captureSession.startRunning()
        }
        
        // Store the capture session and preview layer in the coordinator for later use
        context.coordinator.captureSession = captureSession
        context.coordinator.previewLayer = previewLayer
        context.coordinator.currentCameraPosition = .back
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // Update UI or session if needed
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        var parent: CameraView
        var captureSession: AVCaptureSession?
        var previewLayer: AVCaptureVideoPreviewLayer?
        var currentCameraPosition: AVCaptureDevice.Position?
        
        init(_ parent: CameraView) {
            self.parent = parent
        }
        
        @objc func switchCamera() {
            guard let captureSession = captureSession, let currentCameraPosition = currentCameraPosition else { return }
            captureSession.beginConfiguration()
            
            // Remove existing input
            captureSession.inputs.forEach { input in
                captureSession.removeInput(input)
            }
            
            // Switch to the other camera
            let newCameraPosition: AVCaptureDevice.Position = currentCameraPosition == .back ? .front : .back
            if let newCamera = parent.getCamera(withPosition: newCameraPosition) {
                if parent.addCameraInput(toSession: captureSession, withCamera: newCamera) {
                    self.currentCameraPosition = newCameraPosition
                }
            }
            
            captureSession.commitConfiguration()
        }
    }
    
    private func getCamera(withPosition position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        return AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: position)
    }
    
    private func addCameraInput(toSession session: AVCaptureSession, withCamera camera: AVCaptureDevice) -> Bool {
        do {
            let input = try AVCaptureDeviceInput(device: camera)
            if session.canAddInput(input) {
                session.addInput(input)
                return true
            }
        } catch {
            print("Failed to create camera input: \(error)")
        }
        return false
    }
}
