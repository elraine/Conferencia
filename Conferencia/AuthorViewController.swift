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
    
    var doc : [Doc]? = []
    
    let titleSection : [String] = ["Presenting","Chairing"]
    
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
        
        var affiliation : String = "University"
        do{
            affiliation = try ComeFromDataHelper.find(self.author!.firstname, lastname: self.author!.lastname)!
        }
        catch{}
        
        speakerUniversity.text = affiliation
        
        //table view
        //tableView.delegate = self
        //tableView.dataSource = self
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "docAuthorCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //Table view
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return titleSection[section]
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = self.tableView.dequeueReusableCellWithIdentifier("docAuthorCell")! as! DocAuthorViewCell
        
        cell.ClusterName.text = "test"
        
        return cell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
