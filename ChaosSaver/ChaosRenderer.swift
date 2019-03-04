//
//  ChaosPath.swift
//  ChaosSaver
//
//  Created by Andrew Afflitto on 3/4/19.
//  Copyright © 2019 Andrew Afflitto. All rights reserved.
//

import Foundation

class ChaosRenderer {
    var params:[Double]!
    
    init() {
        params = generateParams()
    }
    
    struct PixelData {
        var a:UInt8 = 255
        var r:UInt8 = 0
        var g:UInt8 = 0
        var b:UInt8 = 0
    }
    
    private func generateParams() -> [Double] {
        var randomParams: [Double] = []
        for _ in 0...17 { //TODO: make variable
            randomParams.append(Double(Int.random(in: -1...1)))
        }
        return randomParams
    }
    
    func createImageFromPixels(pixels: [PixelData], width:Int, height:Int) -> CGImage? {
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
