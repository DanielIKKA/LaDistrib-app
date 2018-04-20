//
//  ViewController.swift
//  La Distrib'
//
//  Created by Daniel IKKA on 12/04/2018.
//  Copyright © 2018 Daniel IKKA. All rights reserved.
//

import UIKit
import CoreData

// MARK: - UIViewController
class ConnectViewController : UIViewController {
    /*-------------------------------*/
        // MARK: - Public Attributs
    /*-------------------------------*/
    @IBOutlet weak var boxView: UIView!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var connectButton: UIButton!
    
    public var userProfils = [UserProfil]()
    
    /*-------------------------------*/
        // MARK: - Public Fonctions
    /*-------------------------------*/
    override func loadView() {
        super.loadView()
        setupGraphique()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Traking pour savoir si le bouton connect doit être activé ou pas
        loginTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        // Do request to fetch all existant user profils
        chargeExistentUserProfils(for: nil, whith: nil)
        print("there are \(userProfils.count) in this dataBase: ")
        for user in userProfils {
            print((user.username)!)
            print((user.password)!)
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*-------------------------------*/
        // MARK: - Private Méthodes
    /*-------------------------------*/
    private func setupGraphique() {
        // setup Login
        loginTextField.layer.borderWidth = 1
        loginTextField.layer.borderColor = #colorLiteral(red: 0.5369121432, green: 0.5369251966, blue: 0.5369181633, alpha: 1)
        loginTextField.layer.cornerRadius = loginTextField.frame.height/5
        loginTextField.delegate = self
        
        // setup Password
        passwordTextField.layer.borderWidth = 1
        passwordTextField.layer.borderColor = #colorLiteral(red: 0.5369121432, green: 0.5369251966, blue: 0.5369181633, alpha: 1)
        passwordTextField.layer.cornerRadius = passwordTextField.frame.height/5
        passwordTextField.delegate = self
        
        // setup GestureReconizer for the MainView
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapOnScreenToDismissKeyboard(_:)))
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func chargeExistentUserProfils(for userName: String?, whith password: String?) {
        let fetchRequest: NSFetchRequest<UserProfil> = UserProfil.fetchRequest()
        
        do {
            let users = try UserProfilPersistent.context.fetch(fetchRequest)
            self.userProfils.removeAll()
            self.userProfils = users
        } catch {}
    }
    
    @objc private func didTapOnScreenToDismissKeyboard(_ sender: UITapGestureRecognizer){
        // Dismiss Keyboard
        if(loginTextField.isFirstResponder) {
            loginTextField.resignFirstResponder()
        } else if(passwordTextField.isFirstResponder) {
            passwordTextField.resignFirstResponder()
        }
        
        // reaganisation of view
        UIView.animate(withDuration: 0.3) {
            self.boxView.transform = .identity
        }
    }
}

// MARK: - UITextFieldDelegate
extension ConnectViewController : UITextFieldDelegate {
    
    /*-------------------------------*/
        //MARK: - Public Functions
    /*-------------------------------*/
    public func textFieldDidBeginEditing(_ textField: UITextField) { // became first responder
        let translationY: CGFloat = -40
        
        deplacementY(textField: textField, translationY: translationY)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        // Control du bouton connect
        if(ButtonShouldActivate()) {
            connectButton.isEnabled = true
        } else {
            connectButton.isEnabled = false
        }
        
        // control de la police d'écriture
        if(textField.text?.isEmpty)! {
            textField.font = UIFont(name: "RobotoCondensed-LightItalic", size: 15.0)
        } else {
            textField.font = UIFont(name: "Roboto-Medium", size: 15.0)
        }
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag+1
        // Try to find next responder
        let nextResponder = textField.superview?.viewWithTag(nextTag) as UIResponder!
        
        if(nextResponder != nil) {
            nextResponder?.becomeFirstResponder()
            return false
        } else {
            textField.resignFirstResponder()
            UIView.animate(withDuration: 0.3) {
                self.boxView.transform = .identity
            }
            return true
        }
    }
    /*-------------------------------*/
        //MARK: - Private Functions
    /*-------------------------------*/
    private func deplacementY(textField: UITextField ,translationY: CGFloat) {
        if(textField == loginTextField) {
            UIView.animate(withDuration: 0.3, animations: {
                self.boxView.transform = CGAffineTransform(translationX: 0, y: translationY)
            })
        } else if (textField == passwordTextField) {
            UIView.animate(withDuration: 0.3, animations: {
                self.boxView.transform = CGAffineTransform(translationX: 0, y: translationY - self.loginTextField.bounds.height)
            })
        }
    }
    
    private func ButtonShouldActivate() -> Bool {
        if((!(self.loginTextField.text?.isEmpty)!) && (!(self.passwordTextField.text?.isEmpty)!)) {
            return true
        }
        return false
    }
}
