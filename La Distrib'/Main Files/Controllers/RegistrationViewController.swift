//
//  RegistrationViewController.swift
//  La Distrib'
//
//  Created by Daniel IKKA on 17/04/2018.
//  Copyright © 2018 Daniel IKKA. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController {
    /*-------------------------------*/
            //MARK: - Attributs
    /*-------------------------------*/
    //MARK: Outlets
    @IBOutlet weak var allFeaturesView: UIStackView!
    @IBOutlet weak var usernameTextField: CustomTextField!
    @IBOutlet weak var emailTextField: CustomTextField!
    @IBOutlet weak var passwordTextField: CustomTextField!
    @IBOutlet weak var registrateButton: UIButton!
    
    /*-------------------------------*/
        //MARK: - Public Methodes
    /*-------------------------------*/
    override func loadView() {
        super.loadView()
        setup()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //traking for registrateButton
        usernameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /*-------------------------------*/
        //MARK: - Private Methodes
    /*-------------------------------*/
    private func setup() {
        // initailisation delegate
        usernameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        // initialisation gestureRecognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapOnScreenToDismissKeyboard(_:)))
        self.view!.addGestureRecognizer(tapGesture)
    }
    
    @objc private func didTapOnScreenToDismissKeyboard(_ sender: UITapGestureRecognizer){
        // Dismiss Keyboard
        if(usernameTextField.isFirstResponder) {
            usernameTextField.resignFirstResponder()
        } else if(passwordTextField.isFirstResponder) {
            passwordTextField.resignFirstResponder()
        } else if(emailTextField.isFirstResponder) {
            emailTextField.resignFirstResponder()
        }
        
        // reaganisation of view
        UIView.animate(withDuration: 0.3) {
            self.allFeaturesView.transform = .identity
        }
    }
}

extension RegistrationViewController : UITextFieldDelegate {

    /*-------------------------------*/
        //MARK: - Public Functions
    /*-------------------------------*/
    public func textFieldDidBeginEditing(_ textField: UITextField) { // became first responder
        let translationY: CGFloat = -40
        
        deplacementY(textField: textField, translationY: translationY)
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        // Control du bouton registrate
        if(ButtonShouldActivate()) {
            registrateButton.isEnabled = true
        } else {
            registrateButton.isEnabled = false
        }

        //control de la police d'écriture
        if(textField.text?.isEmpty)! {
            textField.font = UIFont(name: "RobotoCondensed-Italic", size: 15.0)
        } else {
            textField.font = UIFont(name: "Roboto-Medium", size: 15.0)
        }
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag+1
        // Try to find next responder
        let nextResponder = textField.superview?.superview?.viewWithTag(nextTag) as UIResponder!

        if(nextResponder != nil) {
            nextResponder?.becomeFirstResponder()
            return false
        } else {
            textField.resignFirstResponder()
            UIView.animate(withDuration: 0.3) {
                self.allFeaturesView.transform = .identity
            }
            return true
        }
    }

    /*-------------------------------*/
        //MARK: - Private Functions
    /*-------------------------------*/
    private func deplacementY(textField: UITextField ,translationY: CGFloat) {
        if(textField == usernameTextField) {
            UIView.animate(withDuration: 0.3, animations: {
                self.allFeaturesView.transform = CGAffineTransform(translationX: 0, y: translationY)
            })
        } else if (textField == emailTextField) {
            UIView.animate(withDuration: 0.3, animations: {
                self.allFeaturesView.transform = CGAffineTransform(translationX: 0, y: translationY - textField.bounds.height)
            })
        } else if (textField == passwordTextField) {
            UIView.animate(withDuration: 0.3, animations: {
                self.allFeaturesView.transform = CGAffineTransform(translationX: 0, y: translationY - 2*textField.bounds.height)
            })
        }
    }

    private func ButtonShouldActivate() -> Bool {
        if((!(self.usernameTextField.text?.isEmpty)!) && (!(self.passwordTextField.text?.isEmpty)!) && (!(self.emailTextField.text?.isEmpty)!)) {
            return true
        }
        return false
    }
}


