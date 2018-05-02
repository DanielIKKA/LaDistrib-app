//
//  UserProfil+CoreDataProperties.swift
//  La Distrib'
//
//  Created by Daniel IKKA on 26/04/2018.
//  Copyright © 2018 Daniel IKKA. All rights reserved.
//
//

import Foundation
import CoreData


extension UserProfil {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserProfil> {
        return NSFetchRequest<UserProfil>(entityName: "UserProfil")
    }

    @NSManaged public var email: String
    @NSManaged public var isConnected: Bool
    @NSManaged public var isStayConnect: Bool
    @NSManaged public var password: String
    @NSManaged public var username: String
    @NSManaged public var balance: Double
    @NSManaged public var isAdmin: Bool
    @NSManaged public var feature: NSSet?

}

// MARK: Generated accessors for feature
extension UserProfil {

    @objc(addFeatureObject:)
    @NSManaged public func addToFeature(_ value: Feature)

    @objc(removeFeatureObject:)
    @NSManaged public func removeFromFeature(_ value: Feature)

    @objc(addFeature:)
    @NSManaged public func addToFeature(_ values: NSSet)

    @objc(removeFeature:)
    @NSManaged public func removeFromFeature(_ values: NSSet)

}
