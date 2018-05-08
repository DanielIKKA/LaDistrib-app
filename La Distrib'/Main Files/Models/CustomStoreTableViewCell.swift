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
    var feature : FeatureStore!
    var dataController : DataController {
        return (UIApplication.shared.delegate as! AppDelegate).dataController
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup() {
        featureImage.image = UIImage(named : feature.imageNamed!)
        featureTitle.text = feature.title
        unitPrice.text = "\(String(describing: feature.unitPrice))€"
        
        numberTextField.text = String(feature.multiplicator)
        
        selectionStyle = .none
        dataController.saveContext()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    @IBAction func changeValueNumberOfPurshased(_ sender: UIButton) {
        
        if(sender.tag == 0) {
            if(feature.multiplicator > 0) {
                feature.multiplicator -= 1
            }
        } else if (sender.tag == 1) {
                feature.multiplicator += 1
        }
        numberTextField.text! = feature.multiplicator.description
        dataController.saveContext()
    }
}
