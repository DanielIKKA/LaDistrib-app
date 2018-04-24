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
    //MARK: Outlets
    @IBOutlet weak var boxView: UIView!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var connectButton: UIButton!
    
    //MARK: Variables
    public var userProfils = [UserProfil]()
    
    /*-------------------------------*/
        // MARK: - Public Fonctions
    /*-------------------------------*/
    override func loadView() {
        super.loadView()
        setup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Traking pour savoir si le bouton connect doit être activé ou pas
        loginTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        // Do request to fetch all existant user profils
        chargeUserProfilFromDataBase()
        displayDataBase()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        ConnectCurrentUserIfExist()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "segueToRegistration":
            let nextViewController = segue.destination as! RegistrationViewController
            nextViewController.userExist = userProfils
            break
        
        case "segueToHome":
            let nextViewController = segue.destination as! HomeViewController
            let currentUser:  UserProfil? = findUserConnected()
            if(currentUser == nil) {
                print("ERREUR")
            } else {
                //currentUser?.articles.append(Feature(imageNamed: "paperIconSolo", title: "paper", price: 0.10, multiple: 3))
                nextViewController.currentUser = currentUser
            }
            break
        
        default:
            break
        }
    }
    
    //MARK: IBActions
    @IBAction func connection() {
        if(isAlreadyRegistered() && isGoodPassword()) {
            let currentUser : UserProfil? = findCurrentUser(named: loginTextField.text!)
            
            
            connect(currentUser: currentUser!)
            alertStayConnected(currentUser!)
        } else {
            alertErrorConnection()
        }
    }
    
    /*-------------------------------*/
        // MARK: - Private Méthodes
    /*-------------------------------*/
    private func setup() {
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
    
    private func chargeUserProfilFromDataBase() {
        let fetchRequest: NSFetchRequest<UserProfil> = UserProfil.fetchRequest()
        
        do {
            let users = try UserProfilPersistent.context.fetch(fetchRequest)
            self.userProfils.removeAll()
            self.userProfils = users
        } catch {}
    }
    
    private func ConnectCurrentUserIfExist() {
        for user in userProfils {
            if user.isStayConnect {
                performSegue(withIdentifier: "segueToHome", sender: self)
            } else {
                // disconnect all
                for user in self.userProfils {
                    user.isConnected = false
                    user.isStayConnect = false
                }
            }
        }
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
    private func connect(currentUser : UserProfil) {
        // disconnect all
        for user in self.userProfils {
            user.isConnected = false
            user.isStayConnect = false
        }
        
        // connect current user
        currentUser.isConnected = true
    }
    
    //MARK: Checks
    private func isAlreadyRegistered() -> Bool {
        for user in userProfils {
            if((user.email)! != loginTextField.text! || (user.username)! != loginTextField.text!) {
                return true
            }
        }
        
        return false
    }
    private func isGoodPassword() -> Bool {
         // Find the good user
        let userFind : UserProfil? = findCurrentUser(named: loginTextField.text!)
        
        // check if password is correct
        if(userFind != nil && userFind?.password == passwordTextField.text!) {
            return true
        }
        
        return false
    }
    private func findCurrentUser(named: String) -> UserProfil? {
        for user in userProfils {
            if (user.username == loginTextField.text! || user.email == loginTextField.text!) {
                return user
            }
        }
        return nil
    }
    private func findUserConnected() -> UserProfil? {
        for user in userProfils {
            if(user.isConnected){
                return user
            }
        }
        return nil
    }
    
    //MARK: Alert
    private func alertErrorConnection() {
        let alertMessage = UIAlertController(title: "Erreur Connection", message: "Username or password isn't correct ! Please try again.", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Cancel", style: .cancel) { (success) in
            self.passwordTextField.text?.removeAll()
            self.connectButton.isEnabled = false
            self.loginTextField.becomeFirstResponder()
        }
        
        alertMessage.addAction(alertAction)
        
        present(alertMessage, animated: true)
    }
    private func alertStayConnected(_ user: UserProfil) {
        let alertMessage = UIAlertController(title: nil, message: "Do you want to stay connected ?", preferredStyle: .actionSheet)
        let actionStayConnected = UIAlertAction(title: "Yes", style: .default) { (success) in
            user.isStayConnect = true
            UserProfilPersistent.saveContext()
            self.performSegue(withIdentifier: "segueToHome", sender: self)
        }
        let actionNo = UIAlertAction(title: "No", style: .destructive) { (success) in
            user.isStayConnect = false
            UserProfilPersistent.saveContext()
            self.performSegue(withIdentifier: "segueToHome", sender: self)
        }
        
        alertMessage.addAction(actionStayConnected)
        alertMessage.addAction(actionNo)
        
        present(alertMessage, animated: true, completion: nil)
    }
    
    /*-------------------------------*/
        //MARK: - Private Debug
    /*-------------------------------*/
    private func displayDataBase() {
        print("il y a \(userProfils.count)\n")
        for user in userProfils {
            print("\(user.username!) , \(user.isStayConnect)\n")
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
