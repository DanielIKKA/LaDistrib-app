//
//  CustomStoreTableViewCell.swift
//  La Distrib'
//
//  Created by Daniel IKKA on 30/04/2018.
//  Copyright © 2018 Daniel IKKA. All rights reserved.
//

import UIKit

class CustomStoreTableViewCell: UITableViewCell {

    @IBOutlet weak var featureImage: UIImageView!
    @IBOutlet weak var featureTitle: UILabel!
    //@IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var unitPrice: UILabel!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
