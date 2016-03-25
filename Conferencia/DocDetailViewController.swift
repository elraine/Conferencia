//
//  DocDetailViewController.swift
//  Conferencia
//
//  Created by Angélique Blondel on 04/03/2016.
//  Copyright © 2016 achan. All rights reserved.
//

import UIKit

class DocDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var doc : Doc?
    var event : Event?
    var room : Room?
   
    @IBOutlet weak var clusterName: UILabel!
    @IBOutlet weak var docName: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var roomName: UILabel!   
    @IBOutlet weak var abstractView: UITextView!
    
    @IBAction func cancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
       
    }
    
    override func viewWillAppear(animated: Bool) {
        //base
        
        do{
            located = try LocatedDataHelper.find(doc!.docid)
            event = try EventDataHelper.find(doc!.eventid)
            room = try RoomDataHelper.find(event!.roomid)
        }catch{}
        
        // Set information
        clusterName.text = event!.title
        docName.text = doc!.title
        date.text = "\(event!.date) \(doc!.time_start) - \(doc!.time_end)"
        roomName.text = room!.name
        abstractView.text = doc!.abstract
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Contributors Table View
    var located : [Located]? = []
    
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return located!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel?.text = "\(self.located![indexPath.row].lastname) \(self.located![indexPath.row].firstname)"
        return cell
    }
   
     // MARK: - Navigation
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("You selected cell #\(indexPath.row)!")
        let selectedAuthor = self.located![indexPath.row]
        print(selectedAuthor)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
         print(segue.identifier )
        if segue.identifier == "ShowAuthor" {
            let AuthorDetailViewController = (segue.destinationViewController as! UINavigationController).topViewController as! AuthorViewController
            if let selectedAuthorCell = sender as? UITableViewCell {
                let indexPath = self.tableView.indexPathForCell(selectedAuthorCell)!
                
                do{
                    let l = self.located![indexPath.row]
                    let selectedAuthor : [Author] = try AuthorDataHelper.find(l.lastname, firstname: l.firstname)!
                   
                    
                    AuthorDetailViewController.author = selectedAuthor[0]
                }catch{print("find Author from located : \(error)")}
                
            }
        }
    }

}
