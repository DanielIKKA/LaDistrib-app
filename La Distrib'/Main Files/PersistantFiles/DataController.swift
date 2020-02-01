//
//  UserProfil.swift
//  La Distrib'
//
//  Created by Daniel IKKA on 19/04/2018.
//  Copyright © 2018 Daniel IKKA. All rights reserved.
//

import Foundation
import CoreData

class DataController {
    
    // MARK: - Core Data stack
    let persistentContainer : NSPersistentContainer
    let managedObjectContext: NSManagedObjectContext
    
    let featuresKey : [String] = [FeatureConstants.Key.kPaperSingle , FeatureConstants.Key.kPencil, FeatureConstants.Key.kBlackPen, FeatureConstants.Key.kBluePen, FeatureConstants.Key.kRedPen, FeatureConstants.Key.kGreenPen, FeatureConstants.Key.kInk]
    var featuresStore = [FeatureStore]()
    
    init() {
        persistentContainer = NSPersistentContainer(name: "La_Distrib_")
        persistentContainer.loadPersistentStores() { (description, error) in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
        managedObjectContext = persistentContainer.viewContext
        setupStore()
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
    
    // MARK: - Store Data Service
    private func setupStore() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FeatureStore")
        
        do {
            let feature = try managedObjectContext.fetch(fetchRequest) as! [FeatureStore]
            if(feature.isEmpty){
                createStore()
            } else {
                self.featuresStore = feature
            }
            
        } catch {
            fatalError("there are an error fetching the list of UsersProfils")
        }
    }
    
    private func createStore() {
        for key in featuresKey {
            let feature = FeatureStore(context: managedObjectContext)
            feature.setupConfiguration(forKey: key, numberOfpurshased: nil)
            featuresStore.append(feature)
        }
    }

}

