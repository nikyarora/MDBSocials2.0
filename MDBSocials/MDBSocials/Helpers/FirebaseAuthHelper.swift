//
//  AppDelegate.swift
//  MDBSocials
//
//  Created by Nikhar Arora on 2/19/18.
//  Copyright © 2018 Nikhar Arora. All rights reserved.
//

import Foundation
import FirebaseAuth
import PromiseKit

class FirebaseAuthHelper {
    
    static func logIn(email: String, password: String, withBlock: @escaping (User?)->()) {
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user: User?, error) in
            if error == nil {
                withBlock(user)
            }
            else{
                print(error.debugDescription)
                /**let alert = UIAlertController(title: "Error", message: "Invalid Login", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)**/
            }
        })
    }
    
    static func signUp(name: String, username: String, email: String, password: String, image: UIImage, withBlock: @escaping (User) -> ()) {
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user: User?, error) in
            if error == nil {
                FirebaseDatabaseHelper.createNewUser(name: name, username: username, email: email, image: image, successBlock: {
                    print("User created!")
                    withBlock(user!)
                })
            }
            else {
                print(error.debugDescription)
            }
        })
        
    }
    
    static func logOut(view: UIViewController) -> Promise<Bool> {
        return Promise { fulfill, _ in
            let auth = Auth.auth()
            do {
                try auth.signOut()
                fulfill(true)
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
                showAlert(title: "Error Logging Out", message: signOutError.debugDescription, currentView: view)
            }
        }
    }
    
    static func isLoggedIn() -> Bool {
        if Auth.auth().currentUser != nil{
            print("Logged in")
            return true
        }
        else {
            print("Not Logged In")
            return false
        }
    }
    
    static func getCurrentUser() -> User? {
            return Auth.auth().currentUser
    }
    
    static private func showAlert(title: String, message: String, currentView: UIViewController) {
        let alertController = UIAlertController(title: title, message:
            message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        currentView.present(alertController, animated: true, completion: nil)
    }
}
