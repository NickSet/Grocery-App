//
//  ItemTableViewCell.swift
//  Grocery App
//
//  Created by Nicholas Setliff on 12/14/18.
//  Copyright © 2018 Nicholas Setliff. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var quantityLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var checkBox: M13Checkbox!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        checkBox.stateChangeAnimation = M13Checkbox.Animation.spiral
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
