//
//  EmailSignUpVC.swift
//  College
//
//  Created by Trent Callan on 8/14/18.
//  Copyright © 2018 Trent Callan. All rights reserved.
//

import UIKit
import Firebase

class EmailSignUpVC: UIViewController {

    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var username: UITextField!
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginVC.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        // Gets rid of keyboard
        view.endEditing(true)
    }
    
    @IBAction func didTapSignUp(_ sender: Any) {

        if let email = self.Email.text, let password = self.Password.text, let displayName = self.username.text {
            
            Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
                
                guard let user = authResult else {
                    print("\(error)")
                    return
                }

                self.ref.child("users").child(user.user.uid).setValue(["username": displayName])
                
                let changeRequest = user.user.createProfileChangeRequest()
                changeRequest.displayName = displayName
                changeRequest.commitChanges { (error) in
                }

                self.performSegue(withIdentifier: "signupComplete", sender: nil)
            }
        }
    }
    
}
