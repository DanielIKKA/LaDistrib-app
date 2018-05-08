//
//  Feature+CoreDataClass.swift
//  La Distrib'
//
//  Created by Daniel IKKA on 26/04/2018.
//  Copyright © 2018 Daniel IKKA. All rights reserved.
//
//

import Foundation
import CoreData

struct FeatureConstants {
    
    struct ImageName {
        static let kPaperSingle     = "paperIconSingle"
        static let kPaperMultiple   = "paperIconMultiple"
        static let kPencil          = "pencilIcon"
        static let kBluePen         = "BluePen"
        static let kBlackPen        = "BlackPen"
        static let kGreenPen        = "GreenPen"
        static let kRedPen          = "RedPen"
        static let kInk             = "inkIcon"
    }
    
    struct Key {
        static let kPaperSingle     = "paperSingle"
        static let kPaperMultiple   = "paperMultiple"
        static let kPencil          = "pencil"
        static let kBluePen         = "BluePen"
        static let kBlackPen        = "BlackPen"
        static let kGreenPen        = "GreenPen"
        static let kRedPen          = "RedPen"
        static let kInk             = "inkIcon"
    }
    
    struct Title {
        static let kPaper       = "Papier 80g"
        static let kPencil      = "Critérium Bic"
        static let kBluePen     = "Stylo Bic Bleu"
        static let kRedPen      = "Stylo Bic Rouge"
        static let kGreenPen    = "Stylo Bic Vert"
        static let kBlackPen    = "Stylo Bic Noir"
        static let kInk         = "Cartouches d'endre"
    }
    
    struct UnitPrice {
        static let kPaperPrice  = 0.04
        static let kPencilPrice = 0.15
        static let kPenPrice    = 0.25
        static let kInkPrice    = 0.45
    }
}

public class Feature: NSManagedObject {
    public func setup(purchase : FeatureStore) {
        self.imageNamed = purchase.imageNamed!
        self.title = purchase.title!
        self.multiplicator = purchase.multiplicator
        self.unitPrice = purchase.unitPrice
    }
}
