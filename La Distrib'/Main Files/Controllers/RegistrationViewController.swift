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
    @IBOutlet weak var confirmTextField: CustomTextField!
    
    //MARK: Variables
    var userExist = [UserProfil]()
    
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
        usernameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingDidEnd)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingDidEnd)
        confirmTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingDidEnd)
        emailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingDidEnd)
        
        displayUserArray()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    /*-------------------------------*/
        //MARK: IBActions
    /*-------------------------------*/
    @IBAction func registrate() {
        if(passwordIsCorrect() && !userIsAlreadyRegistered()){
            // rentrer les données saisie dans l'entité
            newUser()
            
            // savegarde l'entité
            UserProfilPersistent.saveContext()
            // Actionner la segue vers connectView
            performSegue(withIdentifier: "RegistrationToConnecSegue", sender: nil)
        } else if (!passwordIsCorrect()) {
            alertPasswordNotCorrect()
        } else if (userIsAlreadyRegistered()) {
            alerUserIsAlreadyResgistered()
        }
    }
    
    /*-------------------------------*/
        //MARK: - Private Methodes
    /*-------------------------------*/
    private func setup() {
        // initailisation delegate
        usernameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmTextField.delegate = self
        
        // initialisation gestureRecognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapOnScreenToDismissKeyboard(_:)))
        self.view!.addGestureRecognizer(tapGesture)
    }
    
    private func newUser() {
        // init du context utilisé
        let newUserProfil = UserProfil(context: UserProfilPersistent.context)
        
        newUserProfil.username = usernameTextField.text!
        newUserProfil.email = emailTextField.text!
        newUserProfil.password = passwordTextField.text!
        newUserProfil.isConnected = false
        newUserProfil.isStayConnect = false
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
    
    //MARK: Check if registration is correct
    private func passwordIsCorrect() -> Bool {
        if(passwordTextField.text! == confirmTextField.text!){
            return true
        } else {
            return false
        }
    }
    private func userIsAlreadyRegistered() -> Bool {
        // try to find username
        let newUsername = self.usernameTextField.text!
        let newUserEmail = self.emailTextField.text!
        
        for user in userExist {
            if((user.username == newUsername) || (user.email == newUserEmail)) {
                return true
            }
        }
        return false
    }
    
    //MARK: alert message
    private func alertPasswordNotCorrect() {
        let alertMessage = UIAlertController(title: "Erreur Registration", message: "password is not the same", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Cancel", style: .cancel) { (success) in
            self.passwordTextField.text?.removeAll()
            self.confirmTextField.text?.removeAll()
            self.registrateButton.isEnabled = false
            self.passwordTextField.becomeFirstResponder()
        }
        
        alertMessage.addAction(alertAction)
        
        present(alertMessage, animated: true)
    }
    private func alerUserIsAlreadyResgistered() {
        let alertMessage = UIAlertController(title: "Erreur Registration", message: "This username or email adress is already registered !", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Cancel", style: .cancel) { (success) in
            self.registrateButton.isEnabled = false
            self.usernameTextField.becomeFirstResponder()
        }
        
        alertMessage.addAction(alertAction)
        
        present(alertMessage, animated: true)
    }
    
    /*-------------------------------*/
        //MARK: - Private Debug
    /*-------------------------------*/
    private func displayUserArray() {
        for user in userExist {
            print("\(user) + \n")
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
        } else if (textField == passwordTextField || textField == confirmTextField) {
            UIView.animate(withDuration: 0.3, animations: {
                self.allFeaturesView.transform = CGAffineTransform(translationX: 0, y: translationY - 2*textField.bounds.height)
            })
        }
    }

    private func ButtonShouldActivate() -> Bool {
        if((!(self.usernameTextField.text?.isEmpty)!) && (!(self.passwordTextField.text?.isEmpty)!) && (!(self.emailTextField.text?.isEmpty)!)) && (!(self.confirmTextField.text?.isEmpty)!) {
            return true
        }
        return false
    }
}


