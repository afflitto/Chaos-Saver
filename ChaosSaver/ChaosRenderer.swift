//
//  ChaosPath.swift
//  ChaosSaver
//
//  Created by Andrew Afflitto on 3/4/19.
//  Copyright © 2019 Andrew Afflitto. All rights reserved.
//

import Foundation

class ChaosRenderer {
    //clearing color
    static let backgroundColor = PixelData(a: 20, r: 255, g: 0, b: 0)
    
    //size of frame buffer
    let width:Int!
    let height:Int!
    
    let frameBuffer:[PixelData]!
    var previousFrame:CGImage?
    
    struct PixelData {
        var a:UInt8 = 255
        var r:UInt8 = 0
        var g:UInt8 = 0
        var b:UInt8 = 0
    }
    
    init(_ width:Int, _ height:Int) {
        self.width = width
        self.height = height
        
        self.frameBuffer = [PixelData](repeating: ChaosRenderer.backgroundColor, count: width * height)
    }
    
    func render(_ cgContext:CGContext, _ rect:CGRect) {
        //create CGImage from frame buffer
        let img = createImageFromPixels(pixels: frameBuffer, width: width, height: height)
        
        //draw previous frame to allow for trails
        if let previousFrame = previousFrame {
            cgContext.draw(previousFrame, in: rect)
        }
        
        //draw to cgContext
        cgContext.draw(img!, in: rect)
        
        //save current frame to be drawn next frame
        previousFrame = cgContext.makeImage()
    }
    
    private func createImageFromPixels(pixels: [PixelData], width:Int, height:Int) -> CGImage? {
        assert(pixels.count == width*height)
        
        let data = pixels
        let provider = CGDataProvider(data: NSData(bytes: data, length: data.count * 4))
        return CGImage(
            width: width,
            height: height,
            bitsPerComponent: 8,
            bitsPerPixel: 32,
            bytesPerRow: width * 4,
            space: CGColorSpace(name: CGColorSpace.sRGB)!,
            bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.first.rawValue),
            provider: provider!,
            decode: nil,
            shouldInterpolate: true,
            intent: CGColorRenderingIntent.defaultIntent
        )
    }
}
