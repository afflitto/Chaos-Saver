//
//  ChaosSaverView.swift
//  ChaosSaver
//
//  Created by Andrew Afflitto on 3/3/19.
//  Copyright © 2019 Andrew Afflitto. All rights reserved.
//

import AppKit
import ScreenSaver

final class ChaosSaverView: ScreenSaverView {
    
    var index = 0
    
    let chaos = ChaosRenderer()
    
    var lastImg:CGImage?
    
    override func startAnimation() {
        super.startAnimation()
    }
    
    override func animateOneFrame() {
        super.animateOneFrame()
        
        //set needsDisplay to true to do drawing in draw()
        needsDisplay = true
    }
    
    override func draw(_ rect: NSRect) {
        super.draw(rect)
        
        guard let cgContext = NSGraphicsContext.current?.cgContext else {
            print("failed to get cgContext!")
            return
        }
        
        var pixels = [ChaosRenderer.PixelData](repeating: ChaosRenderer.PixelData(a: 10, r: 0, g: 0, b: 0), count: 1920*1080)
        
        index += 1
        index %= 1920*1080
        pixels[index] = ChaosRenderer.PixelData(a: 255, r: 255, g: 255, b: 255)
        
        
        let img = chaos.createImageFromPixels(pixels: pixels, width: 1920, height: 1080)
        
        //draw previous frame to allow for trails
        if let lastImg = lastImg {
            cgContext.draw(lastImg, in: self.bounds)
        }
        
        cgContext.draw(img!, in: self.bounds)
        
        lastImg = cgContext.makeImage() //save current frame to be drawn next frame
    }
    
    override init?(frame: NSRect, isPreview: Bool) {
        super.init(frame: frame, isPreview: isPreview)
        initialize()
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        initialize()
    }
    
    private func initialize() {
        animationTimeInterval = 1.0 / 30.0
        
        wantsLayer = true
    }
}
