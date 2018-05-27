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

struct BluetoothConstantes {
    
    struct codeFeature {
        static let kPaper           = "0"
        static let kBluePen         = "1"
        static let kBlackPen        = "2"
        static let kGreenPen        = "3"
        static let kRedPen          = "4"
        static let kInk             = "5"
        static let kPencil          = "6"
    }
    
    struct Notifications {
        static let kDisponibilities = "updateData"
        static let kConnected       = "BLEConnected"
        static let kDisconnected    = "BLEdisconnected"
    }
    
    static let kEndKeyData      = Character("Z")
    static let kStoreRequestKey = Character("D")
    static let kSeparatorKey    = Character("A")
    
    static let kWaitingKey      = -1
    static let kUnavailable     =  0
}

class BluetoothManager {
    
    // MARK: Constantes
    let kServiceModuleCBUUID = CBUUID(string: "FFE0")
    let kReadWriteCharacteristicCBUUID = CBUUID(string: "FFE1")
    
    let kBuyFeature = "1"
    
    // MARK: Managers
    var centralManager : CBCentralManager
    var modulePeripheral : CBPeripheral!
    
    // MARK: Data
    var dataStr = String()
    
    
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
    func resetDataStr() {
        dataStr = ""
    }
}


