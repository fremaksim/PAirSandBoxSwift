//
//  ViewController.swift
//  PAirSandboxSwiftExample
//
//  Created by mozhe on 2019/1/28.
//  Copyright © 2019 mozhe. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        
        PAirSandBoxSwift.shared.showSandboxBrowser()
        
        
    }


}

