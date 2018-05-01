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
    }
    
    struct Key {
        static let kPaperSingle     = "paperSingle"
        static let kPaperMultiple   = "paperMultiple"
        static let kPencil          = "pencil"
        static let kPen             = "pen"
    }
    
    struct Title {
        static let kPaper       = "Papier 80g"
        static let kPencil      = "Critérium Bic"
        static let kBluePen     = "Stylo Bic Bleu"
        static let kRedPen      = "Stylo Bic Rouge"
    }
    
    struct UnitPrice {
        static let kPaperPrice  = 0.04
        static let kPencilPrice = 0.15
        static let kPenPrice    = 0.25
    }
}

public class Feature: NSManagedObject {
    
    public func setupConfiguration(forKey Key : String, numberOfpurshased nb: Int16 = 0) {
        
        switch Key {
            case FeatureConstants.Key.kPaperSingle:
                self.imageNamed = FeatureConstants.ImageName.kPaperSingle
                self.title = FeatureConstants.Title.kPaper
                self.unitPrice = FeatureConstants.UnitPrice.kPaperPrice
                break
            
            case FeatureConstants.Key.kPaperMultiple:
                self.imageNamed = FeatureConstants.ImageName.kPaperMultiple
                self.title = FeatureConstants.Title.kPaper
                self.unitPrice = FeatureConstants.UnitPrice.kPaperPrice
                break
            
            case FeatureConstants.Key.kPencil:
                self.imageNamed = FeatureConstants.ImageName.kPencil
                self.title = FeatureConstants.Title.kPencil
                self.unitPrice = FeatureConstants.UnitPrice.kPencilPrice
                break
            
            case FeatureConstants.Key.kPen:
                break
            default:
                break
        }
        
        self.multiplicator = nb
    }
}
