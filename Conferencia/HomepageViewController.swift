

import UIKit
import SQLite

let CONF_ID = 1601
let firstConnection = 0
let manager = SetDataManager(id: CONF_ID)
var dict = (Array<Int>)()

class HomepageViewController: UIViewController {
    
    @IBOutlet weak var Progress: UIProgressView!
    @IBOutlet weak var progressButton: UIButton!
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    let SQLBase = SQLiteDataStore.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        progressButton.setTitle("Progress is HERE",forState: UIControlState.Normal)
        
       
        //manager.update()
    }
    
    @IBAction func progressButtonAct(sender: AnyObject) {
        do{
            try dropData()
        }catch{}
        NSUserDefaults.standardUserDefaults().removeObjectForKey("isAppAlreadyLaunchedOnce")
        localStorageHelper().deleteDict()
        print("reset to zero")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if( isAppAlreadyLaunchedOnce() == false ){
            print("first time")
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
                do{
                    
                    localStorageHelper().start()
                    try self.SQLBase.createTables()
                    
                }catch{
                    print("Creation de la Base de données : \(error)")
                }
                
                dispatch_async(dispatch_get_main_queue()) {
                  LoadingOverlay.shared.showOverlay(self.view)

                }
            }
            
            
                        let finish = manager.firstConnection()
            //first = true
        }else{
            //dict = NSUserDefaults.standardUserDefaults().arrayForKey("MyPlanning") as! Array<Int>
        }
        delay(10){
            LoadingOverlay.shared.hideOverlayView()
        }
        let time = NSDate()
        let currentMin = time.minute()
        let span = Float(currentMin)/60.0
        Progress.setProgress(span, animated: false)
        print("\(currentMin) : \(span)")
        
    }
   
    func resetData(){
        do {
            if let events = try EventDataHelper.findAll() {
                for event in events {
                    try EventDataHelper.delete(event)
                    
                }
            }
            if let rooms = try RoomDataHelper.findAll() {
                for room in rooms {
                    try RoomDataHelper.delete(room)
                    
                }
            }
            if let docs = try DocDataHelper.findAll() {
                for doc in docs {
                    try DocDataHelper.delete(doc)
                }
            }
            if let authors = try AuthorDataHelper.findAll() {
                for author in authors {
                    try AuthorDataHelper.delete(author)
                    
                }
            }
            if let affiliations = try AffiliationDataHelper.findAll() {
                for affiliation in affiliations {
                    try AffiliationDataHelper.delete(affiliation)
                    
                }
            }
            if let locateds = try LocatedDataHelper.findAll() {
                for located in locateds {
                    try LocatedDataHelper.delete(located)
                    
                }
            }
            if let comeFroms = try ComeFromDataHelper.findAll() {
                for comeFrom in comeFroms {
                    try ComeFromDataHelper.delete(comeFrom)
                    
                }
            }
        } catch _ {}
    }
    
    func dropData() throws {
        guard let DB = SQLiteDataStore.sharedInstance.CDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        let bass = ["Affilations","Authors","Clusters","ComeFrom","Conferences","Docs","Events","Located","Locations","Rooms"]
        do{
            for t in bass{
                try DB.run(Table(t).drop(ifExists: true))
            }
        }catch{
            print("cant drop")
        }
    }
    
    func isAppAlreadyLaunchedOnce()->Bool{
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let _ = defaults.stringForKey("isAppAlreadyLaunchedOnce"){
            print("App already launched")
            return true
        }else{
            defaults.setBool(true, forKey: "isAppAlreadyLaunchedOnce")
            print("App launched first time")
            return false
        }
    }

    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
}