//
//  StoreViewController.swift
//  La Distrib'
//
//  Created by Daniel IKKA on 29/04/2018.
//  Copyright © 2018 Daniel IKKA. All rights reserved.
//

import UIKit
import CoreData

class StoreViewController: UIViewController {

    /*-------------------------------*/
    // MARK: - Public Attributs
    /*-------------------------------*/
    //MARK: Outlets
    @IBOutlet weak var storeList: UITableView!
    @IBOutlet weak var BalanceLabel: UILabel!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var totalPrice: UILabel!
    
    //MARK: Variable
    var dataController : DataController {
        return (UIApplication.shared.delegate as! AppDelegate).dataController
    }
    var totalpurchased = Double()
    var currentUser : UserProfil?
    var store : [FeatureStore] {
        return dataController.featuresStore
    }
    
    /*-------------------------------*/
    // MARK: - Public Fonctions
    /*-------------------------------*/
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    //MARK: IBActions
    @IBAction func didTapReturnButton(_ sender: UIButton) {
        performSegue(withIdentifier: "segueToHomeFromStore", sender: self)
    }
    @IBAction func buyButton(_ sender : UIButton) {
        if(totalpurchased > (currentUser?.balance)!) {
            alertNoMoney()
        } else {
            buyFeatures()
        }
    }
    
    /*-------------------------------*/
    //MARK: - Private Fonctions
    /*-------------------------------*/
    private func setupView() {
        
        // init Delegate
        storeList.dataSource = self
        storeList.delegate = self
        
        // init observer
        let notificationName = NSNotification.Name.NSManagedObjectContextDidSave
        NotificationCenter.default.addObserver(self, selector: #selector(updateTotalPurchased), name: notificationName, object: nil)
        
        // GraphicSetup
        resetMultiplicators()
        updateBalance()
        storeList.layer.cornerRadius = 8
    }
    private func buy(this feature: FeatureStore) {
        let newFeature = Feature(context: dataController.managedObjectContext)
        newFeature.setup(purchase: feature)
        
        currentUser?.addToFeature(newFeature)
        dataController.saveContext()
    }
    private func resetMultiplicators() {
        for feature in store {
            feature.multiplicator = 0
        }
        dataController.saveContext()
        storeList.reloadData()
    }
    private func updateBalance() {
        currentUser?.balance -= totalpurchased
        dataController.saveContext()
        BalanceLabel.text = String(format: "%.2f", (currentUser?.balance)!) + "€"
    }
    private func alertNoMoney() {
        let alerVC = UIAlertController(title: "Error", message: "Please Credit your account !", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (success) in
            self.resetMultiplicators()
        })
        alerVC.addAction(alertAction)
        present(alerVC, animated: true)
    }
    private func buyFeatures() {
        for feature in store {
            if feature.multiplicator > 0 {
                buy(this: feature)
            }
        }
        updateBalance()
        resetMultiplicators()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "segueToHomeFromStore") {
            let ControllerDest = segue.destination as! HomeViewController
            ControllerDest.currentUser = self.currentUser
        }
    }
}

//MARK: - DataSource and delegate
extension StoreViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return store.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoreCustomCell", for: indexPath) as! CustomStoreTableViewCell
        
        setupConfiguration(cell, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if(indexPath.row <= store.count) {
            return nil
        }
        return indexPath
    }
    
    private func setupConfiguration(_ cell: CustomStoreTableViewCell, indexPath: IndexPath) {
        cell.feature = store[indexPath.row]
        cell.setup()
        cell.numberTextField.delegate = self
    }
}

//MARK: - TextFieldDelegate
extension StoreViewController : UITextFieldDelegate {
    
    @objc private func updateTotalPurchased() {
        totalpurchased = 0.00
        for feature in store {
            totalpurchased += Double(feature.multiplicator) * feature.unitPrice
        }
        
        totalPrice.text! = String(format : "%.2f", totalpurchased) + "€"
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text!.removeAll()
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField.text?.isEmpty)! {
            textField.text! = "0"
        }
    }
}

