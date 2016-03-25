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


class ProgramViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    
    var events : [Event]? = []
    var source = [String]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var ctrlBar: UISegmentedControl!
    
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBAction func refresh(sender: UIBarButtonItem) {
        let finish = manager.update()
    }
    
    //VIEWS EVENTS
    override func viewDidLoad(){
        super.viewDidLoad()
        
        
        
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        do{
            source = try EventDataHelper.findDaySlot()!
            events = try EventDataHelper.findEventByDay(source[pagenumber])
        }catch{
            print("source fail")
        }
        
        
        // Swipe
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        
        leftSwipe.direction = .Left
        rightSwipe.direction = .Right
        
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.title = dateView(source[pagenumber])
      
        // MARK: Index list
        self.timeIndex(events!)

    }
    
    // MARK: UITableViewDelegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return sections.count
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return sections[section].length
        
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return sections[section].title
        
    }
    
    func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        
        return index
        
    }
    
    
    // MARK: - Table view data source
    
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("eventCell", forIndexPath: indexPath) as! EventViewCell

        let event = events![sections[indexPath.section].index + indexPath.row]
        cell.type.text = event.type
        cell.timeS.text = timeView(event.time_start)
        
        cell.timeE.text = timeView(event.time_end)
        cell.name.text = event.title
        
        
        if event.roomid == -1{
            cell.room.text = ""
        }else{
            let room = try? RoomDataHelper.find(event.roomid)
             cell.room.text = room!!.name
        }
        return cell
    }
    
   
    
    
   
    var pagenumber = 0
    // Array of letter
    var sections : [(index: Int, length :Int, title: String)] = Array()
    
    func handleSwipes(sender:UISwipeGestureRecognizer) {
        if (sender.direction == .Left) {
            
            
            if pagenumber < source.count - 1 {
                pagenumber = pagenumber + 1
                do{
                    events = try EventDataHelper.findEventByDay(source[pagenumber])
                }catch{}
                
                
                // MARK: Index list
                self.timeIndex(events!)
                
                self.tableView.reloadData()
                self.title = dateView(source[pagenumber])
            }
        }
        
        if (sender.direction == .Right) {
            
            
            if pagenumber > 0 {
                pagenumber = pagenumber - 1
                do{
                    events = try EventDataHelper.findEventByDay(source[pagenumber])
                }catch{}
              
                // MARK: Index list
                self.timeIndex(events!)
                
                self.tableView.reloadData()
                self.title = dateView(source[pagenumber])
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //Helped Methodes
    func dateView(date : String) -> String{
        var myArray = date.componentsSeparatedByString("-")
        
        let dayComponents = NSDateComponents()
        dayComponents.year = Int(myArray[0])!
        dayComponents.month = Int(myArray[1])!
        dayComponents.day = Int(myArray[2])!
        
        let day = NSCalendar.currentCalendar().dateFromComponents(dayComponents)!
        
        let dayTimePeriodFormatter = NSDateFormatter()
        dayTimePeriodFormatter.dateFormat = "EE d"
        
        return dayTimePeriodFormatter.stringFromDate(day)
    }
    
    
    func timeView(time : String) -> String{
        var myArray = time.componentsSeparatedByString(":")
        
        let timeComponents = NSDateComponents()
        timeComponents.hour = Int(myArray[0])!
        timeComponents.minute = Int(myArray[1])!
        
        let time = NSCalendar.currentCalendar().dateFromComponents(timeComponents)!
        
        let dayTimePeriodFormatter = NSDateFormatter()
        dayTimePeriodFormatter.timeStyle = .ShortStyle
        
        return dayTimePeriodFormatter.stringFromDate(time)

    }
    
    func timeIndex(var events : [Event]){
        var index = 0;
        
        events.sortInPlace { $0.time_start < $1.time_start }
        sections.removeAll()
        
        for ( var i = 0; i < events.count; i++ ) {
            
            let common = events[i].time_start.hasPrefix(events[index].time_start)
            
            if common == false || (common == true && i ==  events.count - 1){
                
                let start = timeView(events[index].time_start);
                
                let end = timeView(events[index].time_end);
                
                let title = "\(start) - \(end)"
                
                if i == 0 {
                    let newSection = (index: index, length: 1, title: title)
                    sections.append(newSection)
                }else{
                    let newSection = (index: index, length: i - index, title: title)
                    sections.append(newSection)
                }
                
                index = i;
                
            }
            
        }

    }
    
}



