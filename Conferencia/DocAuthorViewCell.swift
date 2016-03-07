//
//  DocAuthorViewCell.swift
//  Conferencia
//
//  Created by Angélique Blondel on 04/03/2016.
//  Copyright © 2016 achan. All rights reserved.
//

import UIKit

class DocAuthorViewCell: UITableViewCell {

    @IBOutlet weak var ClusterName: UILabel!
    @IBOutlet weak var romm: UILabel!
    @IBOutlet weak var date: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
