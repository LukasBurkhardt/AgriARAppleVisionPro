//
//  ContentView.swift
//  AgriARVisonPro
//
//  Created by Lukas Burkhardt on 01.10.24.
//

import SwiftUI
import Vision
import AVFoundation

import SwiftUI

struct ContentView: View {
    @State private var detectedObject: String = "Suche nach Objekten..."

    var body: some View {
        ZStack {
            ObjectDetectionView(modelName: "ObjectDetector")

            VStack {
                Spacer()
                Text(detectedObject)
                    .font(.headline)
                    .padding()
                    .background(Color.black.opacity(0.7))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding()
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    ContentView()
}

/*
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
 // Ein Callback wird gesetzt (cameraManager.onPixelBufferCaptured), der jedes erfasste Bild (CVPixelBuffer) an die Methode processPixelBuffer(_:) weiterleitet.
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
 /// Ergebnisse (VNRecognizedObjectObservation) werden in die Liste detectionResults geschrieben.
 func processPixelBuffer(_ pixelBuffer: CVPixelBuffer) {
 guard let modelURL = Bundle.main.url(forResource: "FruitsObjectDetectorVisionOS", withExtension: "mlmodelc"),
 //guard let modelURL = Bundle.main.url(forResource: "FruitsObjectDetectorVisionOS", withExtension: "mlmodelc"),
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
 */
