//
//  AuthorTableViewController.swift
//  Conferencia
//
//  Created by Angélique Blondel on 03/03/2016.
//  Copyright © 2016 achan. All rights reserved.
//

import UIKit
import SQLite
import Alamofire
import SwiftyJSON

class AuthorTableViewController: UITableViewController{

    
    var authors: [Author]? = []
    
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.authors!.count;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("authorCell", forIndexPath: indexPath) as UITableViewCell
        
        cell.textLabel?.text = "\(self.authors![indexPath.row].lastname) \(self.authors![indexPath.row].firstname)"
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("You selected cell #\(indexPath.row)!")
        let selectedAuthor = self.authors![indexPath.row]
        print(selectedAuthor)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowDetail" {
            let AuthorDetailViewController = (segue.destinationViewController as! UINavigationController).topViewController as! AuthorViewController
            if let selectedAuthorCell = sender as? UITableViewCell {
                let indexPath = self.tableView.indexPathForCell(selectedAuthorCell)!
                let selectedAuthor = self.authors![indexPath.row]
                
                AuthorDetailViewController.author = selectedAuthor
            }
        }
    }
    
    
    //VIEWS EVENTS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        //base
        
        do {
            authors = try AuthorDataHelper.findAll()
        }catch{}
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }}
