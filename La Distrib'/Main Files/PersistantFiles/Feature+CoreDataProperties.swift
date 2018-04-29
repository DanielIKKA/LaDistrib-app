//
//  Feature+CoreDataProperties.swift
//  La Distrib'
//
//  Created by Daniel IKKA on 26/04/2018.
//  Copyright © 2018 Daniel IKKA. All rights reserved.
//
//

import Foundation
import CoreData


extension Feature {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Feature> {
        return NSFetchRequest<Feature>(entityName: "Feature")
    }

    @NSManaged public var imageNamed: String
    @NSManaged public var title: String
    @NSManaged public var unitPrice: Double
    @NSManaged public var multiplicator: Int16
    @NSManaged public var owner: UserProfil?

}
