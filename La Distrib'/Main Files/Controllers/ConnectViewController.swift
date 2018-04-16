//
//  ViewController.swift
//  La Distrib'
//
//  Created by Daniel IKKA on 12/04/2018.
//  Copyright © 2018 Daniel IKKA. All rights reserved.
//

import UIKit

// MARK: - UIViewController
class ConnectViewController : UIViewController {

    // MARK: - Public Attributs
    @IBOutlet weak var boxView: UIView!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var connectButton: UIButton!
    
    
    // MARK: - Public Fonctions
    override func loadView() {
        super.loadView()
        setupGraphique()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Traking pour savoir si le bouton connect doit être activé ou pas
        loginTextField.addTarget(self, action: #selector(textFielddidChange(_:)), for: .editingChanged)
        PasswordTextField.addTarget(self, action: #selector(textFielddidChange(_:)), for: .editingChanged)
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Private Méthodes
    private func setupGraphique() {
        // setup Login
        loginTextField.layer.borderWidth = 1
        loginTextField.layer.borderColor = #colorLiteral(red: 0.5369121432, green: 0.5369251966, blue: 0.5369181633, alpha: 1)
        loginTextField.layer.cornerRadius = loginTextField.frame.height/5
        loginTextField.delegate = self
        
        // setup Password
        PasswordTextField.layer.borderWidth = 1
        PasswordTextField.layer.borderColor = #colorLiteral(red: 0.5369121432, green: 0.5369251966, blue: 0.5369181633, alpha: 1)
        PasswordTextField.layer.cornerRadius = PasswordTextField.frame.height/5
        PasswordTextField.delegate = self
    }
}

// MARK: - UITextFieldDelegate
extension ConnectViewController : UITextFieldDelegate {
    
    //MARK: - Public Functions
   
    public func textFieldDidBeginEditing(_ textField: UITextField) { // became first responder
        let translationY: CGFloat = -40
        
        deplacementY(textField: textField, translationY: translationY)
    }
    
    
    @objc func textFielddidChange(_ textField: UITextField) {
        if(ButtonShouldActivate()) {
            connectButton.isEnabled = true
        } else {
            connectButton.isEnabled = false
        }
    }
    
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        if((loginTextField.isEditing) || (PasswordTextField.isEditing)) {
            self.boxView.transform = .identity
        }
    }
    
    //MARK: - Private Functions
    
    private func deplacementY(textField: UITextField ,translationY: CGFloat) {
        if(textField == loginTextField) {
            UIView.animate(withDuration: 0.3, animations: {
                self.boxView.transform = CGAffineTransform(translationX: 0, y: translationY)
            })
        } else if (textField == PasswordTextField) {
            UIView.animate(withDuration: 0.3, animations: {
                self.boxView.transform = CGAffineTransform(translationX: 0, y: translationY - self.loginTextField.bounds.height)
            })
        }
    }
    
    
    private func ButtonShouldActivate() -> Bool {
        if((!(self.loginTextField.text?.isEmpty)!) && (!(self.PasswordTextField.text?.isEmpty)!)) {
            return true
        }
        return false
    }
}