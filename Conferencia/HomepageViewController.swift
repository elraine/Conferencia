//
//  FirstViewController.swift
//  Conferencia
//
//  Created by Alexis Chan on 04/02/2016.
//  Copyright © 2016 achan. All rights reserved.
//

import UIKit
import SQLite

let CONF_ID = 1601
let firstConnection = 0
let manager = SetDataManager(id: CONF_ID)

class HomepageViewController: UIViewController {

    @IBOutlet weak var Progress: UIProgressView!
    @IBOutlet weak var progressButton: UIButton!
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    let SQLBase = SQLiteDataStore.sharedInstance
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print("first time")
        do{
          //  try SQLBase.createTables()
        }catch{ print("Creation de la Base de données : \(error)")}
        
       // let finish = manager.firstConnection()
        
        //manager.update()
    
    }

    @IBAction func progressButtonAct(sender: AnyObject) {
        do{
            try dropData()
        }catch{}
        NSUserDefaults.standardUserDefaults().removeObjectForKey("isAppAlreadyLaunchedOnce")
        print("reset to zero")
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

func dropData() throws {
    guard let DB = SQLiteDataStore.sharedInstance.CDB else {
        throw DataAccessError.Datastore_Connection_Error
    }
    let bass = ["Affilations","Authors","Clusters","ComeFrom","Conferences","Docs","Events","Located","Locations","Rooms"]
    do{
        for t in bass{
            try DB.run(Table(t).drop(ifExists: true))
        }
    }catch{
        print("cant drop")
    }
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

