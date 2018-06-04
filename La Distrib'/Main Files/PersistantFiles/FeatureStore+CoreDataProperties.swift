//
//  FeatureStore+CoreDataProperties.swift
//  La Distrib'
//
//  Created by Daniel IKKA on 06/05/2018.
//  Copyright © 2018 Daniel IKKA. All rights reserved.
//
//

import Foundation
import CoreData


extension FeatureStore {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FeatureStore> {
        return NSFetchRequest<FeatureStore>(entityName: "FeatureStore")
    }

    @NSManaged public var title: String?
    @NSManaged public var unitPrice: Double
    @NSManaged public var imageNamed: String?
    @NSManaged public var multiplicator: Int16
    @NSManaged public var stock: Int16
    
}
