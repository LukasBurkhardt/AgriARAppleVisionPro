//
//  CameraManager.swift
//  AgriARVisonPro
//
//  Created by Lukas Burkhardt on 28.11.24.
//
import AVFoundation

//  Hauptlogik zur Nutzung der Kamera,
//  um Videodatenframes zu erfassen und an eine Callback-Funktion weiterzugeben.

class CameraManager: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    private var captureSession: AVCaptureSession?
    var onPixelBufferCaptured: ((CVPixelBuffer) -> Void)?

    func startCamera() {
        let captureSession = AVCaptureSession()
        guard let captureDevice = AVCaptureDevice.default(for: .video) else {
            print("No camera available.")
            return
        }

        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
            }
        } catch {
            print("Error configuring camera input: \(error)")
            return
        }

        let videoOutput = AVCaptureVideoDataOutput() // AVCaptureVideoDataOutput gibt die Videoframes in einem für die Weiterverarbeitung geeigneten Format zurück.
        let queue = DispatchQueue(label: "videoQueue")
        videoOutput.setSampleBufferDelegate(self, queue: queue)

        if captureSession.canAddOutput(videoOutput) {
            captureSession.addOutput(videoOutput)
        }

        self.captureSession = captureSession
        captureSession.startRunning()
    }

    func stopCamera() {
        captureSession?.stopRunning()
        captureSession = nil
    }

    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            print("Failed to get pixel buffer.")
            return
        }

        // Callback mit dem PixelBuffer
        onPixelBufferCaptured?(pixelBuffer)
    }
}

