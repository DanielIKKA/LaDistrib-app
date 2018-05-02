//
//  CustomStoreTableViewCell.swift
//  La Distrib'
//
//  Created by Daniel IKKA on 30/04/2018.
//  Copyright © 2018 Daniel IKKA. All rights reserved.
//

import UIKit

class CustomStoreTableViewCell: UITableViewCell {
    
    //MARK: - IBOutlets
    @IBOutlet weak var featureImage: UIImageView!
    @IBOutlet weak var featureTitle: UILabel!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var unitPrice: UILabel!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    
    //MARK: - Variables
    var price = Double()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func changeValueNumberOfPurshased(_ sender: UIButton) {
        var number : Int? = Int(numberTextField.text!)
        
        if(sender.tag == 0) {
            if(number != nil && number! > 0) {
                number! -= 1
            }
        } else if (sender.tag == 1) {
            if(number != nil) {
                number! += 1
            }
        }
        numberTextField.text! = number!.description
        numberTextField.becomeFirstResponder()
        numberTextField.resignFirstResponder()
    }
}
