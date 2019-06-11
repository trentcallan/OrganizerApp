//
//  LoginVC.swift
//  College
//
//  Created by Trent Callan on 8/14/18.
//  Copyright © 2018 Trent Callan. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController {

    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        Auth.auth().addStateDidChangeListener { [weak self] (_, user) in
            if let user = user {
                //user is logged in
                self?.performSegue(withIdentifier: "login", sender: nil)
            }
            // user is not logged in
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginVC.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        // Gets rid of keyboard
        view.endEditing(true)
    }
    
    @IBAction func didTapLogIn(_ sender: Any) {
        if let email = self.EmailTextField.text, let password = self.PasswordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                self.performSegue(withIdentifier: "login", sender: nil)
            })
        }
    }
    
    @IBAction func didTapSignUp(_ sender: Any) {
        self.performSegue(withIdentifier: "signup", sender: nil)
    }

}
