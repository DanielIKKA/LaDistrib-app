//
//  CustomTextField.swift
//  La Distrib'
//
//  Created by Daniel IKKA on 14/04/2018.
//  Copyright © 2018 Daniel IKKA. All rights reserved.
//

import UIKit

@IBDesignable
class CustomTextField: UITextField {

    //MARK: - Attributs
    @IBInspectable var insetX: CGFloat = 0
    @IBInspectable var insetY: CGFloat = 0
    
    //MARK: - Overrides
    //placeholder position
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: insetX, dy: insetY)
    }
    //text position
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: insetX, dy: insetY)
    }
}
