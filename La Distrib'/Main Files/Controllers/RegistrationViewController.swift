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
    @IBOutlet weak var returnButton: UIButton!
    @IBOutlet weak var confirmTextField: CustomTextField!
    @IBOutlet weak var titleLabel: UILabel!
    
    //MARK: Variables
    var dataController : DataController {
        return (UIApplication.shared.delegate as! AppDelegate).dataController
    }
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
            // creer l'entity avec les données saisie dans l'entité
            newUser()
            
            // savegarde l'entité
            
            
            // Actionner la segue vers connectView
            performSegue(withIdentifier: "segueToConnect", sender: nil)
        } else if (!passwordIsCorrect()) {
            alertPasswordNotCorrect()
        } else if (userIsAlreadyRegistered()) {
            alerUserIsAlreadyResgistered()
        }
    }
    @IBAction func returnToConnectView() {
        performSegue(withIdentifier: "segueToConnect", sender: self)
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
        // init de l'objet dans le manageObjectContext
        let newUserProfil = UserProfil(context: dataController.managedObjectContext)
        
        newUserProfil.username = usernameTextField.text!
        newUserProfil.email = emailTextField.text!
        newUserProfil.password = passwordTextField.text!
        
        newUserProfil.isConnected = false
        newUserProfil.isStayConnect = false
        newUserProfil.isAdmin = false

        newUserProfil.balance = 10
        
    }
    
    @objc private func didTapOnScreenToDismissKeyboard(_ sender: UITapGestureRecognizer){
        // Dismiss Keyboard
        if(usernameTextField.isFirstResponder) {
            usernameTextField.resignFirstResponder()
        } else if(passwordTextField.isFirstResponder) {
            passwordTextField.resignFirstResponder()
        } else if(emailTextField.isFirstResponder) {
            emailTextField.resignFirstResponder()
        } else if(confirmTextField.isFirstResponder) {
            confirmTextField.resignFirstResponder()
        }
        
        // reaganisation of view
        UIView.animate(withDuration: 0.3) {
            self.allFeaturesView.transform = .identity
            self.titleLabel.isHidden = false
            self.returnButton.isHidden = false
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
        let alertMessage = UIAlertController(title: "Erreur Registration", message: "password is not the same ! Please try again.", preferredStyle: .alert)
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
        let alertMessage = UIAlertController(title: "Erreur Registration", message: "This username or email adress is already registered ! Please try again.", preferredStyle: .alert)
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
        print(userExist.count)
        
        for user in userExist {
            print("\(user) \n")
        }
    }
}

extension RegistrationViewController : UITextFieldDelegate {

    /*-------------------------------*/
        //MARK: - Public Functions
    /*-------------------------------*/
    public func textFieldDidBeginEditing(_ textField: UITextField) { // became first responder
        let translationY: CGFloat = -40
        
        returnButton.isHidden = true
        titleLabel.isHidden = true
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
        let nextResponder = textField.superview?.superview?.viewWithTag(nextTag)
        
        if(nextResponder != nil) {
            nextResponder?.becomeFirstResponder()
            return false
        } else {
            textField.resignFirstResponder()
            UIView.animate(withDuration: 0.3) {
                self.allFeaturesView.transform = .identity
                self.returnButton.isHidden = false
                self.titleLabel.isHidden = false
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


