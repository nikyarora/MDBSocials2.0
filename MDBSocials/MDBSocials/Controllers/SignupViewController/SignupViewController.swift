//
//  AppDelegate.swift
//  MDBSocials
//
//  Created by Nikhar Arora on 2/19/18.
//  Copyright © 2018 Nikhar Arora. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController {
    
    var fullNameField: UITextField!
    var usernameField:UITextField!
    var emailField: UITextField!
    var passwordField: UITextField!
    var selectCameraImageButton: UIButton!
    var selectLibraryImageButton: UIButton!
    var selectedImageView: UIImageView!
    var logInButton: UIButton!
    var signUpButton: UIButton!
    var signupTitleLabel: UILabel!
    var backButton: UIButton!
    var selectedImage: UIImage!
    
    var viewController: SignupViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .MDBBlue
        
        setupTitleLabel()
        setupFullNameField()
        setupUsernameField()
        setupEmailField()
        setupPasswordField()
        setupImagePicker()
        setupSignupButton()
        setupBackButton()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    func setupTitleLabel(){
        signupTitleLabel = UILabel(frame: CGRect(x: 30, y: 30, width: view.frame.width - 60, height: 80))
        signupTitleLabel.font = UIFont(name: "Helvetica", size: 40)
        signupTitleLabel.text = "Sign Up"
        signupTitleLabel.textColor = .white
        signupTitleLabel.textAlignment = .center
        self.view.addSubview(signupTitleLabel)
    }
    
    func setupPasswordField(){
        passwordField = UITextField(frame: CGRect(x: 30, y: 275, width: view.frame.width - 60, height: 40))
        passwordField.placeholder = "Password"
        passwordField.backgroundColor = .MDBYellow
        passwordField.isSecureTextEntry = true
        self.view.addSubview(passwordField)
    }
    
    func setupFullNameField(){
        fullNameField = UITextField(frame: CGRect(x: 30, y: 125, width: view.frame.width - 60, height: 40))
        fullNameField.backgroundColor = .MDBYellow
        fullNameField.placeholder = "Full Name"
        self.view.addSubview(fullNameField)
    }
    
    func setupEmailField(){
        emailField = UITextField(frame: CGRect(x: 30, y: 225, width: view.frame.width - 60, height: 40))
        emailField.placeholder = "Email"
        emailField.backgroundColor = .MDBYellow
        self.view.addSubview(emailField)
    }

    func setupUsernameField(){
        usernameField = UITextField(frame: CGRect(x: 30, y: 175, width: view.frame.width - 60, height: 40))
        usernameField.placeholder = "Username"
        usernameField.backgroundColor = .MDBYellow
        self.view.addSubview(usernameField)
    }

    
    func setupImagePicker(){
        selectCameraImageButton = UIButton(frame: CGRect(x: view.frame.width/2 + 20, y: 350, width: view.frame.width/2 - 40, height: 50))
        selectCameraImageButton.setTitle("Take Picture", for: .normal)
        selectCameraImageButton.backgroundColor = .white
        selectCameraImageButton.layer.cornerRadius = 10
        selectCameraImageButton.setTitleColor(.MDBBlue, for: .normal)
        selectCameraImageButton.addTarget(self, action: #selector(selectPictureFromCamera), for: .touchUpInside)
        self.view.addSubview(selectCameraImageButton)
        
        selectLibraryImageButton = UIButton(frame: CGRect(x: view.frame.width/2 + 20, y: 410, width: view.frame.width/2 - 40, height: 50))
        selectLibraryImageButton.setTitle("Select Picture", for: .normal)
        selectLibraryImageButton.layer.cornerRadius = 10
        selectLibraryImageButton.backgroundColor = .white
        selectLibraryImageButton.setTitleColor(.MDBBlue, for: .normal)
        selectLibraryImageButton.addTarget(self, action: #selector(selectPictureFromLibrary), for: .touchUpInside)
        self.view.addSubview(selectLibraryImageButton)
        
        selectedImageView = UIImageView(frame: CGRect(x: 10, y: 350, width: view.frame.width/2 - 20, height: 110))
        selectedImageView.contentMode = .scaleAspectFit
        selectedImageView.layer.cornerRadius = 10
        selectedImageView.image = #imageLiteral(resourceName: "image")
        self.view.addSubview(selectedImageView)
    }
    
    @objc func selectPictureFromLibrary() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func selectPictureFromCamera() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    func setupSignupButton(){
        signUpButton = UIButton(frame: CGRect(x: view.frame.width/2 - 100, y: 500, width: 200, height: 60))
        signUpButton.setTitle("Create Account", for: .normal)
        signUpButton.backgroundColor = .white
        signUpButton.layer.cornerRadius = 10
        signUpButton.addTarget(self, action: #selector(tappedCreateAccount), for: .touchUpInside)
        signUpButton.setTitleColor(.MDBBlue, for: .normal)
        self.view.addSubview(signUpButton)
    }
    
    func setupBackButton(){
        backButton = UIButton(frame: CGRect(x: view.frame.width/2 - 50, y: 575, width: 100, height: 60))
        backButton.setTitle("Cancel", for: .normal)
        backButton.backgroundColor = .white
        backButton.layer.cornerRadius = 10
        backButton.addTarget(self, action: #selector(tappedBackButton), for: .touchUpInside)
        backButton.setTitleColor(.MDBBlue, for: .normal)
        self.view.addSubview(backButton)
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        fullNameField.resignFirstResponder()
        usernameField.resignFirstResponder()
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
    }
    
    @objc func tappedCreateAccount(){
        if fullNameField.hasText && usernameField.hasText && emailField.hasText && passwordField.hasText && selectedImage != nil{
            print("Creating account")
            FirebaseAuthHelper.signUp(name: fullNameField.text!, username: usernameField.text!, email: emailField.text!, password: passwordField.text!, image: selectedImage, withBlock: { (user) in
                self.dismiss(animated: true, completion: {
                    print("Finished creating user!")
                    self.performSegue(withIdentifier: "toFeedFromSignup", sender: self)
                })
            })
        }
        else{
            let alert = UIAlertController(title: "Error", message: "Please Enter All Required Fields", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func tappedBackButton(){
        self.performSegue(withIdentifier: "fromSignupToLogin", sender: self)
    }
}

extension SignupViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        selectedImageView.image = selectedImage
        self.dismiss(animated:true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}

