//
//  HomeViewController.swift
//  La Distrib'
//
//  Created by Daniel IKKA on 13/04/2018.
//  Copyright © 2018 Daniel IKKA. All rights reserved.
//

import UIKit


class HomeViewController: UIViewController {
    
    /*-------------------------------*/
        // MARK: - Public Attributs
    /*-------------------------------*/
    //MARK: Outlets
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var historyList: UITableView!
    @IBOutlet weak var bluetoothButton: UIButton!
    
    //MARK: Variable
    var dataController : DataController {
        return (UIApplication.shared.delegate as! AppDelegate).dataController
    }
    var currentUser : UserProfil?
    var featuresPurshased = [Feature]()
    
    /*-------------------------------*/
        // MARK: - Public Fonctions
    /*-------------------------------*/
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        reloadFeaturesPurshased()
    }
    
    //MARK: IBActions
    @IBAction func settingButton(_ sender: UIButton) {
        performSegue(withIdentifier: "segueToSettings", sender: self)
    }
    @IBAction func ButtonActions(_ sender: UIButton) {
        if(sender.tag == 0) {
            disconnect()
        } else if sender.tag == 1 {
            print("Go setting")
        } else if sender.tag == 2 {
            performSegue(withIdentifier: "segueToStore", sender: self)
        }
    }
    
    // MARK: - Navigation
    func disconnect() {
        currentUser?.isStayConnect = false
        currentUser?.isConnected = false
        dataController.saveContext()
        
        performSegue(withIdentifier: "segueToConnectFromHome", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "segueToStore") {
            let destVC = segue.destination as! StoreViewController
            destVC.currentUser = self.currentUser
        } else if (segue.identifier == "segueToSettings") {
            let destVc = segue.destination as! SettingViewController
            destVc.currentUser = self.currentUser
        }
    }
    
    /*-------------------------------*/
        //MARK: - Private Fonctions
    /*-------------------------------*/
    private func setupView() {
    
        // init Delegate
        historyList.delegate = self
        historyList.dataSource = self
        
        // Observers
        let notificationNameBLEconnect = NSNotification.Name(rawValue : "BLEConnected")
        NotificationCenter.default.addObserver(self, selector: #selector(BluetoothIconSwitchConnected), name: notificationNameBLEconnect, object: nil)
        
        let notificationNameBLEdisconnect = NSNotification.Name(rawValue: "BLEdisconnected")
        NotificationCenter.default.addObserver(self, selector: #selector(BluetoothIconSwitchDisonnected), name: notificationNameBLEdisconnect, object: nil)
        
        
        // GraphicSetup
        let currentUserName = currentUser?.value(forKey: "username") as! String
        let balance = currentUser?.value(forKey: "balance") as! Double
        
        bluetoothButton.isEnabled = false 
        
        welcomeLabel.text = currentUserName
        balanceLabel.text = String(format: "%.2f" , balance) + "€"
        
        historyList.layer.cornerRadius = 8
    }
    
    @objc private func BluetoothIconSwitchConnected() {
        bluetoothButton.isEnabled = true
    }
    @objc private func BluetoothIconSwitchDisonnected() {
        bluetoothButton.isEnabled = false
    }
    private func reloadFeaturesPurshased() {
        featuresPurshased = currentUser?.feature?.allObjects as! [Feature]
    }
}

//MARK: - TableViewDelegate / DataSource
extension HomeViewController : UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if currentUser?.feature == nil {
            return 0
        } else {
            return (currentUser?.feature!.count)!
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomHomeCell", for: indexPath) as! CustomHomeTableViewCell
        
        setupCell(cell, indexPath: indexPath)
        return cell
     }
 
    private func setupCell(_ cell: CustomHomeTableViewCell, indexPath: IndexPath)
    {
        let feature = featuresPurshased[indexPath.row]
        cell.featureImage.image = UIImage(named: (feature.imageNamed))
        cell.featureTitle.text = featuresPurshased[indexPath.row].title
        cell.unitPrice.text = "\(String(describing: featuresPurshased[indexPath.row].unitPrice))€"
        cell.multiple.text = "x\(featuresPurshased[indexPath.row].multiplicator)"
        cell.totalPrice.text = "\(featuresPurshased[indexPath.row].unitPrice * Double(featuresPurshased[indexPath.row].multiplicator))€"
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if( editingStyle == .delete) {
            let feature = featuresPurshased[indexPath.row]
    
            feature.owner = nil
            dataController.managedObjectContext.delete(feature)
            historyList.deleteRows(at: [indexPath] , with: .left)
            dataController.saveContext()
            
            reloadFeaturesPurshased()
        }
    }
    
     // Override to support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
     }
}
