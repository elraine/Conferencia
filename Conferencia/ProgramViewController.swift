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
    
    // Date View
    let date = DateView()
    
    @IBOutlet weak var tableView: UITableView!


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
        self.title = date.dateView(source[pagenumber])
      
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
        cell.timeS.text = date.timeView(event.time_start)
        
        cell.timeE.text = date.timeView(event.time_end)
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
                self.title = date.dateView(source[pagenumber])
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
                self.title = date.dateView(source[pagenumber])
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //Helped Methodes

    
    func timeIndex(var events : [Event]){
        var index = 0;
        
        events.sortInPlace { $0.time_start < $1.time_start }
        sections.removeAll()
        
        for ( var i = 0; i < events.count; i++ ) {
            
            let common = events[i].time_start.hasPrefix(events[index].time_start)
            
            if common == false || (common == true && i ==  events.count - 1){
                
                let start = date.timeView(events[index].time_start);
                
                let end = date.timeView(events[index].time_end);
                
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



