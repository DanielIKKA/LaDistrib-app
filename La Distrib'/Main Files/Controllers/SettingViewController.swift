//
//  SettingViewController.swift
//  La Distrib'
//
//  Created by Daniel IKKA on 08/05/2018.
//  Copyright © 2018 Daniel IKKA. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {

    @IBOutlet var buttons : [UIButton]!
    
    var currentUser : UserProfil!
    var dataController : DataController {
        return (UIApplication.shared.delegate as! AppDelegate).dataController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        for button in buttons {
            button.layer.cornerRadius = button.frame.height/5
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - IBAction
    @IBAction func button(_ sender: UIButton) {
        if sender.tag == 0 {
            credit()
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVc = segue.destination as! HomeViewController
        destVc.currentUser = currentUser
        dataController.saveContext()
    }
    
    private func credit() {
        
        
        let  alertVC = UIAlertController(title: "Credit", message: "Success", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default) { (success) in
            self.currentUser.balance += 10
            self.dataController.saveContext()
        }
        
        alertVC.addAction(alertAction)
        present(alertVC, animated: true)
    }

}
