//
//  LoginViewController.swift
//  whatsup
//
//  Created by Reethika Alla on 1/24/22.
//

import Foundation
import UIKit
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set the delegates and keyboard type
        emailTextField.delegate = self
        emailTextField.keyboardType = .emailAddress
        emailTextField.returnKeyType = UIReturnKeyType.done
        
        passwordTextField.delegate = self
        passwordTextField.returnKeyType = UIReturnKeyType.done
        passwordTextField.isSecureTextEntry = true
        //make password field a secure entry
        passwordTextField.isSecureTextEntry = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidLoad()
        //Need not have a navigation controller for the home screen.
        navigationController?.isNavigationBarHidden = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        if let email = emailTextField.text, let password = passwordTextField.text{
            
            //sign in
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                //watch out for errors
                if let e = error{
                    print(e.localizedDescription)
                    
                    //show an alert
                    let errorAlert = UIAlertController(title: "Error", message: e.localizedDescription, preferredStyle: UIAlertController.Style.alert)

                    errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                        errorAlert.dismiss(animated: true, completion: nil)
                    }))

                    self!.present(errorAlert, animated: true, completion: nil)
                    
                } else{
                    //If no errors...go to ChatViewController
                    self!.performSegue(withIdentifier: Constants.loginSegue, sender: self)
                }
        }
      }
    }
}
