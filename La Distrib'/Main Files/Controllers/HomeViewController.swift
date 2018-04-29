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
    @IBAction func disconnect() {
        currentUser?.isStayConnect = false
        currentUser?.isConnected = false
        dataController.saveContext()
        
        performSegue(withIdentifier: "segueToConnectFromHome", sender: self)
    }
    
    /*-------------------------------*/
        //MARK: - Private Fonctions
    /*-------------------------------*/
    private func setupView() {
    
        // init Delegate
        historyList.delegate = self
        historyList.dataSource = self
        
        // GraphicSetup
        let currentUserName = currentUser?.value(forKey: "username") as! String
        let balance = currentUser?.value(forKey: "balance") as! Double
        
        welcomeLabel.text = currentUserName
        balanceLabel.text = "\(String(describing: balance))€"
        
        historyList.layer.cornerRadius = 8
        
    }
    private func reloadFeaturesPurshased() {
        featuresPurshased = currentUser?.feature?.allObjects as! [Feature]
    }
}

//MARK: - DataSource
extension HomeViewController : UITableViewDataSource {

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
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomHomeCell", for: indexPath) as! CustomTableViewCell
        
        setupCell(cell, indexPath: indexPath)
        return cell
     }
 
    private func setupCell(_ cell: CustomTableViewCell, indexPath: IndexPath)
    {
        let feature = featuresPurshased[indexPath.row]
        cell.featureImage.image = UIImage(named: (feature.imageNamed))
        cell.featureTitle.text = featuresPurshased[indexPath.row].title
        cell.unitPrice.text = String(describing: featuresPurshased[indexPath.row].unitPrice)
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
extension HomeViewController : UITableViewDelegate {
    
}
