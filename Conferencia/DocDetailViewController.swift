
import UIKit

class DocDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var doc : Doc?
    var event : Event?
    var room : Room?
   
    // Date View
    let dateV = DateView()
    
    @IBOutlet weak var clusterName: UILabel!
    @IBOutlet weak var docName: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var roomName: UILabel!   
    @IBOutlet weak var abstractView: UITextView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableView2: UITableView!
    
    @IBOutlet weak var contentView: UIView!
    @IBAction func cancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBOutlet weak var addToFavorite: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView2.delegate = self
        tableView2.dataSource = self
        
        
        
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
         let scrollViewInsets = UIEdgeInsetsZero
         scrollView.contentInset = scrollViewInsets
   
        
   
    }
    
    override func viewWillAppear(animated: Bool) {
        //base
        
        do{
            
            let located = try LocatedDataHelper.find(doc!.docid)
            event = try EventDataHelper.find(doc!.eventid)
            room = try RoomDataHelper.find(event!.roomid)
            
            
            for l in located! {
                if l.speaker.containsString("1") {
                    Speaker.append(l)
                }else{
                    CoAuthors.append(l)
                }
            }
        
        }catch{}
        
        // Set information
        clusterName.text = event!.title
        docName.text = doc!.title
        date.text = "\(dateV.dateView(event!.date)) | \(dateV.timeView(doc!.time_start)) - \(dateV.timeView(doc!.time_end))"
        if event!.roomid == -1{
            roomName.text = ""
        }else{
            roomName.text = "Room: \(room!.name)"
        }
        abstractView.text = doc!.abstract
    
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
  
    
    // MARK: - Contributors Table View
    var Speaker = [Located]()
    var CoAuthors = [Located]()
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView{
            return Speaker.count
            
        }else{
            return CoAuthors.count
            
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if tableView == self.tableView{
            let cell = tableView.dequeueReusableCellWithIdentifier("speakerCell", forIndexPath: indexPath) as UITableViewCell
            cell.textLabel?.text = "\(self.Speaker[indexPath.row].lastname) \(self.Speaker[indexPath.row].firstname)"
            return cell
        }else{
            let cell = tableView.dequeueReusableCellWithIdentifier("coAuthorsCell", forIndexPath: indexPath) as UITableViewCell
            cell.textLabel?.text = "\(self.CoAuthors[indexPath.row].lastname) \(self.CoAuthors[indexPath.row].firstname)"
            return cell
        }
        
    }
   
     // MARK: - Navigation
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
      
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
         print(segue.identifier )
        if segue.identifier == "ShowAuthor1" {
            let AuthorDetailViewController = (segue.destinationViewController as! UINavigationController).topViewController as! AuthorViewController
            if let selectedAuthorCell = sender as? UITableViewCell {
                let indexPath = self.tableView.indexPathForCell(selectedAuthorCell)!
                
                do{
                    let l = self.Speaker[indexPath.row]
                    let selectedAuthor : [Author] = try AuthorDataHelper.find(l.lastname, firstname: l.firstname)!
                   
                    
                    AuthorDetailViewController.author = selectedAuthor[0]
                }catch{print("find Author from located : \(error)")}
                
            }
        }else if segue.identifier == "ShowAuthor2" {
            
            let AuthorDetailViewController = (segue.destinationViewController as! UINavigationController).topViewController as! AuthorViewController
            if let selectedAuthorCell = sender as? UITableViewCell {
                let indexPath = self.tableView2.indexPathForCell(selectedAuthorCell)!
                
                do{
                    let l = self.CoAuthors[indexPath.row]
                    let selectedAuthor : [Author] = try AuthorDataHelper.find(l.lastname, firstname: l.firstname)!
                    
                    
                    AuthorDetailViewController.author = selectedAuthor[0]
                }catch{print("find Author from located : \(error)")}
            
            }
        }
    }
    
    @IBAction func addFav(sender: UIBarButtonItem) {
        do{
                print("ok")
            localStorageHelper().addItem(Int(doc!.eventid))
//                try DocDataHelper.MyProgram(doc!.docid, add : true)
                print(localStorageHelper().getDict())
            }catch{
                print("you dun wrong")
        }

    }
}
    //FAVORITE STAR[
//    func tapped(sender: UIBarButtonItem ){
//
//        let i = sender.tag
//        if sender.selected {
            // deselect
            //            sender.deselect()
//        } else {
//            // select with animation
//            sender.select()
//        }
//    }
    //]FAVORITE STAR
    


