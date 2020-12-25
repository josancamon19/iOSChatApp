//
//  ViewController.swift
//  ChatApp
//
//  Created by Joan Cabezas on 24/12/20.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func signInButtonPressed(_ sender: Any) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            print("Email: \(email) and password: \(password)")
            
        } else {
            
        }
    
    }
    
}

