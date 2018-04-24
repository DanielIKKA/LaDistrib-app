//
//  CustomTableViewCell.swift
//  La Distrib'
//
//  Created by Daniel IKKA on 22/04/2018.
//  Copyright © 2018 Daniel IKKA. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var featureImage: UIImageView!
    @IBOutlet weak var featureTitle: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var multiple: UILabel!
    @IBOutlet weak var unitPrice: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
