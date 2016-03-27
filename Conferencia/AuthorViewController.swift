//
//  AuthorViewController.swift
//  Conferencia
//
//  Created by Angélique Blondel on 04/03/2016.
//  Copyright © 2016 achan. All rights reserved.
//

import UIKit

class AuthorViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var author : Author?
    
    var docsTalks = [Doc]()
    var docsCoAuthorship = [Doc]()
    
    // view
    @IBOutlet weak var speakerName: UILabel!
    @IBOutlet weak var speakerUniversity: UILabel!
    
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
   
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableView2: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Speaker Details"
        speakerName.text = "\(self.author!.lastname) \(self.author!.firstname)"
        
        var affiliation : String = ""
        do{
            let comeFrom = try ComeFromDataHelper.find(self.author!.firstname, lastname: self.author!.lastname)
            if comeFrom!.count > 0 {
                affiliation = comeFrom![0].affiliationname
            }
            let located = try LocatedDataHelper.find(self.author!.firstname, lastname: self.author!.lastname)
            
            for l in located! {
                let doc : Doc = try DocDataHelper.find(l.docid)!
                if l.speaker.containsString("1") {
                    docsTalks.append(doc)
                    print("a")
                }else{
                    docsCoAuthorship.append(doc)
                    print("ok")
                }
            }
        }
        catch{}
        
        print(docsCoAuthorship.count)
        
        if docsTalks.count == 0{
            tableView.hidden = true
        }
        if docsCoAuthorship.count == 0{
            tableView2.hidden = true
        }
        // View
        
        speakerUniversity.text = affiliation
        
        //table view
        tableView.delegate = self
        tableView.dataSource = self
        tableView2.delegate = self
        tableView2.dataSource = self
        
        //self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "talksCell")
       // self.tableView2.registerClass(UITableViewCell.self, forCellReuseIdentifier: "coAuthorshipCell")
        
       
    }
    
    override func viewWillAppear(animated: Bool) {
      
        // Do any additional setup after loading the view.
        
       
        
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //Table view
  
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView{
            print("docsTalks.count : \(docsTalks.count)")
            return docsTalks.count
            
        }else{
            print("docsCoAuthorship.count : \(docsCoAuthorship.count)")
            return docsCoAuthorship.count
           
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var doc : Doc?
        if tableView == self.tableView{
            
            doc = docsTalks[indexPath.row]
            print("doc")
            let cell = self.tableView.dequeueReusableCellWithIdentifier("talksCell")! as! EventViewCell
            var event : Event?
            do{
                event = try EventDataHelper.find(doc!.eventid)
            }catch{}
            cell.name.text = event!.title
            cell.type.text = doc!.title
            
            if event!.roomid == -1{
                cell.room.text = ""
            }else{
                let room = try? RoomDataHelper.find(event!.roomid)
                cell.room.text = room!!.name
            }
            
            cell.timeS.text = timeView(doc!.time_start)
            cell.timeE.text = timeView(doc!.time_end)
            
            return cell

        }else{
            let cell : EventViewCell = self.tableView2.dequeueReusableCellWithIdentifier("coAuthorshipCell")! as! EventViewCell
            
            doc = docsCoAuthorship[indexPath.row]
            
            print("doc")
            var event : Event?
            do{
                event = try EventDataHelper.find(doc!.eventid)
            }catch{}
            cell.name.text = event!.title
            cell.type.text = doc!.title
            
            if event!.roomid == -1{
                cell.room.text = ""
            }else{
                let room = try? RoomDataHelper.find(event!.roomid)
                cell.room.text = room!!.name
            }
            
            cell.timeS.text = timeView(doc!.time_start)
            cell.timeE.text = timeView(doc!.time_end)
            
            return cell

        }
            }
    

    
    // MARK: - Navigation

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("You selected cell #\(indexPath.row)!")
        if tableView == self.tableView{
            let selectedDocCell = self.docsTalks[indexPath.row]
            print(selectedDocCell)
        }else{
            let selectedDocCell = self.docsCoAuthorship[indexPath.row]
            print(selectedDocCell)
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowDoc1" {
            let DocViewController = (segue.destinationViewController as! UINavigationController).topViewController as! DocDetailViewController
            if let selectedDocCell = sender as? UITableViewCell {
                
                let indexPath = self.tableView.indexPathForCell(selectedDocCell)!
                
          
                let selectedDoc = self.docsTalks[indexPath.row]
                DocViewController.doc = selectedDoc
             
                
               
            }
        }else if segue.identifier == "ShowDoc2" {
            let DocViewController = (segue.destinationViewController as! UINavigationController).topViewController as! DocDetailViewController
            if let selectedDocCell = sender as? UITableViewCell {
                
                let indexPath = self.tableView2.indexPathForCell(selectedDocCell)!
                
              
                let selectedDoc = self.docsCoAuthorship[indexPath.row]
                DocViewController.doc = selectedDoc
                
                
                
            }
        }
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
    
}
