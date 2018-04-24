//
//  Feature.swift
//  La Distrib'
//
//  Created by Daniel IKKA on 23/04/2018.
//  Copyright © 2018 Daniel IKKA. All rights reserved.
//

import Foundation
import UIKit

public class Feature :  NSObject {
    
    let title : String
    let image : UIImage
    let unitPrice : Double
    let multiple: Int?
    
    init(imageNamed: String, title: String, price: Double, multiple : Int?) {
        self.image = UIImage(named: imageNamed)!
        self.title = title
        self.unitPrice = price
        self.multiple = multiple
    }
}
