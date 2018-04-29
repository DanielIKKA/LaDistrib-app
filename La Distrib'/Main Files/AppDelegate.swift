//
//  AppDelegate.swift
//  La Distrib'
//
//  Created by Daniel IKKA on 12/04/2018.
//  Copyright © 2018 Daniel IKKA. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let dataController = DataController()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
//        print("\n1\n")
        return true
        
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
//        print("\n2\n")
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//        print("\n\nHEY\n\n")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
//        print("\n3\n")
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//        print("\n4\n")
    }
    
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        dataController.saveContext()
    }
    
    //MARK: CoreData
    
//    public func addFeature(forSetupKey key: String) -> Feature {
//        guard let entity = NSEntityDescription.entity(forEntityName: "Feature", in: AppDelegate.persistentContainer.viewContext) else {
//            fatalError("could not find entity description")
//        }
//
//        let feature = NSManagedObject(entity: entity, insertInto: AppDelegate.persistentContainer.viewContext) as! Feature
//
//        feature.setupConfiguration(forKey: key)
//
//        return feature
//    }
}

