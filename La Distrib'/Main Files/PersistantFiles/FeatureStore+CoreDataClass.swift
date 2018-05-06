//
//  FeatureStore+CoreDataClass.swift
//  La Distrib'
//
//  Created by Daniel IKKA on 06/05/2018.
//  Copyright © 2018 Daniel IKKA. All rights reserved.
//
//

import Foundation
import CoreData

@objc(FeatureStore)
public class FeatureStore: NSManagedObject {
    
    public func setupConfiguration(forKey Key : String, numberOfpurshased nb: Int16?) {
        
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
        if nb == nil {
            self.multiplicator = 0
        } else {
            self.multiplicator = nb!
        }
    }
}
