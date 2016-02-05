//
//  FirstViewController.swift
//  Conferencia
//
//  Created by Alexis Chan on 04/02/2016.
//  Copyright © 2016 achan. All rights reserved.
//

import UIKit

class HomepageViewController: UIViewController {

    @IBOutlet weak var Progress: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let time = NSDate()
        let currentMin = time.minute()
        let span = Float(currentMin)/60.0
        Progress.setProgress(span, animated: false)
        print("\(currentMin) : \(span)")
    }

}

