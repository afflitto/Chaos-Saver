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
    let shouldDrawFps = false
    
    var params:[Double]!
    var renderer:ChaosRenderer?

    var t:Double = -3.0
    
    var pointColors:[ChaosRenderer.PixelData] = []
    
    override func startAnimation() {
        super.startAnimation()
        
        //renderer = ChaosRenderer(Int(self.bounds.width), Int(self.bounds.height))
        //Maybe need to set frame buffer size depending on if it's a preview
        renderer = ChaosRenderer(1920,1080)//(1024, 576)
    }
    
    override func animateOneFrame() {
        super.animateOneFrame()
        
        if t > 3.0 {
            t = -3.0
            params = generateParams()
        }
        
        for _ in 0..<200 { //steps per frame
            var x = t
            var y = t
            
            var wasOnScreen = false
            
            for i in 0..<300 { //iterations
                let xx = x * x
                let yy = y * y
                let tt = t * t
                let xy = x * y
                let xt = x * t
                let yt = y * t
                
                //calculate as sub expressions to prevent expression too complex swift error
                var nx  = xx * params[ 0]
                nx += yy * params[ 1]
                nx += tt * params[ 2]
                nx += xy * params[ 3]
                nx += xt * params[ 4]
                nx += yt * params[ 5]
                nx +=  x * params[ 6]
                nx +=  y * params[ 7]
                nx +=  t * params[ 8]
                
                var ny  = xx * params[ 9]
                ny += yy * params[10]
                ny += tt * params[11]
                ny += xy * params[12]
                ny += xt * params[13]
                ny += yt * params[14]
                ny +=  x * params[15]
                ny +=  y * params[16]
                ny +=  t * params[17]
                
                x = nx
                y = ny
                
                wasOnScreen = renderer!.drawPoint(x, y, pointColors[i]) || wasOnScreen
            }
            
            if !wasOnScreen {
                t += 0.001
            } else {
                t += 5e-5
            }
        }
        
        //set needsDisplay to true to do drawing in draw()
        needsDisplay = true
    }
    
    override func draw(_ rect: NSRect) {
        super.draw(rect)
        
        let startTime = DispatchTime.now()
        
        guard let cgContext = NSGraphicsContext.current?.cgContext else {
            print("failed to get cgContext!")
            return
        }
        
        renderer?.render(cgContext, rect)
        
        let endTime = DispatchTime.now()
        
        if shouldDrawFps {
            NSColor.white.setFill()
            NSMakeRect(0, 1050, 1920, 30).fill()
            let timeString = "t=\(t)" as NSString
            timeString.draw(at: NSPoint(x: 20, y: 1060), withAttributes: nil)
            
            let dt = endTime.uptimeNanoseconds - startTime.uptimeNanoseconds
            let fps = UInt64(1e9) / dt
            let fpsString = "\(fps)fps" as NSString
            fpsString.draw(at: NSPoint(x: 1880, y: 1060), withAttributes: nil)
        }
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
        
        params = generateParams()
        
        for i in 0..<300 {
            pointColors.append(randomColor(i))
        }
    }
    
    private func generateParams() -> [Double] {
        var randomParams: [Double] = []
        for _ in 0...17 { //TODO: make variable
            randomParams.append(Double(Int.random(in: -1...1)))
        }
        return randomParams
    }
    
    private func randomColor(_ index:Int) -> ChaosRenderer.PixelData {
        let i = index + 1
        let r = UInt8((i * 11909) % 256)
        let g = UInt8((i * 52973) % 256)
        let b = UInt8((i * 44111) % 256)
        
        return ChaosRenderer.PixelData(a: 255, r: r, g: g, b: b)
    }
}
