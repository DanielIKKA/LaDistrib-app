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
    var currentUser : UserProfil?
    var featuresPurshased = [Feature]()
    
    /*-------------------------------*/
        // MARK: - Public Fonctions
    /*-------------------------------*/
    override func viewDidLoad() {
        super.viewDidLoad()
        historyList.delegate = self
        historyList.dataSource = self
        
        historyList.layer.cornerRadius = 8
        
        welcomeLabel.text = "Welcome \(String(describing: currentUser!.username!))"
        balanceLabel.text = "\(String(describing: currentUser!.balance))€"
        
        featuresPurshased = (currentUser?.articles)!
    }
    
    //MARK: IBActions
    @IBAction func disconnect() {
        currentUser?.isStayConnect = false
        currentUser?.isConnected = false
        UserProfilPersistent.saveContext()
        
        performSegue(withIdentifier: "segueToConnectFromHome", sender: self)
    }
    
    public func saveConnectionStatus() {
        if(self.currentUser?.isStayConnect)! {
            return
        } else {
            self.currentUser?.isConnected = false
            self.currentUser?.isStayConnect = false
        }
    }
}

//MARK: - DataSource
extension HomeViewController : UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return featuresPurshased.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomHomeCell", for: indexPath) as! CustomTableViewCell
        
        setupCell(cell, forKey: featuresPurshased[indexPath.row].title, indexPath: indexPath)
        return cell
     }
 
    private func setupCell(_ cell: CustomTableViewCell, forKey: String, indexPath: IndexPath)
    {
        
        switch forKey {
        
        case "paper":
            cell.featureImage.image = featuresPurshased[indexPath.row].image
            cell.featureTitle.text = featuresPurshased[indexPath.row].title
            cell.unitPrice.text = String(describing: featuresPurshased[indexPath.row].unitPrice)
            break
        default:
            break
        }
        
        
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
