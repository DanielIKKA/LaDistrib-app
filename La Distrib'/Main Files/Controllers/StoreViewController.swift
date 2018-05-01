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

    //MARK: Variable
    var dataController : DataController {
        return (UIApplication.shared.delegate as! AppDelegate).dataController
    }
    var currentUser : UserProfil?
    let featuresArray : [String] = [FeatureConstants.Key.kPaperSingle , FeatureConstants.Key.kPaperMultiple, FeatureConstants.Key.kPen, FeatureConstants.Key.kPencil]
    
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
    
    /*-------------------------------*/
    //MARK: - Private Fonctions
    /*-------------------------------*/
    private func setupView() {
        
        // init Delegate
        storeList.dataSource = self
        storeList.delegate = self
        
        // GraphicSetup
        storeList.layer.cornerRadius = 8
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "segueToHomeFromStore") {
            let ControllerDest = segue.destination as! HomeViewController
            ControllerDest.currentUser = self.currentUser
        }
    }
}

//MARK: - DataSource
extension StoreViewController : UITableViewDataSource {
    
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
    
    public func setupConfiguration(_ cell: CustomStoreTableViewCell, indexPath: IndexPath) {
        
        let key = featuresArray[indexPath.row]
        
        switch key {
        case FeatureConstants.Key.kPaperSingle:
            cell.featureImage.image = UIImage(named: FeatureConstants.ImageName.kPaperSingle)
            cell.featureTitle.text = FeatureConstants.Title.kPaper
            cell.unitPrice.text = "\(String(describing: FeatureConstants.UnitPrice.kPaperPrice))€"
            break
            
        case FeatureConstants.Key.kPaperMultiple:
            cell.featureImage.image = UIImage(named: FeatureConstants.ImageName.kPaperMultiple)
            cell.featureTitle.text = FeatureConstants.Title.kPaper
            cell.unitPrice.text = "\(String(describing: FeatureConstants.UnitPrice.kPaperPrice))€"
            break
            
        case FeatureConstants.Key.kPencil:
            cell.featureImage.image = UIImage(named: FeatureConstants.ImageName.kPencil)
            cell.featureTitle.text = FeatureConstants.Title.kPencil
            cell.unitPrice.text = "\(String(describing: FeatureConstants.UnitPrice.kPencilPrice))€"
            break
            
        case FeatureConstants.Key.kPen:
            break
        default:
            break
        }
        cell.numberTextField.text = String(0)
    }
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}

//MARK: - TableViewDelegate
extension StoreViewController : UITableViewDelegate {
    
}
