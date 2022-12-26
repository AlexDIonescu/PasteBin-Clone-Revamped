//
//  NewPostViewController.swift
//  PasteBin Clone
//
//  Created by Alex Ionescu on 16.11.2022.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class NewPostViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textInput.delegate = self
        textInput.layer.borderWidth = 2
        textInput.layer.cornerRadius = 10
        textInput.text = "Type here"
        if view.backgroundColor == .black {
            textInput.layer.borderColor = UIColor.white.cgColor
        } else if view.backgroundColor == .white {
            textInput.layer.borderColor = UIColor.black.cgColor

        }
    }
    
    @IBOutlet weak var textInput: UITextView!
    
    @IBAction func postButtonTap(_ sender: UIButton) {
        post()
    }
    
    func post() {
        
        if textInput.text == "" {
            let alert = UIAlertController(title: "Error", message: "Cannot upload empty text!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        } else {
            guard let safeText = textInput.text else {
                print("text")
                return
            }
        guard let name = Auth.auth().currentUser?.displayName else {
            print("name")
            print("\(Auth.auth().currentUser?.displayName)")

            return
        }
            guard let email = Auth.auth().currentUser?.email else {
                print("email")

                return
            }
            guard let imgURL = Auth.auth().currentUser?.photoURL?.absoluteString else {
                print("photo")
                print(Auth.auth().currentUser?.photoURL)
                return
            }
            view.endEditing(true)
            textInput.text = ""
            let db = Database.database().reference().child("posts").childByAutoId()
            
            db.updateChildValues(["author": name, "post": safeText, "email" : email, "photoURL": imgURL])
    }
}

}

extension NewPostViewController : UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
                textView.text = nil
                textView.textColor = UIColor.black
            }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
                textView.text = "Type here"
                textView.textColor = UIColor.lightGray
            }
    }
}

