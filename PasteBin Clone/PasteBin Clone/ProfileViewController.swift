//
//  ProfileViewController.swift
//  PasteBin Clone
//
//  Created by Alex Ionescu on 10.11.2022.
//

import UIKit
import FirebaseAuth
import FirebaseStorage

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = Auth.auth().currentUser?.email {
            currentUserLabel.text = user
        }
        profilePicture.image = UIImage(systemName: "person.circle")
//        profilePicture.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectProfilePicture)))
//        profilePicture.isUserInteractionEnabled = true
//        picker.delegate = self
//
//        if let profile = UserDefaults.standard.data(forKey: "profile") {
//            profilePicture.image = UIImage(data: profile)
////            profilePicture.layer.masksToBounds = false
////            profilePicture.layer.cornerRadius = profilePicture.frame.height/2
////            profilePicture.clipsToBounds = true
//        }
        
    }
    
    let picker = UIImagePickerController()
    
    @IBOutlet weak var profilePicture: UIImageView!
    
    @IBOutlet weak var currentUserLabel: UILabel!
    
    
    @objc func selectProfilePicture(){
    
        present(picker, animated: true)
    }
    
    
    
    @IBAction func signOutButtonTap(_ sender: UIBarButtonItem) {

        let mainAlert = UIAlertController(title: nil, message: "Sign Out ?", preferredStyle: .alert)
        mainAlert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { action in
            do{
                try Auth.auth().signOut()
                let currentUser = UserDefaults.standard
                currentUser.set(false, forKey: "logged")
                self.performSegue(withIdentifier: "toWellcome", sender: self)
            } catch {
                let alert = UIAlertController(title: nil, message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
            }
        }))
        let profile = UserDefaults.standard
        profile.setValue(nil, forKey: "profile")
        mainAlert.addAction(UIAlertAction(title: "No", style: .default))
        present(mainAlert, animated: true)
    }
    
    
}

extension ProfileViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
}
