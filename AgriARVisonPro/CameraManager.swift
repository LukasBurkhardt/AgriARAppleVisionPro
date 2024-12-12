//
//  CameraManager.swift
//  AgriARVisonPro
//
//  Created by Lukas Burkhardt on 28.11.24.
//
import SwiftUI
import AVFoundation
import RealityKit
import Vision

/*
struct CameraView: View {
    var body: some View {
        CameraRealityView()
            .edgesIgnoringSafeArea(.all)
    }
}
 */

/*
struct CameraRealityView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> CameraViewController {
        let cameraViewController = CameraViewController()
        return cameraViewController
    }

    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {}
}
 */


/************************/

/*
struct CameraView: View {
    var body: some View {
        RealityView { content in
            // Hier können zusätzliche 3D-Inhalte hinzugefügt werden
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            CameraViewController.shared.startSession()
        }
        .onDisappear {
            CameraViewController.shared.stopSession()
        }
    }
}

class CameraViewController: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    static let shared = CameraViewController()
    private let captureSession = AVCaptureSession()

    func startSession() {
        guard let captureDevice = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: captureDevice) else {
            print("Keine Kamera verfügbar.")
            return
        }

        if captureSession.inputs.isEmpty {
            captureSession.addInput(input)
        }

        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))

        if captureSession.outputs.isEmpty {
            captureSession.addOutput(videoOutput)
        }

        captureSession.startRunning()
    }

    func stopSession() {
        captureSession.stopRunning()
    }

    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        // Hier kann Bildverarbeitung oder Vision-Framework-Integration erfolgen
    }
}

*/
