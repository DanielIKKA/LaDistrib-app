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
    let featuresArray : [String] = [FeatureConstants.Key.kPaperSingle , FeatureConstants.Key.kPencil, FeatureConstants.Key.kBlackPen, FeatureConstants.Key.kBluePen, FeatureConstants.Key.kRedPen, FeatureConstants.Key.kGreenPen, FeatureConstants.Key.kInk]
    
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
    @IBAction func buyAction(_ sender : UIButton) {
        if(totalpurchased > (currentUser?.balance)!) {
            let alerVC = UIAlertController(title: "Error", message: "Please Credit your account !", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (success) in
                for cell in self.storeList.visibleCells as! [CustomStoreTableViewCell] {
                    cell.numberTextField.text = "0"
                    self.totalPrice.text! = "0.00€"
                }
            })
            
            alerVC.addAction(alertAction)
            present(alerVC, animated: true)
        } else {
            buyFeatures()
            updateBalance()
        }
    }
    
    /*-------------------------------*/
    //MARK: - Private Fonctions
    /*-------------------------------*/
    private func setupView() {
        
        // init Delegate
        storeList.dataSource = self
        storeList.delegate = self
        
        // GraphicSetup
        totalPrice.text = "0.00€"
        BalanceLabel.text = (currentUser?.balance.description)! + "€"
        storeList.layer.cornerRadius = 8
        
    }
    private func buyFeatures() {
        var cpt = Int()
        for cell in storeList.visibleCells as! [CustomStoreTableViewCell] {
            if Double(cell.numberTextField.text!) != 0 {
                let feature = Feature(context: dataController.managedObjectContext)
                feature.setupConfiguration(forKey: featuresArray[cpt], numberOfpurshased: Int16(cell.numberTextField.text!))
                currentUser?.addToFeature(feature)
            }
            cpt += 1
        }
    }


    private func updateBalance() {
        currentUser?.balance -= totalpurchased
        dataController.saveContext()
        BalanceLabel.text = (currentUser?.balance.description)! + "€"
        
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
        return featuresArray.count
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
        if(indexPath.row <= featuresArray.count) {
            return nil
        }
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        let cell = tableView.cellForRow(at: indexPath!) as! CustomStoreTableViewCell
        let multCell = Double(cell.numberTextField.text!)
        let total = multCell! * cell.price
        
        totalPrice.text! = total.description
    }
    
    private func setupConfiguration(_ cell: CustomStoreTableViewCell, indexPath: IndexPath) {
        
        let key = featuresArray[indexPath.row]
        
        switch key {
        case FeatureConstants.Key.kPaperSingle:
            cell.featureImage.image = UIImage(named: FeatureConstants.ImageName.kPaperSingle)
            cell.featureTitle.text = FeatureConstants.Title.kPaper
            cell.price = FeatureConstants.UnitPrice.kPaperPrice
            cell.unitPrice.text = "\(String(describing: cell.price))€"
            break
            
        case FeatureConstants.Key.kPaperMultiple:
            cell.featureImage.image = UIImage(named: FeatureConstants.ImageName.kPaperMultiple)
            cell.featureTitle.text = FeatureConstants.Title.kPaper
            cell.price = FeatureConstants.UnitPrice.kPaperPrice
            cell.unitPrice.text = "\(String(describing: cell.price))€"
            break
            
        case FeatureConstants.Key.kPencil:
            cell.featureImage.image = UIImage(named: FeatureConstants.ImageName.kPencil)
            cell.featureTitle.text = FeatureConstants.Title.kPencil
            cell.price = FeatureConstants.UnitPrice.kPencilPrice
            cell.unitPrice.text = "\(String(describing: cell.price))€"
            break
            
        case FeatureConstants.Key.kRedPen, FeatureConstants.Key.kBluePen, FeatureConstants.Key.kBlackPen, FeatureConstants.Key.kGreenPen:
            cell.price = FeatureConstants.UnitPrice.kPenPrice
            cell.unitPrice.text = "\(String(describing: cell.price))€"
            if(key == FeatureConstants.Key.kGreenPen){
                cell.featureTitle.text = FeatureConstants.Title.kGreenPen
                cell.featureImage.image = UIImage(named:FeatureConstants.ImageName.kGreenPen)
            } else if (key == FeatureConstants.Key.kBluePen) {
                cell.featureTitle.text = FeatureConstants.Title.kBluePen
                cell.featureImage.image = UIImage(named:FeatureConstants.ImageName.kBluePen)
            } else if(key == FeatureConstants.Key.kRedPen) {
                cell.featureTitle.text = FeatureConstants.Title.kRedPen
                cell.featureImage.image = UIImage(named: FeatureConstants.ImageName.kRedPen)
            } else if(key == FeatureConstants.Key.kBlackPen) {
                cell.featureTitle.text = FeatureConstants.Title.kBlackPen
                cell.featureImage.image = UIImage(named:FeatureConstants.ImageName.kBlackPen)
            }
            break
        case FeatureConstants.Key.kInk :
            cell.featureImage.image = UIImage(named:FeatureConstants.ImageName.kInk)
            cell.featureTitle.text = FeatureConstants.Title.kInk
            cell.price = FeatureConstants.UnitPrice.kInkPrice
            cell.unitPrice.text = "\(String(describing: cell.price))€"
            break
        default:
            break
        }
        cell.numberTextField.text = String(0)
        cell.numberTextField.addTarget(self, action: #selector(didChange(_:)), for: UIControlEvents.allEvents)
        cell.numberTextField.delegate = self 
        
        cell.totalpurchased = self.totalpurchased
        cell.selectionStyle = .none
        
    }
}

//MARK: - TableViewDelegate
extension StoreViewController : UITextFieldDelegate {
    @objc public func didChange(_ sender: UITextField) {
        totalpurchased = Double()
        
        for cell in storeList.visibleCells as! [CustomStoreTableViewCell] {
            var totalCell = Double()
            if !(cell.numberTextField.text?.isEmpty)! {
                totalCell = cell.price * Double(cell.numberTextField.text!)!
            }
            
            totalpurchased += totalCell
        }
        totalPrice.text = "\(totalpurchased)€"
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField.text?.isEmpty)! {
            textField.text! = "0"
        }
    }
}

