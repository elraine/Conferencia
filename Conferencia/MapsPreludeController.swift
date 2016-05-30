

import UIKit

class MapsPreludeController: UIViewController{

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Maps"
    }
    
    @IBOutlet weak var navBar: UINavigationBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //        - #f6b540 (jaune)
        //        - #fab12f (jaune un peu plus foncé)
        //        - #86BBD8 (bleu)
        
        
        // Status bar white font
        self.navBar.barStyle = UIBarStyle.Black
        self.navBar.barTintColor = UIColor(hex : "#86BBD8")
        self.navBar.tintColor = UIColor.whiteColor()
    }
    
    @IBAction func prepareForUnwind(unwindSegue: UIStoryboardSegue){
    }
}