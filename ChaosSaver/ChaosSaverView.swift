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
    
    var delta = 0.01
    var blue:Double = 0
    
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
        
        blue += delta
        
        if blue < 0 || blue > 1 {
            delta *= -1
        }
        
        cgContext.setFillColor(CGColor(red: 0, green: 0, blue: CGFloat(blue), alpha: 1))
        cgContext.fill(self.frame as CGRect)
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
