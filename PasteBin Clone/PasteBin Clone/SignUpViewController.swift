//
//  SignUpViewController.swift
//  PasteBin Clone
//
//  Created by Alex Ionescu on 08.11.2022.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class SignUpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        inputEmail.delegate = self
        inputName.delegate = self
        inputPassword.delegate = self
        inputEmail.spellCheckingType = .no
        inputEmail.autocorrectionType = .no
        inputPassword.spellCheckingType = .no
        inputPassword.autocorrectionType = .no
        inputName.spellCheckingType = .no
        inputName.autocorrectionType = .no
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        profilePicture.layer.cornerRadius = 20
        profilePicture.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(profilePicturePicker)))
        profilePicture.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segue.destination.modalPresentationStyle = .overFullScreen
    }
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var profilePicture: UIImageView!
    
    @IBOutlet weak var inputName: UITextField!
    
    @IBOutlet weak var inputEmail: UITextField!
    
    @IBOutlet weak var inputPassword: UITextField!
    
    
    @IBOutlet weak var signOutButton: UIButton!
    
    @IBAction func signUpButtonTap(_ sender: UIButton) {
        signUp()
    }
    
    let picker = UIImagePickerController()
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    @objc func profilePicturePicker(){
       // present(picker, animated: true)
    }
    func signUp(){
        if inputEmail.text == "" || inputPassword.text == "" || inputName.text == ""
        // || profilePicture.image == UIImage(systemName: "person.fill")
        {
            let alert = UIAlertController(title: "Error", message: "Cannot sign up with empty credentials!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        } else {
//            var aiView = UIView(frame: self.view.bounds)
//            aiView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
//            activityIndicator.center = aiView.center
//            activityIndicator.startAnimating()
//            aiView.addSubview(activityIndicator)
//            self.view.addSubview(aiView)
            
            let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)

            let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
            loadingIndicator.hidesWhenStopped = true
            loadingIndicator.style = UIActivityIndicatorView.Style.medium
            loadingIndicator.startAnimating();

            alert.view.addSubview(loadingIndicator)
            present(alert, animated: true, completion: nil)
            
            
            let st = Storage.storage().reference()
            let safeEmail = inputEmail.text!.trimmingCharacters(in: .whitespaces)
            let safePassword = inputPassword.text!.trimmingCharacters(in: .whitespaces)
            guard let image = profilePicture.image?.pngData() else {
                return
            }
            Auth.auth().createUser(withEmail: safeEmail, password: safePassword) { authResult, error in
                
                if error != nil {
                    
                    let alert = UIAlertController(title: nil, message: error?.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true)
                }
                guard let currentUser = Auth.auth().currentUser?.createProfileChangeRequest() else {
                    return
                }
                currentUser.displayName = self.inputName.text
                currentUser.commitChanges()
                if let email = Auth.auth().currentUser?.email {
                    st.child("profileImages/\(email).png").putData(image) { metadata, error in
                        if error != nil {
                        }
                        st.child("profileImages/\(email).png").downloadURL { url, error in
                            guard let photoUrl = url, error == nil else {
                                return
                            }
                            let urlString = photoUrl.absoluteString
                        
                            guard let currentUser = Auth.auth().currentUser?.createProfileChangeRequest() else {
                                return
                            }
                           currentUser.photoURL = URL(string: urlString)
                            //MARK: IMPORTANT
                            currentUser.commitChanges()
                       
                            
                        }
                        
                        let profile = UserDefaults.standard
                        profile.setValue(image, forKey: "profile")
                        
                        
                    }
                }
                self.inputName.text = ""
                self.inputEmail.text = ""
                self.inputPassword.text = ""
                let loggedIn = UserDefaults.standard
                loggedIn.set(true, forKey: "logged")
                
//                self.activityIndicator.stopAnimating()
//                aiView.removeFromSuperview()
                DispatchQueue.main.async {
                    self.dismiss(animated: false, completion: nil)
                    let nav = self.storyboard?.instantiateViewController(withIdentifier: "mainNav") as! UITabBarController
                    self.present(nav, animated: false, completion: nil)
                }
                    
               
                
            }
        }
    }
}


extension SignUpViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.editedImage] as? UIImage {
            profilePicture.image = image
        }
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

extension SignUpViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == inputName {
            inputEmail.becomeFirstResponder()
        } else if textField == inputEmail {
            inputPassword.becomeFirstResponder()
        } else if textField == inputPassword {
            view.endEditing(true)
            signUp()
        }
        return true
    }
}
