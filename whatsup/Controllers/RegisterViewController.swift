//
//  RegisterViewController.swift
//  whatsup
//
//  Created by Reethika Alla on 1/24/22.
//

import Foundation
import UIKit
import Firebase

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
   
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var confirmPasswordTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set the delegates and keyboard type
        emailTF.delegate = self
        emailTF.keyboardType = .emailAddress
        emailTF.returnKeyType = UIReturnKeyType.done
        
        passwordTF.delegate = self
        passwordTF.returnKeyType = UIReturnKeyType.done
        passwordTF.isSecureTextEntry = true
        
        confirmPasswordTF.delegate = self
        confirmPasswordTF.returnKeyType = UIReturnKeyType.done
        confirmPasswordTF.isSecureTextEntry = true
       
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
          textField.resignFirstResponder()
          return true
      }
      
    @IBAction func registerButtonPressed(_ sender: Any) {
        
        //check for empty text fields
        emptyTextField(textField: emailTF)
        emptyTextField(textField: passwordTF)
        emptyTextField(textField: confirmPasswordTF)
        
        //check if password field matches with the confirm password field else alert and return
        if(passwordTF.text != confirmPasswordTF.text){
            let passwordAlert = UIAlertController(title: "Invalid password", message: "Passwords don't match. Please try again", preferredStyle: UIAlertController.Style.alert)

            passwordAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                passwordAlert.dismiss(animated: true, completion: nil)
            }))

            self.present(passwordAlert, animated: true, completion: nil)
            return
        }
        
        if let email = emailTF.text, let password = passwordTF.text {
            //register a new user
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                //watch out for errors
                if let e = error{
                    print(e.localizedDescription)
                    
                    let errorAlert = UIAlertController(title: "Error", message: e.localizedDescription, preferredStyle: UIAlertController.Style.alert)

                    errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                        errorAlert.dismiss(animated: true, completion: nil)
                    }))

                    self.present(errorAlert, animated: true, completion: nil)
                    
                } else{
                    //If no errors...go to ChatViewController
                    self.performSegue(withIdentifier: Constants.registerSegue, sender: self)
                }
            }
        }
    }
    
    
    func emptyTextField(textField: UITextField) {
        
        //if empty textfield...alert and return.
        if(textField.text == ""){
            textField.layer.borderColor = UIColor.red.cgColor
            
            let errorAlert = UIAlertController(title: "Invalid input", message: "Please fill out all the information.", preferredStyle: UIAlertController.Style.alert)

            errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                errorAlert.dismiss(animated: true, completion: nil)
            }))

            self.present(errorAlert, animated: true, completion: nil)
            return
        }
    }
    
}

