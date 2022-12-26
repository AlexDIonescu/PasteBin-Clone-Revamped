//
//  LoginViewController.swift
//  PasteBin Clone
//
//  Created by Alex Ionescu on 08.11.2022.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBOutlet weak var inputEmail: UITextField!
    
    @IBOutlet weak var inputPassword: UITextField!
    
    
    @IBAction func logInButtonTap(_ sender: UIButton) {
        
        logIn()
        
    }
    
    
    func logIn(){
        
        if inputEmail.text == "" || inputPassword.text == "" || inputEmail.text == "" && inputPassword.text == "" {
            let alert = UIAlertController(title: "Error", message: "Cannot sign in with empty credentials!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        } else {
            let safeEmail = inputEmail.text!.trimmingCharacters(in: .whitespaces)
            let safePassword = inputPassword.text!.trimmingCharacters(in: .whitespaces)
            Auth.auth().signIn(withEmail: safeEmail, password: safePassword) { authResult, error in
       
                if error != nil {
                    let alert = UIAlertController(title: nil, message: error?.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true)
                } else {
                    let currentUser = UserDefaults.standard
                    currentUser.set(true, forKey: "logged")
                        self.inputEmail.text = ""
                        self.inputPassword.text = ""
                    
                    let nav = self.storyboard?.instantiateViewController(withIdentifier: "mainNav") as! UITabBarController
                    self.present(nav, animated: false, completion: nil)
                    
                }
            }
        }
    }
}
