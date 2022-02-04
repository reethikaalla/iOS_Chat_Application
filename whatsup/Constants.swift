//
//  Constants.swift
//  whatsup
//
//  Created by Reethika Alla on 1/25/22.
//
import Foundation
import UIKit

struct Constants {
    static let cellIdentifier = "ReusableCell"
    static let cellNibName = "MessageCell"
    static let registerSegue = "GotoChatVCFromRegisterVC"
    static let loginSegue = "GotoChatVCFromLoginVC"
    static let appTitle = "What's Up"
    
    struct FStore {
        static let collectionName = "messages"
        static let senderField = "sender"
        static let bodyField = "body"
        static let dateField = "date"
    }
}

let blueColor = UIColor(red: 25/255, green: 130/255, blue: 252/255, alpha: 1)
let greyColor = UIColor(red: 240/255, green: 242/255, blue: 245/255, alpha: 1)

