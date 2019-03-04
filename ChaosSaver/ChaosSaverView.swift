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
    var params:[Double]!
    
    var index = 0
    
    var renderer:ChaosRenderer?
    
    var lastImg:CGImage?
    
    override func startAnimation() {
        super.startAnimation()
        
        renderer = ChaosRenderer(Int(self.bounds.width), Int(self.bounds.height))
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
        
        renderer?.render(cgContext, rect)
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
    
    private func generateParams() -> [Double] {
        var randomParams: [Double] = []
        for _ in 0...17 { //TODO: make variable
            randomParams.append(Double(Int.random(in: -1...1)))
        }
        return randomParams
    }
}
