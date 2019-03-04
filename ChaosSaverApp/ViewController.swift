//
//  ViewController.swift
//  ChaosSaverApp
//
//  Created by Andrew Afflitto on 3/4/19.
//  Copyright © 2019 Andrew Afflitto. All rights reserved.
//

import Cocoa
import ScreenSaver

class ViewController: NSViewController {
    
    let screenSaver: ScreenSaverView! = { //autoclosure to initialize the screensaver
        let view = ChaosSaverView(frame: .zero, isPreview: false)
        view?.autoresizingMask = [.width, .height]
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()        
        
        screenSaver.frame = view.bounds //set bounds
        view.addSubview(screenSaver) //add to view
        
        //start the screensaver animation and call animateOneFrame() at the animationTimeInterval
        screenSaver.startAnimation()
        Timer.scheduledTimer(timeInterval: screenSaver.animationTimeInterval, target: screenSaver, selector: #selector(ScreenSaverView.animateOneFrame), userInfo: nil, repeats: true)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

