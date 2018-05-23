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
    
    struct Disponibilities {
        static let kPaper           = "D0"
        static let kBluePen         = "D1"
        static let kBlackPen        = "D2"
        static let kGreenPen        = "D3"
        static let kRedPen          = "D4"
        static let kInk             = "D5"
        static let kPencil          = "D6"
    }
    
    struct Notifications {
        static let kDisponibilities = "updateData"
        static let kConnected       = "BLEConnected"
        static let kDisconnected    = "BLEdisconnected"
    }
    
    static let kEndData = Character("Z")
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
    @objc private func resetDataStr() {
        dataStr = ""
    }
}


