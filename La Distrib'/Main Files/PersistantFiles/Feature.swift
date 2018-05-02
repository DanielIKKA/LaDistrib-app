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
            
            case FeatureConstants.Key.kRedPen, FeatureConstants.Key.kBluePen, FeatureConstants.Key.kBlackPen, FeatureConstants.Key.kGreenPen:
                self.unitPrice = FeatureConstants.UnitPrice.kPenPrice
                if(Key == FeatureConstants.Key.kGreenPen){
                    self.title = FeatureConstants.Title.kGreenPen
                    self.imageNamed = FeatureConstants.ImageName.kGreenPen
                } else if (Key == FeatureConstants.Key.kBluePen){
                    self.title = FeatureConstants.Title.kBluePen
                    self.imageNamed = FeatureConstants.ImageName.kBluePen
                } else if(Key == FeatureConstants.Key.kRedPen){
                    self.title = FeatureConstants.Title.kRedPen
                    self.imageNamed = FeatureConstants.ImageName.kRedPen
                } else if(Key == FeatureConstants.Key.kBlackPen){
                    self.title = FeatureConstants.Title.kBlackPen
                    self.imageNamed = FeatureConstants.ImageName.kBlackPen
                }
                break
            case FeatureConstants.Key.kInk :
                self.imageNamed = FeatureConstants.ImageName.kInk
                self.title = FeatureConstants.Title.kInk
                self.unitPrice = FeatureConstants.UnitPrice.kInkPrice
            break
            
            default:
                break
        }
        self.multiplicator = nb
    }
}
