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

    /*-------------------------------*/
        //MARK: - Public Methodes
    /*-------------------------------*/
    override func loadView() {
        super.loadView()
        usernameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        // Control du bouton connect
//        if(ButtonShouldActivate()) {
//            connectButton.isEnabled = true
//        } else {
//            connectButton.isEnabled = false
//        }

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

//    private func ButtonShouldActivate() -> Bool {
//        if((!(self.loginTextField.text?.isEmpty)!) && (!(self.PasswordTextField.text?.isEmpty)!)) {
//            return true
//        }
//        return false
//    }
}


