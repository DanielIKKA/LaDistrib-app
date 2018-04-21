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
    @IBOutlet weak var WelcomeLabel: UILabel!
    @IBOutlet weak var BalanceLabel: UILabel!
    
    //MARK: Variable
    var currentUser : UserProfil?
    
    /*-------------------------------*/
        // MARK: - Public Fonctions
    /*-------------------------------*/
    override func viewDidLoad() {
        super.viewDidLoad()
        WelcomeLabel.text = "Welcome \(String(describing: currentUser!.username!))"
        BalanceLabel.text = "Balance: \(String(describing: currentUser!.balance))€"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: IBActions
    @IBAction func diconnect() {
        currentUser?.isStayConnect = false
        currentUser?.isConnected = false
        UserProfilPersistent.saveContext()
        
        performSegue(withIdentifier: "segueToConnectFromHome", sender: self)
    
    }

    
    
    
}
