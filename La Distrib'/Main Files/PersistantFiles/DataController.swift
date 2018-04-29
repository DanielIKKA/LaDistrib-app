//
//  UserProfil.swift
//  La Distrib'
//
//  Created by Daniel IKKA on 19/04/2018.
//  Copyright © 2018 Daniel IKKA. All rights reserved.
//

import Foundation
import CoreData

class DataController : NSObject {
    
    // MARK: - Core Data stack
    let persistentContainer : NSPersistentContainer
    let managedObjectContext: NSManagedObjectContext
    
    override init() {
        persistentContainer = NSPersistentContainer(name: "La_Distrib_")
        persistentContainer.loadPersistentStores() { (description, error) in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
        
        managedObjectContext = persistentContainer.viewContext
    }
    
    // MARK: - Core Data Saving support
    
    func saveContext() {
        
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

