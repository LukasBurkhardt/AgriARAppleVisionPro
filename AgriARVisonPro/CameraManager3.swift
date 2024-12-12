//
//  CameraManager3.swift
//  AgriARVisonPro
//
//  Created by Lukas Burkhardt on 11.12.24.
//

import SwiftUI
import RealityKit
import AVFoundation
import Vision

struct ObjectDetectionView: View {
    let modelName: String

    var body: some View {
        RealityView { content in
            // Initialer Content – Hier können wir einen leeren AnchorEntity hinzufügen
            let anchor = AnchorEntity(world: .zero)
            content.add(anchor)
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            CameraController.shared.startSession(with: modelName)
        }
        .onDisappear {
            CameraController.shared.stopSession()
        }
    }
}

// Singleton für die Kameralogik
class CameraController: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    static let shared = CameraController()
    private let captureSession = AVCaptureSession()
    private var visionModel: VNCoreMLModel?

    func startSession(with modelName: String) {
        loadVisionModel(modelName: modelName)

        guard let captureDevice = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: captureDevice) else {
            print("Keine Kamera verfügbar.")
            return
        }

        captureSession.beginConfiguration()
        //captureSession.sessionPreset = .high

        if captureSession.canAddInput(input) {
            captureSession.addInput(input)
        }

        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))

        if captureSession.canAddOutput(videoOutput) {
            captureSession.addOutput(videoOutput)
        }

        captureSession.commitConfiguration()
        captureSession.startRunning()
    }

    func stopSession() {
        captureSession.stopRunning()
    }

    private func loadVisionModel(modelName: String) {
        guard let modelURL = Bundle.main.url(forResource: modelName, withExtension: "mlmodelc"),
              let mlModel = try? MLModel(contentsOf: modelURL),
              let visionModel = try? VNCoreMLModel(for: mlModel) else {
            fatalError("Fehler beim Laden des ML-Modells.")
        }
        self.visionModel = visionModel
    }

    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer),
              let visionModel = visionModel else {
            return
        }

        let request = VNCoreMLRequest(model: visionModel) { request, error in
            guard let results = request.results as? [VNRecognizedObjectObservation],
                  let firstResult = results.first else {
                print("Kein Objekt erkannt")
                return
            }

            let topLabel = firstResult.labels.first?.identifier ?? "Unbekannt"
            print("Erkanntes Objekt: \(topLabel)")
        }

        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
        try? handler.perform([request])
    }
}
