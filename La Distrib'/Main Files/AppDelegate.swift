//
//  AppDelegate.swift
//  La Distrib'
//
//  Created by Daniel IKKA on 12/04/2018.
//  Copyright © 2018 Daniel IKKA. All rights reserved.
//

import UIKit
import CoreData
import CoreBluetooth

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let dataController = DataController()
    var bluetoothController : BluetoothManager!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        bluetoothController = BluetoothManager(delegate: self, queue: nil)
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
}

// MARK: - CentralManagerDelegate
extension AppDelegate : CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
            
        case .unknown:
            print("central.state is unknown")
        case .resetting:
            print("central.state is resetting")
        case .unsupported:
            print("central.state is unsupported")
        case .unauthorized:
            print("central.state is unauthorized")
        case .poweredOff:
            print("central.state is poweredOff")
        case .poweredOn:
            print("central.state is poweredOn")
            bluetoothController?.centralManager.scanForPeripherals(withServices: [bluetoothController.kServiceModuleCBUUID])
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        bluetoothController.centralManager.stopScan()
        bluetoothController.modulePeripheral = peripheral
        bluetoothController.centralManager.connect(bluetoothController.modulePeripheral)
        bluetoothController.modulePeripheral.delegate = self
        
        
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        let notificationNameConnect = Notification.Name(rawValue : "BLEConnected")
        let notificationConnect = Notification(name: notificationNameConnect)
        NotificationCenter.default.post(notificationConnect)
        print("connected")
    bluetoothController.modulePeripheral.discoverServices([bluetoothController.kServiceModuleCBUUID])
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        let notificationNameConnect = Notification.Name(rawValue : "BLEdisconnected")
        let notificationConnect = Notification(name: notificationNameConnect)
        NotificationCenter.default.post(notificationConnect)
        print("disconnected")
        
        if central.state == .poweredOn {
            bluetoothController?.centralManager.scanForPeripherals(withServices: [bluetoothController.kServiceModuleCBUUID])
        }
    }
    
}

// MARK: - PeripheralDelegate
extension AppDelegate : CBPeripheralDelegate {
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        
        for service in services {
            bluetoothController.modulePeripheral.discoverCharacteristics([bluetoothController.kReadWriteCharacteristicCBUUID], for: service)
            print(service)
        }
    }
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard service.characteristics != nil else { return }
        
        for characteristic in service.characteristics! {
            if(characteristic.properties.contains(.notify)) {
                print("notified is available")
                bluetoothController.modulePeripheral.setNotifyValue(true, for: characteristic)
            }
            if characteristic.properties.contains(.read) {
                print("read too")
            }
            if characteristic.properties.contains(.writeWithoutResponse) {
                print("write too")
            }
            
            
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        let data = characteristic.value
        guard data != nil else { return }
        
        // then the string
        if let str = String(data: data!, encoding: String.Encoding.utf8) {
            bluetoothController.dataStr = str
            print(bluetoothController.dataStr!)
        }
    }
}

