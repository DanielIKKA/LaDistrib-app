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
    
    let kServiceModuleCBUUID = CBUUID(string: "FFE0")
    let kReadWriteCharacteristicCBUUID = CBUUID(string: "FFE1")
    
    var centralManager : CBCentralManager
    var modulePeripheral : CBPeripheral!
    
    init(delegate: CBCentralManagerDelegate? , queue: DispatchQueue?) {
        centralManager = CBCentralManager(delegate: delegate, queue: queue)
    }
}
