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
    @IBOutlet weak var stockLabel: UILabel!
    
    //MARK: - Variables
    var feature : FeatureStore!
    var stock : Int = -1
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
        stock = Int(feature.stock)
        
        numberTextField.text = String(feature.multiplicator)
        
        if(stock == -1) {
            stockLabel.text = "Waiting disponibilities"
            stockLabel.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        } else if(stock > 0 ) {
            stockLabel.text = "Stock \(stock)"
            stockLabel.textColor = #colorLiteral(red: 0.3558041453, green: 0.4711943533, blue: 0, alpha: 1)            
        } else {
            stockLabel.text = "Unavailable"
            stockLabel.textColor = #colorLiteral(red: 0.5954171419, green: 0.1898292303, blue: 0.3689950109, alpha: 1)
        }
        
        
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
            let tmp = feature.multiplicator + 1
            if (tmp > feature.stock || tmp == BluetoothConstantes.kUnavailable) && stock != BluetoothConstantes.kWaitingKey {
                return
            } else {
                feature.multiplicator += 1
            }
            
        }
        numberTextField.text! = feature.multiplicator.description
        dataController.saveContext()
    }
}
