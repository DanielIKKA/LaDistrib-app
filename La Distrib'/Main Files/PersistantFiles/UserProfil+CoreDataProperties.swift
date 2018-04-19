//
//  UserProfil+CoreDataProperties.swift
//  La Distrib'
//
//  Created by Daniel IKKA on 19/04/2018.
//  Copyright © 2018 Daniel IKKA. All rights reserved.
//
//

import Foundation
import CoreData


extension UserProfil {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserProfil> {
        return NSFetchRequest<UserProfil>(entityName: "UserProfil")
    }

    @NSManaged public var username: String?
    @NSManaged public var password: String?
    @NSManaged public var email: String?

}
