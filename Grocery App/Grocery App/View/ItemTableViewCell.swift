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
            let currentComponents = NSCalendar.current.dateComponents(in: NSTimeZone.default, from: currentDate)
            let dateComponents = NSCalendar.current.dateComponents(in: NSTimeZone.default, from: date)
            let differenceInDays = currentComponents.day! - dateComponents.day!
            if differenceInDays == 0 {
                dateLabel.text = "Added today"
            } else if differenceInDays == 1{
                dateLabel.text = "Added \(differenceInDays) day ago"
            } else {
                dateLabel.text = "Added \(differenceInDays) days ago"
            }

        }
    }
}
