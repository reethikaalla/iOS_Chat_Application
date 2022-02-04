//
//  ChatViewController.swift
//  whatsup
//
//  Created by Reethika Alla on 1/24/22.
//

import Foundation
import UIKit
import Firebase



class ChatViewController: UIViewController, UITextFieldDelegate {
   
    var messages: [Message] = []
    
    @IBOutlet weak var messageTextfield: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    let db = Firestore.firestore()
    
    @IBAction func logoutPressed(_ sender: Any) {
        //logout user and pop the chat view controller
        let firebaseAuth = Auth.auth()
            do {
              try firebaseAuth.signOut()
                navigationController?.popToRootViewController(animated: true)
            } catch let signOutError as NSError {
              print("Error signing out: %@", signOutError)
            }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
          textField.resignFirstResponder()
          return true
      }
      
    @IBAction func sendButtonPressed(_ sender: Any) {
        
        //send new message
        if let messageBody = messageTextfield.text, let messageSender = Auth.auth().currentUser?.email{
            db.collection(Constants.FStore.collectionName).addDocument(data: [Constants.FStore.senderField: messageSender, Constants.FStore.bodyField: messageBody, Constants.FStore.dateField: Date().timeIntervalSince1970]) { (error) in
                if let e = error {
                    print("There was an error storing data in the database")
                } else{
                    print("Data saved successfully.")
                    DispatchQueue.main.async {
                        self.messageTextfield.text = ""
                    }
                }
            }
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        UINavigationBar.appearance().barTintColor = greyColor
        UIBarButtonItem.appearance().tintColor = blueColor
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : blueColor]
        navigationItem.hidesBackButton = true
        title = Constants.appTitle
        
        //set the delegates and keyboard type
        messageTextfield.delegate = self
        messageTextfield.returnKeyType = UIReturnKeyType.done
        
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: Constants.cellNibName, bundle: nil), forCellReuseIdentifier: Constants.cellIdentifier)
        loadMessages()
        
    }
    
    func loadMessages(){
        
        //retrieve and load all messages.
        db.collection(Constants.FStore.collectionName).order(by: Constants.FStore.dateField).addSnapshotListener { (querySnapshot, error) in
            self.messages = []
            if let e = error {
                print("There was a error while retrieving data \(e)")
            } else{
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let messageSender = data[Constants.FStore.senderField] as? String, let messageBody = data[Constants.FStore.bodyField] as? String {
                            let newMessage = Message(sender: messageSender, body: messageBody)
                            self.messages.append(newMessage)
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                
                                let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
    
}
extension ChatViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath) as! MessageCell
        cell.label.text = messages[indexPath.row].body
        
        //UI changes based on user ...sender or other people.
        if message.sender == Auth.auth().currentUser?.email{
            cell.leftImageView.isHidden = true
            cell.rightImageview.isHidden = false
            cell.messageBubble.backgroundColor = blueColor
            cell.label.textColor = UIColor.white
            
        } else{
            cell.leftImageView.isHidden = false
            cell.rightImageview.isHidden = true
            cell.messageBubble.backgroundColor = greyColor
            cell.label.textColor = UIColor.black
        }
        
        return cell
    }
}
