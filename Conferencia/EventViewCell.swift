
import UIKit

class EventViewCell: UITableViewCell {

    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var room: UILabel!
    @IBOutlet weak var timeS: UILabel!
    @IBOutlet weak var timeE: UILabel!
  
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}
