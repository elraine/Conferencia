//
//  DocViewCell.swift
//  Conferencia
//
//  Created by Angélique Blondel on 24/03/2016.
//  Copyright © 2016 achan. All rights reserved.
//

import UIKit

class DocViewCell: UITableViewCell {
    
  
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var speaker: UILabel!
    
    @IBOutlet weak var timeS: UILabel!
    @IBOutlet weak var timeE: UILabel!
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
