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
    
    // Array of letter
    var sections : [(index: Int, length :Int, title: String)] = Array()
    
    //VIEWS EVENTS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        //base
        
        do {
            authors = try AuthorDataHelper.findAll()
        }catch{}
        
        // MARK: Index list
        var index = 0;
        
        for ( var i = 0; i < authors!.count; i++ ) {
            
            let commonPrefix = authors![i].lastname.commonPrefixWithString(authors![index].lastname, options: .CaseInsensitiveSearch)
            
            // Take the first author of the section
            if (commonPrefix.characters.count == 0 ) {
                
                let string = authors![index].lastname.uppercaseString;
          
                let firstCharacter = string[string.startIndex]
               
                let title = "\(firstCharacter)"
                
                let newSection = (index: index, length: i - index, title: title)
                
                sections.append(newSection)
                
                index = i;
                
            }
            
        }
    }
    
    // MARK: UITableViewDelegate
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return sections.count
        
    }
    
   override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return sections[section].length
        
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String {
        
        return sections[section].title
        
    }
   override func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        
        return index
        
    }
    
    
    override func sectionIndexTitlesForTableView(_ tableView: UITableView) -> [String]? {
        
        return sections.map { $0.title }
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("authorCell", forIndexPath: indexPath) as UITableViewCell
        
        cell.textLabel?.text = "\(self.authors![sections[indexPath.section].index + indexPath.row].lastname) \(self.authors![sections[indexPath.section].index + indexPath.row].firstname)"
        return cell
    }
    
     // MARK: - Navigation
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
                let selectedAuthor = self.authors![sections[indexPath.section].index + indexPath.row]
                
                AuthorDetailViewController.author = selectedAuthor
            }
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }}
