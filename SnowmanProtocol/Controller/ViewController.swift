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
//    var eyesSwitch: Bool = true
//    var eyeCount = 2

    @IBOutlet weak var imageViewSnowman: Snowman! {
        didSet{
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
            imageViewSnowman.addGestureRecognizer(tapGestureRecognizer)
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    

    @objc func handleTap (sender: UITapGestureRecognizer) {
        
//        let respondView = self.view.hitTest(<#T##point: CGPoint##CGPoint#>, with: <#T##UIEvent?#>)
        
        if let viewSnowman = sender.view as? Snowman {
            isEyesOpen = !isEyesOpen
            viewSnowman.eyesDelegat = self
            viewSnowman.setNeedsDisplay()
        }
        
    }
    
    

}

extension ViewController: EyesOpening {

    func openEyes() -> Bool {
        return isEyesOpen
    }
    
}
