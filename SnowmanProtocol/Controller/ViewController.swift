//
//  ViewController.swift
//  SnowmanProtocol
//
//  Created by macbook air on 03/12/2018.
//  Copyright © 2018 alex. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var isEyesOpen: Bool = true
    var startPointGesture = CGPoint(x: 0, y: 0)
    var respondView = UIView()
    //    var eyesSwitch: Bool = true
    //    var eyeCount = 2
    
    @IBOutlet weak var eyeView: UIImageView!
    
    @IBOutlet weak var imageViewSnowman: Snowman!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        guard let touch = touches.first else {return}
        startPointGesture = touch.location(in: self.view)
        guard let respondView = self.view.hitTest(startPointGesture, with: nil) else {return}
        if respondView == eyeView {
            
            isEyesOpen = !isEyesOpen
            imageViewSnowman.eyesDelegat = self
            imageViewSnowman.setNeedsDisplay()
        }
    }
    
}

extension ViewController: EyesOpening {
    
    func openEyes() -> Bool {
        return isEyesOpen
    }
    
}
