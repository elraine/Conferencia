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


class ProgramViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource{
    
    
    let SQLBase = SQLiteDataStore.sharedInstance
    var events : [Event]? = []
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var ctrlBar: UISegmentedControl!
    
    @IBOutlet weak var picker: UIPickerView!
    
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return events!.count
    }
    
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("eventCell", forIndexPath: indexPath) as! EventViewCell
        cell.type.text = events![indexPath.row].type
        cell.timeS.text = events![indexPath.row].time_start
        
        cell.timeE.text = events![indexPath.row].time_end
        cell.name.text = events![indexPath.row].title
        
        
        if events![indexPath.row].roomid == -1{
            cell.room.text = ""
        }else{
            let room = try? RoomDataHelper.find(events![indexPath.row].roomid)
             cell.room.text = room!!.name
        }
        return cell
    }
    

    
    
    //PICKER TIME
    
    
    var source = ["default", "data","try"]
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return source.count
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        do{
            events = try EventDataHelper.findEventByDay(source[row])
        }catch{}
        self.tableView.reloadData()
        return dateView(source[row])
    }
    
    //VIEWS EVENTS
    override func viewDidLoad(){
        super.viewDidLoad()
        
        
        
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        do{
            source = try EventDataHelper.findDaySlot()!
        }catch{
            print("source fail")
        }
       /*
        do{
            events = try EventDataHelper.findAll()
        }catch{}
        */
        
        /*
        //choose date
        do{ctrlBar.replaceSegments(try EventDataHelper.findTimeSlotByDay()!)
        }catch{
        print("array error")
        }*/
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //Helped Methodes
    func dateView(date : String) -> String{
        var myArray = date.componentsSeparatedByString("-")
        
        let timeStartComponents = NSDateComponents()
        timeStartComponents.year = Int(myArray[0])!
        timeStartComponents.month = Int(myArray[1])!
        timeStartComponents.day = Int(myArray[2])!
        
        let timeStart = NSCalendar.currentCalendar().dateFromComponents(timeStartComponents)!
        
        let dayTimePeriodFormatter = NSDateFormatter()
        dayTimePeriodFormatter.dateFormat = "EE d"
        
        return dayTimePeriodFormatter.stringFromDate(timeStart)
    }
}



