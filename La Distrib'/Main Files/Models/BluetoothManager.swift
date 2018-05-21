//
//  BluetoothManager.swift
//  La Distrib'
//
//  Created by Daniel IKKA on 08/05/2018.
//  Copyright © 2018 Daniel IKKA. All rights reserved.
//

import Foundation
import UIKit
import CoreBluetooth

class BluetoothManager {
    
    // MARK: Constantes
    let kServiceModuleCBUUID = CBUUID(string: "FFE0")
    let kReadWriteCharacteristicCBUUID = CBUUID(string: "FFE1")
    
    let kBuyFeature = "1"
    
    // MARK: Managers
    var centralManager : CBCentralManager
    var modulePeripheral : CBPeripheral!
    
    // MARK: Data
    var dataStr : String?
    
    
    init(delegate: CBCentralManagerDelegate? , queue: DispatchQueue?) {
        centralManager = CBCentralManager(delegate: delegate, queue: queue)
    }
    
    func writeValue(data: String){
        let data = (data as NSString).data(using: String.Encoding.utf8.rawValue)
        if let peripheralDevice = modulePeripheral{
            if let deviceCharacteristics = modulePeripheral.services?.first?.characteristics?.first {
                peripheralDevice.writeValue(data!, for: deviceCharacteristics, type: CBCharacteristicWriteType.withoutResponse)
            }
        }
    }
}
