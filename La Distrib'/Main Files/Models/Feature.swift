//
//  Feature.swift
//  La Distrib'
//
//  Created by Daniel IKKA on 23/04/2018.
//  Copyright © 2018 Daniel IKKA. All rights reserved.
//

import Foundation
import UIKit

class Feature {
    
    let title : String
    let image : UIImage
    let price : Double
    
    init(image : UIImage, title: String, price: Double) {
        self.image = image
        self.title = title
        self.price = price
    }
}
