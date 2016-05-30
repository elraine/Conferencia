
import UIKit


class ProgramViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    /*
        DATAS
     */
    // Events table show in the Table View
    var events = [Event]()
    
    // Sections table of time slots
    var source = [String]()
    
    /*
        VIEW
     */
    
    // Date and Time View
    let date = DateView()
    
    @IBOutlet weak var tableView: UITableView!
    
    // Correspond at a Day
    var pagenumber = 0
    
    // Array of section
    var sections : [(index: Int, length :Int, title: String)] = Array()
    

    /*
        TABLE BAR BUTTON
     */
    
    // Refresh data base button
    @IBAction func refresh(sender: UIBarButtonItem) {
        let _ = manager.update()
    }
    
    
    
    // MARK: VIEWS EVENTS
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        /* DATA initialisation */
        
        do{
            source = try EventDataHelper.findDaySlot()!
            events = try EventDataHelper.findEventByDay(source[pagenumber])!
        }catch{
            print("inialisation of datas fail : \(error)")
        }
        
        
        /* View */
        
        // link delegate methods and dataSource methods of the table view tableView with methods of ProgramViewController
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // Swipe handle
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(ProgramViewController.handleSwipes(_:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(ProgramViewController.handleSwipes(_:)))
        
        leftSwipe.direction = .Left
        rightSwipe.direction = .Right
        
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
        
        						
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        /* View */
        
        
        self.title = date.dateView(source[pagenumber])
        
      
        //Index list of section
        self.timeIndex()
        
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
    
    
    // MARK:  UITableViewDataSource
    
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("eventCell", forIndexPath: indexPath) as! EventViewCell
        
        

        /* Initialisation of a cell */
        let event = events[sections[indexPath.section].index + indexPath.row]
        cell.type.text = event.type
        cell.timeS.text = date.timeView(event.time_start)
        
        cell.timeE.text = date.timeView(event.time_end)
        cell.name.text = event.title
      
    
        
        // handle when the event have no room associate
        if event.roomid == -1{
            cell.room.text = ""
        }else{
            do{
            let room = try RoomDataHelper.find(event.roomid)
             cell.room.text = "Room: \(room!.name)"
            }catch{print("Room : \(error)")}
            
            
        }
        return cell
    }
    
   
    // MARK: Swipes between days of the conference

    func handleSwipes(sender:UISwipeGestureRecognizer) {
        if (sender.direction == .Left) {
            
            
            if pagenumber < source.count - 1 {
                pagenumber = pagenumber + 1
                
                // Load Datas
                do{
                    events = try EventDataHelper.findEventByDay(source[pagenumber])!
                }catch{print("EventDataHelper : \(error)")}
                
                
                // Index list
                self.timeIndex()
                
                // View
                self.tableView.reloadData()
                self.title = date.dateView(source[pagenumber])
            }
        }
        
        if (sender.direction == .Right) {
            
            
            if pagenumber > 0 {
                pagenumber = pagenumber - 1
                
                // Load Datas
                do{
                    events = try EventDataHelper.findEventByDay(source[pagenumber])!
                }catch{print("EventDataHelper : \(error)")}
              
                // Index list
                self.timeIndex()
                
                // View
                self.tableView.reloadData()
                self.title = date.dateView(source[pagenumber])
            }
        }
    }
    
  
    
    
    // MARK: Helped Methodes

    
    func timeIndex(){
        var index = 0;
        
        events.sortInPlace { $0.time_start < $1.time_start }
        sections.removeAll()
        
        // time slot research algorithm
        for ( var i = 0; i < events.count; i += 1 ) {
            
            
            let common = events[i].time_start.containsString(events[index].time_start)
     
            
            if common == false || (common == true && i ==  events.count - 1){
                
                let start = date.timeView(events[index].time_start)
                
                let end = date.timeView(events[index].time_end)
                
                let title = "\(start) - \(end)"
                
                if i - index == 0 {
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
    

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowDetailIdentifier" {
            
            let selectedDocCell = sender as? UITableViewCell
            let indexPath = self.tableView.indexPathForCell(selectedDocCell!)!
            let event = self.events[sections[indexPath.section].index + indexPath.row]
            
            var selectedDoc: [Doc]?
            var room : Room?
            do{
                selectedDoc = try DocDataHelper.findByEvent(event.eventid)
                room = try RoomDataHelper.find(event.roomid)
            }catch{print("prepareForSegue : DocDataHelper : \(error)")}
            
            if selectedDoc!.count > 0 {
            
                let SubDocViewController = (segue.destinationViewController as! UINavigationController).topViewController as! DocViewController
                    print("JE SUIS PASSE DANS LE IF")
                
                
                SubDocViewController.docs = selectedDoc!
                SubDocViewController.clusterlabel = event.title
                SubDocViewController.daylabel = "\(date.dateView(event.date)) | \(date.timeView(event.time_start)) - \(date.timeView(event.time_end))"
                if event.roomid == -1{
                    SubDocViewController.roomlabel = ""
                }else{
                    SubDocViewController.roomlabel = "Room: \(room!.name)"
                }
                print(selectedDoc)
                
                }
            
            }
    }
    
    
}



