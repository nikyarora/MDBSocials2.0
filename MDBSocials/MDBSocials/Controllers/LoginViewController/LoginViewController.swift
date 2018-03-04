
//  AppDelegate.swift
//  MDBSocials
//
//  Created by Nikhar Arora on 2/19/18.
//  Copyright © 2018 Nikhar Arora. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    var emailField: UITextField!
    var passwordField: UITextField!
    var logInButton: UIButton!
    var signUpButton: UIButton!
    var appTitle: UIImageView!
    var logoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .MDBBlue
        
        setupLogo()
        setupEmailField()
        setupPasswordField()
        setupLogInButton()
        setupMakeAccountButton()
        
        if Auth.auth().currentUser != nil {
            performSegue(withIdentifier: "toFeedFromLogin", sender: self)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    func setupLogo(){
        appTitle = UIImageView(frame: CGRect(x: view.frame.width * 0.1, y: view.frame.height * 0.15, width: view.frame.width * 0.8, height: view.frame.height * 0.2))
        appTitle.clipsToBounds = true
        appTitle.image = UIImage(named: "mdbsocials")
        self.view.addSubview(appTitle)
    }
    
    func setupEmailField(){
        emailField = UITextField(frame: CGRect(x: view.frame.width * 0.2, y: view.frame.height * 0.4, width: view.frame.width * 0.6, height: 50))
        emailField.adjustsFontSizeToFitWidth = true
        emailField.placeholder = "  Email"
        emailField.backgroundColor = .white
        emailField.layer.cornerRadius = CGFloat(3.0)
        emailField.layoutIfNeeded()
        emailField.layer.borderColor = UIColor.lightGray.cgColor
        emailField.layer.borderWidth = 1.0
        emailField.layer.masksToBounds = true
        emailField.textColor = UIColor.black
        self.view.addSubview(emailField)
    }
    
    func setupPasswordField(){
        passwordField = UITextField(frame: CGRect(x: view.frame.width * 0.2, y: view.frame.height * 0.5, width: view.frame.width * 0.6, height: 50))
        passwordField.adjustsFontSizeToFitWidth = true
        passwordField.placeholder = "  Password"
        passwordField.backgroundColor = .white
        passwordField.layer.cornerRadius = CGFloat(3.0)
        passwordField.layer.borderColor = UIColor.lightGray.cgColor
        passwordField.layer.borderWidth = 1.0
        passwordField.layer.masksToBounds = true
        passwordField.textColor = UIColor.black
        passwordField.isSecureTextEntry = true
        self.view.addSubview(passwordField)
    }
    
    func setupLogInButton(){
        logInButton = UIButton(frame: CGRect(x: 30, y: 500, width: view.frame.width/2 - 60, height: 60))
        logInButton.setTitle("Log In", for: .normal)
        logInButton.backgroundColor = .white
        logInButton.layer.cornerRadius = 10
        logInButton.addTarget(self, action: #selector(tappedLogin), for: .touchUpInside)
        logInButton.setTitleColor(.MDBBlue, for: .normal)
        self.view.addSubview(logInButton)
    }
    
    func setupMakeAccountButton(){
        signUpButton = UIButton(frame: CGRect(x: view.frame.width/2 + 30, y: 500, width: view.frame.width/2 - 60, height: 60))
        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.backgroundColor = .white
        signUpButton.layer.cornerRadius = 10
        signUpButton.addTarget(self, action: #selector(tappedSignUp), for: .touchUpInside)
        signUpButton.setTitleColor(.MDBBlue, for: .normal)
        self.view.addSubview(signUpButton)
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
    }
    
    @objc func tappedLogin(){
        if emailField.hasText && passwordField.hasText{
            FirebaseAuthHelper.logIn(email: emailField.text!, password: passwordField.text!, withBlock: { (user) in
                self.performSegue(withIdentifier: "toFeedFromLogin", sender: self)
            })
        }
    }
    
    @objc func tappedSignUp(){
        self.performSegue(withIdentifier: "showSignup", sender: self)
    }
    
}
