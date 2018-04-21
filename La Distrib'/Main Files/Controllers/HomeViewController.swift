//
//  HomeViewController.swift
//  La Distrib'
//
//  Created by Daniel IKKA on 13/04/2018.
//  Copyright © 2018 Daniel IKKA. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var WelcomeLabel: UILabel!
    @IBOutlet weak var BalanceLabel: UILabel!
    
    var currentUser : UserProfil?
    
    override func loadView() {
        WelcomeLabel.text = "Bonjour \(String(describing: currentUser?.username!))"
        BalanceLabel.text = "Crédit: \(String(describing: currentUser?.balance))€"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
