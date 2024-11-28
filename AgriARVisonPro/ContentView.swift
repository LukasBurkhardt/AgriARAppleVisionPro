//
//  ContentView.swift
//  AgriARVisonPro
//
//  Created by Lukas Burkhardt on 01.10.24.
//

import SwiftUI
import Vision
import AVFoundation

// Only For Testing L
struct ContentView: View {
    @State private var cameraManager = CameraManager()
    @State private var detectionResults: [VNRecognizedObjectObservation] = []
    @State private var isRunning = false

    var body: some View {
        VStack {
            Text("Apple Vision Pro Object Detection")
                .font(.headline)
                .padding()

            Button(isRunning ? "Stop Detection" : "Start Detection") {
                if isRunning {
                    cameraManager.stopCamera()
                    isRunning = false
                } else {
                    cameraManager.startCamera()
                    isRunning = true
                }
            }
            .padding()

            if !detectionResults.isEmpty {
                Text("Detected Objects:")
                    .font(.headline)
                    .padding(.top, 20)
                List(detectionResults, id: \.self) { result in
                    VStack(alignment: .leading) {
                        Text("Object: \(result.labels.first?.identifier ?? "Unknown")")
                        Text(String(format: "Confidence: %.2f%%", (result.labels.first?.confidence ?? 0) * 100))
                    }
                }
            } else {
                Text("No objects detected.")
                    .foregroundColor(.gray)
                    .padding(.top, 20)
            }
        }
        .onAppear {
            // PixelBuffer von CameraManager empfangen und mit Vision verarbeiten
            cameraManager.onPixelBufferCaptured = { pixelBuffer in
                processPixelBuffer(pixelBuffer)
            }
        }
        .onDisappear {
            cameraManager.stopCamera()
        }
    }

    /// Vision-Modell laden und PixelBuffer analysieren
    func processPixelBuffer(_ pixelBuffer: CVPixelBuffer) {
        guard let modelURL = Bundle.main.url(forResource: "FruitsObjectDetectorVisionOS", withExtension: "mlmodelc"),
              let compiledModel = try? MLModel(contentsOf: modelURL) else {
            print("Failed to load ML model.")
            return
        }

        do {
            let visionModel = try VNCoreMLModel(for: compiledModel)
            let request = VNCoreMLRequest(model: visionModel) { request, error in
                if let results = request.results as? [VNRecognizedObjectObservation] {
                    DispatchQueue.main.async {
                        self.detectionResults = results
                    }
                } else if let error = error {
                    print("Error during Vision request: \(error)")
                }
            }

            let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
            try handler.perform([request])

        } catch {
            print("Error creating Vision model or performing request: \(error)")
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}
