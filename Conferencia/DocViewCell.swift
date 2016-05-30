
import UIKit

class DocViewCell: UITableViewCell {
    
  
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var speaker: UILabel!
    
    @IBOutlet weak var timeS: UILabel!
    @IBOutlet weak var timeE: UILabel!
    @IBOutlet weak var favstar: UIButton!
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}
