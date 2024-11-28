//
//  ImmersiveView.swift
//  AgriARVisonPro
//
//Created by Lukas Burkhardt on 01.10.24.
//
/*
import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveView: View {
    var body: some View {
        RealityView { content in
            // Add the initial RealityKit content
            if let immersiveContentEntity = try? await Entity(named: "Immersive", in: realityKitContentBundle) {
                content.add(immersiveContentEntity)

                // Add an ImageBasedLight for the immersive content
                guard let resource = try? await EnvironmentResource(named: "ImageBasedLight") else { return }
                let iblComponent = ImageBasedLightComponent(source: .single(resource), intensityExponent: 0.25)
                immersiveContentEntity.components.set(iblComponent)
                immersiveContentEntity.components.set(ImageBasedLightReceiverComponent(imageBasedLight: immersiveContentEntity))

                // Put skybox here.  See example in World project available at
                // https://developer.apple.com/
            }
        }
    }
}

#Preview {
    ImmersiveView()
        .previewLayout(.sizeThatFits)
}
 */


 import SwiftUI
 import RealityKit
 import RealityKitContent
 
 struct ImmersiveView: View {
 var body: some View {
 RealityView { content in
 // Hinzufügen von 3D-Objekten oder virtuellen Inhalten
 if let immersiveEntity = try? await Entity(named: "ImmersiveScene", in: realityKitContentBundle) {
 content.add(immersiveEntity)
 
 // Zusätzliche Lichtquellen oder Umgebungslicht hinzufügen
 guard let environment = try? await EnvironmentResource(named: "ImageBasedLight") else { return }
 let iblComponent = ImageBasedLightComponent(source: .single(environment), intensityExponent: 0.25)
 immersiveEntity.components.set(iblComponent)
 }
 }
 }
 }
 
 extension UIImage {
 func pixelBuffer() -> CVPixelBuffer? {
 let width = Int(self.size.width)
 let height = Int(self.size.height)
 let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue,
 kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
 var pixelBuffer: CVPixelBuffer?
 CVPixelBufferCreate(kCFAllocatorDefault, width, height, kCVPixelFormatType_32BGRA, attrs, &pixelBuffer)
 
 guard let buffer = pixelBuffer else { return nil }
 
 CVPixelBufferLockBaseAddress(buffer, CVPixelBufferLockFlags(rawValue: 0))
 let pixelData = CVPixelBufferGetBaseAddress(buffer)
 
 let colorSpace = CGColorSpaceCreateDeviceRGB()
 let context = CGContext(data: pixelData, width: width, height: height,
 bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(buffer),
 space: colorSpace,
 bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue)
 
 guard let cgImage = self.cgImage else { return nil }
 context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
 CVPixelBufferUnlockBaseAddress(buffer, CVPixelBufferLockFlags(rawValue: 0))
 
 return buffer
 }
 }
 
 func uiImageToPixelBuffer(image: UIImage) -> CVPixelBuffer? {
 guard let cgImage = image.cgImage else {
 return nil
 }
 
 let width = cgImage.width
 let height = cgImage.height
 let attributes: [NSObject: AnyObject] = [
 kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue,
 kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue
 ]
 
 var pixelBuffer: CVPixelBuffer?
 CVPixelBufferCreate(kCFAllocatorDefault, width, height, kCVPixelFormatType_32BGRA, attributes as CFDictionary, &pixelBuffer)
 
 guard let buffer = pixelBuffer else {
 return nil
 }
 
 CVPixelBufferLockBaseAddress(buffer, CVPixelBufferLockFlags(rawValue: 0))
 let pixelData = CVPixelBufferGetBaseAddress(buffer)
 
 let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
 let context = CGContext(data: pixelData, width: width, height: height, bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(buffer), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue)
 
 guard let ctx = context else {
 return nil
 }
 
 ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
 CVPixelBufferUnlockBaseAddress(buffer, CVPixelBufferLockFlags(rawValue: 0))
 
 return buffer
 }
 
 #Preview {
 ImmersiveView()
 .previewLayout(.sizeThatFits)
 }
 
