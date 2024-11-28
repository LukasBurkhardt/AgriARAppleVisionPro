//
//  ContentView.swift
//  AgriARVisonPro
//
//  Created by Lukas Burkhardt on 01.10.24.
//

import SwiftUI
import Vision
import AVFoundation
 
 
struct ContentView: View {
    @State private var detectionResults: [VNRecognizedObjectObservation] = []
    @State private var timer: Timer?
    @State private var isRunning = false
    @State private var modelIsLoaded = false

    var body: some View {
        VStack {
            Text("Apple Vision Pro Object Detection")
                .font(.headline)
                .padding()

            Button(isRunning ? "Stop Detection" : "Start Detection") {
                if isRunning {
                    stopDetection()
                } else {
                    startDetection()
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
        .padding()
    }

    func startDetection() {
        guard let modelURL = Bundle.main.url(forResource: "FruitsObjectDetector", withExtension: "mlmodelc") else {
            print("ML Model not found!")
            return
        }

        do {
            let visionModel = try VNCoreMLModel(for: MLModel(contentsOf: modelURL))
            modelIsLoaded = true

            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                captureAndDetect(with: visionModel)
            }
            isRunning = true
        } catch {
            print("Failed to load Vision model: \(error)")
        }
    }

    func stopDetection() {
        timer?.invalidate()
        timer = nil
        isRunning = false
    }

    func captureAndDetect(with model: VNCoreMLModel) {
        let request = VNCoreMLRequest(model: model) { request, error in
            if let results = request.results as? [VNRecognizedObjectObservation] {
                DispatchQueue.main.async {
                    self.detectionResults = results
                }
            } else if let error = error {
                print("Error during detection: \(error)")
            }
        }

        guard let pixelBuffer = capturePixelBuffer() else {
            print("Failed to capture image")
            return
        }

        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
        do {
            try handler.perform([request])
        } catch {
            print("Error performing request: \(error)")
        }
    }

    func capturePixelBuffer() -> CVPixelBuffer? {
        // Hier sollte die Logik implementiert werden, um ein Bild von der Apple Vision Pro Kamera zu erhalten.
        // Für Demonstrationszwecke wird hier ein Dummy zurückgegeben.
        return nil
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}
