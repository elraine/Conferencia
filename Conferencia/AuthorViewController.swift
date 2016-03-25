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
    
    var docs : [Doc]? = []
    
    
    // view
    @IBOutlet weak var speakerName: UILabel!
    @IBOutlet weak var speakerUniversity: UILabel!
    
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
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
                docs?.append(doc)
            }
        }
        catch{}
        
        
        // View
        
        speakerUniversity.text = affiliation
        
        //table view
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "eventCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //Table view
  
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return docs!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("eventACell")! as! EventViewCell
        
        let doc = docs![indexPath.row]
        var event : Event?
        do{
            event = try EventDataHelper.find(doc.eventid)
        }catch{}
        cell.name.text = event!.title
        cell.type.text = doc.title
        
        if event!.roomid == -1{
            cell.room.text = ""
        }else{
            let room = try? RoomDataHelper.find(event!.roomid)
            cell.room.text = room!!.name
        }
        
        cell.timeS.text = timeView(doc.time_start)
        cell.timeE.text = timeView(doc.time_end)
        
        return cell
    }
    

    
    // MARK: - Navigation

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("You selected cell #\(indexPath.row)!")
        let selectedDocCell = self.docs![indexPath.row]
        print(selectedDocCell)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowDoc" {
            let DocViewController = (segue.destinationViewController as! UINavigationController).topViewController as! DocDetailViewController
            if let selectedDocCell = sender as? UITableViewCell {
                let indexPath = self.tableView.indexPathForCell(selectedDocCell)!
                let selectedAuthor = self.docs![indexPath.row]
                
                DocViewController.doc = selectedAuthor
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
