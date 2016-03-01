//
//  SecondViewController.swift
//  Conferencia
//
//  Created by Alexis Chan on 04/02/2016.
//  Copyright © 2016 achan. All rights reserved.
//

import UIKit
import SQLite
import Alamofire
import SwiftyJSON




class ProgramViewController: UIViewController{

    let path = NSBundle.mainBundle().pathForResource("storage", ofType: "sqlite")! // in case of a sqlite file called 'storage.sqlite'
    // N.B. the sqlite file needs to be added to the project and to the application target
    
    let db = Connection("\(path)")

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

