//
//  DetailedPostViewController.swift
//  PasteBin Clone
//
//  Created by Alex Ionescu on 22.11.2022.
//

import UIKit

class DetailedPostViewController: UIViewController {
    var textValue = ""
    var emailValue = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        postText.text = textValue
        emailText.text = emailValue
    }
    
    @IBOutlet weak var emailText: UILabel!
    
    @IBOutlet weak var postText: UILabel!
    
}
