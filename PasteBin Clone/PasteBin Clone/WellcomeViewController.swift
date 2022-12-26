//
//  WellcomeViewController.swift
//  PasteBin Clone
//
//  Created by Alex Ionescu on 09.11.2022.
//

import UIKit
import FirebaseAuth

class WellcomeViewController: UIViewController {

 
    override func viewDidLoad() {
        super.viewDidLoad()
        let currentUser = UserDefaults.standard.bool(forKey: "logged")
        if currentUser == true {
            let nav = storyboard?.instantiateViewController(withIdentifier: "mainNav") as! UITabBarController
            self.present(nav, animated: false, completion: nil)
                }
    }
    @IBAction func returnToWellcome(sender: UIStoryboardSegue){}
    
    @IBAction func signInButtonTap(_ sender: UIButton) {
        performSegue(withIdentifier: "signIn", sender: nil)
    }
    
    @IBAction func signUpButtonTap(_ sender: UIButton) {
        performSegue(withIdentifier: "signUp", sender: nil)

    }
    
}
