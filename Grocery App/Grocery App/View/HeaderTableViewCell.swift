//
//  HeaderTableViewCell.swift
//  Grocery App
//
//  Created by Nicholas Setliff on 12/15/18.
//  Copyright © 2018 Nicholas Setliff. All rights reserved.
//

import UIKit

class HeaderTableViewCell: UITableViewCell {
    @IBOutlet var emojiLabel: UILabel!
    @IBOutlet var sectionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
