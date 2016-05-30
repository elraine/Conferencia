
import UIKit

class AuthorViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    /*
     DATAS
     */
    
    // Author of the view
    var author : Author?
    
    // Arrays of Talks docs and Co-Authorship docs
    var docsTalks = [Doc]()
    var docsCoAuthorship = [Doc]()
    
    /*
     VIEW
     */
    
    // Date and Time View
    let date = DateView()
    
    // View Objects
    @IBOutlet weak var speakerName: UILabel!
    @IBOutlet weak var speakerUniversity: UILabel!
    
    // Table View of the list of Talks
    @IBOutlet weak var tableView: UITableView!
    
    // Table View of the list of Co-Authorship
    @IBOutlet weak var tableView2: UITableView!
    
    // Handle the case of array nil
    @IBOutlet weak var noneTalks: UILabel!
    @IBOutlet weak var noneCoAuthorship: UILabel!
    
    
    /*
     TABLE BAR BUTTON
     */
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: VIEWS EVENTS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* DATA initialisation */
        
        var affiliation : String = ""
        do{
             // Find the first university which come from the author
            let comeFrom = try ComeFromDataHelper.find(self.author!.firstname, lastname: self.author!.lastname)
            if comeFrom!.count > 0 {
                affiliation = comeFrom![0].affiliationname
            }
            
             // Separate the 2 types of docs
            let located = try LocatedDataHelper.find(self.author!.firstname, lastname: self.author!.lastname)
            
            for l in located! {
                let doc : Doc = try DocDataHelper.find(l.docid)!
                if l.speaker.containsString("1") {
                    docsTalks.append(doc)
                    
                }else{
                    docsCoAuthorship.append(doc)
                   
                }
            }
        }
        catch{print("inialisation of datas fail : \(error)")}
        
        
        /* View */
        
        
        speakerName.text = "\(self.author!.lastname) \(self.author!.firstname)"
        speakerUniversity.text = affiliation
        
        // link delegate methods and dataSource methods of the table view tableView and tableView2 with methods of ProgramViewController
        // rem : we use the same code to handle these 2 diffents table view
        tableView.delegate = self
        tableView.dataSource = self
        tableView2.delegate = self
        tableView2.dataSource = self
        
        // Error Case : if the author have no talks or Co-Authorship
        if docsTalks.count == 0{
            tableView.hidden = true
            
        }else{
            noneTalks.hidden = true
           
            // Constraint : resize the tableView to the minimize height
            let size = tableView.rowHeight * CGFloat(docsTalks.count)
            let widthConstraint = NSLayoutConstraint(item: tableView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: size)
            tableView.addConstraint(widthConstraint)
        }
        
        if docsCoAuthorship.count == 0{
            tableView2.hidden = true
        }else{
            noneCoAuthorship.hidden = true
            
            let size = tableView2.rowHeight * CGFloat(docsCoAuthorship.count)
            let widthConstraint = NSLayoutConstraint(item: tableView2, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: size)
            tableView2.addConstraint(widthConstraint)
        }
        
    }
  
    
    
    // MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView{
            return docsTalks.count
        }else{
            return docsCoAuthorship.count
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var doc : Doc?
        if tableView == self.tableView{
            
            doc = docsTalks[indexPath.row]
            print("doc")
            let cell = self.tableView.dequeueReusableCellWithIdentifier("talkscell")! as! EventViewCell
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
            
            cell.timeS.text = date.timeView(doc!.time_start)
            cell.timeE.text = date.timeView(doc!.time_end)
            
            
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
            
            cell.timeS.text = date.timeView(doc!.time_start)
            cell.timeE.text = date.timeView(doc!.time_end)
            
            return cell

        }
        
        
        
    }
    

    
    // MARK: - Navigation

    
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
    

    
}
