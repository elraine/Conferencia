//
//  FirstViewController.swift
//  Conferencia
//
//  Created by Alexis Chan on 04/02/2016.
//  Copyright © 2016 achan. All rights reserved.
//

import UIKit
let CONF_ID = 1601

class HomepageViewController: UIViewController {

    @IBOutlet weak var Progress: UIProgressView!
    
    let SQLBase = SQLiteDataStore.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if(!isAppAlreadyLaunchedOnce()){
            print("first time")
            LoadingOverlay.showOverlay(self.view! as UIView)
        do{
            try SQLBase.createTables()
        }catch{}
        
        SetDataManager(id: CONF_ID)
            
        }else{
            print("not first time")
        }
        //resetData()
        
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

func resetData(){
    do {
        if let events = try EventDataHelper.findAll() {
            for event in events {
                try EventDataHelper.delete(event)
                
            }
        }
        if let rooms = try RoomDataHelper.findAll() {
            for room in rooms {
                try RoomDataHelper.delete(room)
                
            }
        }
        if let docs = try DocDataHelper.findAll() {
            for doc in docs {
                try DocDataHelper.delete(doc)
            }
        }
        if let authors = try AuthorDataHelper.findAll() {
            for author in authors {
                try AuthorDataHelper.delete(author)
                
            }
        }
        if let affiliations = try AffiliationDataHelper.findAll() {
            for affiliation in affiliations {
                try AffiliationDataHelper.delete(affiliation)
                
            }
        }
        if let locateds = try LocatedDataHelper.findAll() {
            for located in locateds {
                try LocatedDataHelper.delete(located)
                
            }
        }
        if let comeFroms = try ComeFromDataHelper.findAll() {
            for comeFrom in comeFroms {
                try ComeFromDataHelper.delete(comeFrom)
                
            }
        }
    } catch _ {}
}
    
    func isAppAlreadyLaunchedOnce()->Bool{
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let _ = defaults.stringForKey("isAppAlreadyLaunchedOnce"){
            print("App already launched")
            return true
        }else{
            defaults.setBool(true, forKey: "isAppAlreadyLaunchedOnce")
            print("App launched first time")
            return false
        }
    }

