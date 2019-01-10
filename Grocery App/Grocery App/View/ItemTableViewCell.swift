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
    @IBOutlet var nameIconImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setupDateLabel(stringDate: String) {
        let dF = DateFormatter()
        dF.timeZone = NSTimeZone.default
        dF.dateFormat =  "yyyy-MM-dd HH:mm:ss Z"
        
        if let date = dF.date(from: stringDate) {
            let currentDate = Date()
            
            let components = Calendar.current.dateComponents([.day], from: date, to: currentDate)
            
            if components.day == 0 {
                dateLabel.text = "Added today"
            } else if components.day == 1{
                dateLabel.text = "Added \(components.day!) day ago"
            } else {
            dateLabel.text = "Added \(components.day!) days ago"
            }

        }
    }
}
