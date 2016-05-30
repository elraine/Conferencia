//
//  SplitViewController.swift
//  Conferencia
//
//  Created by Guillaume Zahar on 12/03/2016.
//  Copyright © 2016 gzahar. All rights reserved.
//

import UIKit

class SplitViewController: UISplitViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set the preferred display mode SplitViewController.
        
        splitViewController?.preferredDisplayMode = .PrimaryOverlay
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
