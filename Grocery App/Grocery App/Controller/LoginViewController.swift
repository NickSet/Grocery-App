//
//  LoginViewController.swift
//  Grocery App
//
//  Created by Nicholas Setliff on 1/10/19.
//  Copyright © 2019 Nicholas Setliff. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet var userNameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var stayLoggedInSwitch: UISwitch!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var stackViewBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameTextField.delegate = self
        passwordTextField.delegate = self

        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardWillBeShown(note:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        Auth.auth().addStateDidChangeListener() { auth, user in
            // 2
            if user != nil {
                // 3
                //self.performSegue(withIdentifier: self.loginToVC, sender: nil)
                self.userNameTextField.text = nil
                self.passwordTextField.text = nil
            }
        }
    }
    
    @objc func keyboardWillBeShown(note: Notification) {
        let userInfo = note.userInfo!
        let padding = CGFloat(12.0)
        let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        stackViewBottomConstraint.constant = keyboardSize.height + padding
    }
    
    func login(with username: String, and password: String) {
        if stayLoggedInSwitch.isOn {
            UserDefaults.standard.set(username, forKey: "username")
            UserDefaults.standard.set(password, forKey: "password")
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - IBActions
extension LoginViewController {
    @IBAction func attemptLogin() {
        guard let userName = userNameTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        login(with: userName, and: password)
    }
}

// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 0 {
            passwordTextField.becomeFirstResponder()
        }
        if textField.tag == 1 {
            //login
        }
        return true
    }
}

