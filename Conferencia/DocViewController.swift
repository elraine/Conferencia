//
//  DocViewController.swift
//  Conferencia
//
//  Created by Guillaume Zahar on 12/03/2016.
//  Copyright © 2016 gzahar. All rights reserved.
//

import UIKit

class DocViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
 
    
   
    
    @IBOutlet weak var docTable: UITableView!
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBOutlet weak var clustername: UILabel!
    @IBOutlet weak var day: UILabel!

    @IBOutlet weak var room: UILabel!
    
    var docs = [Doc]()
    var clusterlabel : String?
    var daylabel : String?
    var roomlabel : String?
    var selectedIndex:Int = 1
    
    // Date View
    let date = DateView()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        clustername.text = clusterlabel
        day.text = daylabel
        room.text = roomlabel
        
        docTable.delegate = self
        docTable.dataSource = self
        self.docTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        //myLabel?.text = "\(selectedIndex)"
        
        // add back button to the navigation bar.
        
        if splitViewController?.respondsToSelector("displayModeButtonItem") == true {
            navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem()
            navigationItem.leftItemsSupplementBackButton = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(docTable: UITableView) -> Int {
        return 1
    }
    
    
    
    func tableView(docTable: UITableView, numberOfRowsInSection section: Int) -> Int {
        return docs.count
    }
    
    
    
    func tableView(docTable: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = docTable.dequeueReusableCellWithIdentifier("docCell", forIndexPath: indexPath) as! DocViewCell
        
        cell.selected = false
        let doc = docs[indexPath.row]
        var located: [Located]?
        do{
            located = try LocatedDataHelper.find(doc.docid)
        }catch{}
        
        
        for l in located! {
            if l.speaker.containsString("1") {
                cell.speaker.text = "\(l.lastname) \(l.firstname)"
            }
        }

        cell.name.text = doc.title
        cell.timeS.text = date.timeView(doc.time_start)
        cell.timeE.text = date.timeView(doc.time_end)
        
        
        cell.favstar.tag = indexPath.row
        //FAVORITE STAR[
        //cell.favstar.addTarget(self, action: Selector("tapped:"), forControlEvents: .TouchUpInside)
        //]FAVORITE STAR
        
        return cell
    }
    
  

    
    //var authors: [Author]? = []
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowDoc" {
        
            let DetailViewController = (segue.destinationViewController as! UINavigationController).topViewController as! DocDetailViewController
            if let selectedCell = sender as? UITableViewCell {
                let indexPath = self.docTable.indexPathForCell(selectedCell)!
                
                let doc = docs[indexPath.row]

                DetailViewController.doc = doc
                
            }
        }
    }
}
