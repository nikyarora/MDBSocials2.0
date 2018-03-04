//
//  NewSocialViewController.swift
//  MDBSocials
//
//  Created by Niky Arora on 2/21/18.
//  Copyright © 2018 Niky Arora. All rights reserved.
//

import UIKit
import Firebase

class NewSocialViewController: UIViewController {
    
    //Background Image
    var backgroundImage: UIImageView!
    
    //Return to post button
    var returnButton: UIButton!
    
    //Post Button
    var postButton: UIButton!
    
    //Post Title
    var postTitleTextField: UITextField!
    
    //Post Body
    var postBodyTextField: UITextView!
    
    //Post Date
    var postDateText: String = ""
    var dateAndTimePicker: UIDatePicker!
    
    //Post Image View
    var postImage: UIImageView!
    
    //Select image from library
    var selectFromLibraryButton: UIButton!
    var takeImageButton: UIButton!
    
    //Image picker
    var picker = UIImagePickerController()
    
    var auth = Auth.auth()
    var postsRef: DatabaseReference = Database.database().reference().child("Posts")
    var storage: StorageReference = Storage.storage().reference()
    var currentUser: User?
    
    //Event Image View
    var eventImageView : UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
        createBackground()
        createReturnButton()
        createPostButton()
        createPostTitle()
        createDateAndTimePicker()
        createPostBody()
        createSelectFromLibrary()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        Users.getCurrentUser(withId: (Auth.auth().currentUser?.uid)!, block: {(cUser) in
            self.currentUser = cUser
        })
    }
    
    //Create background
    func createBackground() {
        backgroundImage = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        backgroundImage.backgroundColor = UIColor(red:0.45, green:0.74, blue:0.95, alpha:1.0)
        view.addSubview(backgroundImage)
    }
    
    //Create Return Button
    func createReturnButton(){
        self.navigationController?.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "delete")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "delete")
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: #selector(returnToView))
    }
    
    //Create a post button
    func createPostButton(){
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "addnewunclicked"), style: .plain, target: self, action: #selector(addPost))
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    //Return to the last feed view
    @objc func returnToView() {
        self.navigationController?.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "deleteclicked")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "deleteclicked")
        dismiss(animated: true, completion: nil)
    }
    
    //Add the post
    @objc func addPost() {
        if postTitleTextField.hasText && postBodyTextField.hasText && eventImageView.image != nil
        {
            MDBSocialsAPIClient.createNewPost(eventTitle: self.postTitleTextField.text!, eventDescription: self.postBodyTextField.text!, eventDate: self.postDateText, poster: (self.currentUser?.name)!, eventImageView: self.eventImageView!, posterId: (self.currentUser?.id)!)
            //self.dismiss(animated: true, completion: nil)
            self.performSegue(withIdentifier: "toFeedFromNewSocial", sender: self)
        }
        else {
            let alert = UIAlertController(title: "Error", message: "Please Enter All Required Fields", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //Create the name of the event
    func createPostTitle() {
        postTitleTextField = UITextField(frame: CGRect(x: view.frame.width * 0.05, y: view.frame.height * 0.29, width: view.frame.width * 0.9, height: view.frame.height * 0.1))
        postTitleTextField.backgroundColor = .white
        postTitleTextField.layer.cornerRadius = 8
        postTitleTextField.placeholder = "  Event Name"
        view.addSubview(postTitleTextField)
        
    }
    
    //Create the body of the function
    func createPostBody() {
        postBodyTextField = UITextView(frame: CGRect(x: view.frame.width * 0.05, y: view.frame.height * 0.4, width: view.frame.width * 0.9, height: view.frame.height * 0.1))
        postBodyTextField.layer.cornerRadius = 8
        postBodyTextField.placeholder = "Event Description"
        postBodyTextField.backgroundColor = .white
        view.addSubview(postBodyTextField)
    }
    
    func createDateAndTimePicker() {
        dateAndTimePicker = UIDatePicker(frame: CGRect(x: 0, y: 400, width: 400, height: 175))
        dateAndTimePicker.addTarget(self, action: #selector(onDidChangeDate(sender:)), for: .valueChanged)
        self.view.addSubview(dateAndTimePicker)
    }
    
    @objc func onDidChangeDate(sender: UIDatePicker){
        // date format
        let myDateFormatter: DateFormatter = DateFormatter()
        myDateFormatter.dateFormat = "E MM/dd/yyyy hh:mm a"
        postDateText = myDateFormatter.string(from: dateAndTimePicker.date)
    }
    
    //Create the photo library picker
    func createSelectFromLibrary() {
        eventImageView = UIImageView(frame: CGRect(x: view.frame.width * 0.05, y: view.frame.height * 0.13, width: view.frame.width * 0.9, height: view.frame.height * 0.15))
        eventImageView.layer.cornerRadius = 8
        eventImageView.clipsToBounds = true
        eventImageView.contentMode = .scaleAspectFill
        selectFromLibraryButton = UIButton(frame: CGRect(x: view.frame.width * 0.05, y: view.frame.height * 0.7, width: view.frame.width * 0.45, height: view.frame.height * 0.08))
        selectFromLibraryButton.setTitle("Photo From Library", for: .normal)
        selectFromLibraryButton.setTitleColor(UIColor(red: 67.0/255.0, green: 130.0/255.0, blue: 232.0/255.0, alpha: 1.0), for: .normal)
        selectFromLibraryButton.backgroundColor = .white
        selectFromLibraryButton.layer.cornerRadius = 8
        selectFromLibraryButton.addTarget(self, action: #selector(pickImage), for: .touchUpInside)
        takeImageButton = UIButton(frame: CGRect(x: view.frame.width * 0.5, y: view.frame.height * 0.7, width: view.frame.width * 0.45, height: view.frame.height * 0.08))
        takeImageButton.setTitle("Take Image", for: .normal)
        takeImageButton.setTitleColor(UIColor(red: 67.0/255.0, green: 130.0/255.0, blue: 232.0/255.0, alpha: 1.0), for: .normal)
        takeImageButton.backgroundColor = .white
        takeImageButton.layer.cornerRadius = 8
        takeImageButton.addTarget(self, action: #selector(takeImage), for: .touchUpInside)
        view.addSubview(eventImageView)
        view.addSubview(selectFromLibraryButton)
        view.addSubview(takeImageButton)
    }
    
    //Image picker
    @objc func pickImage(sender: UIButton!) {
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker, animated: true, completion: nil)
    }
    
    @objc func takeImage(sender: UIButton!) {
        picker.allowsEditing = false
        picker.sourceType = .camera
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .camera)!
        present(picker, animated: true, completion: nil)
    }
    
}


//Adds placeholder to the TextView
extension UITextView: UITextViewDelegate {
    
    /// Resize the placeholder when the UITextView bounds change
    override open var bounds: CGRect {
        didSet {
            self.resizePlaceholder()
        }
    }
    
    /// The UITextView placeholder text
    public var placeholder: String? {
        get {
            var placeholderText: String?
            
            if let placeholderLabel = self.viewWithTag(100) as? UILabel {
                placeholderText = placeholderLabel.text
            }
            
            return placeholderText
        }
        set {
            if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
                placeholderLabel.text = newValue
                placeholderLabel.sizeToFit()
            } else {
                self.addPlaceholder(newValue!)
            }
        }
    }
    
    /// When the UITextView did change, show or hide the label based on if the UITextView is empty or not
    ///
    /// - Parameter textView: The UITextView that got updated
    public func textViewDidChange(_ textView: UITextView) {
        if let placeholderLabel = self.viewWithTag(100) as? UILabel {
            placeholderLabel.isHidden = self.text.characters.count > 0
        }
    }
    
    /// Resize the placeholder UILabel to make sure it's in the same position as the UITextView text
    private func resizePlaceholder() {
        if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
            let labelX = self.textContainer.lineFragmentPadding
            let labelY = self.textContainerInset.top - 2
            let labelWidth = self.frame.width - (labelX * 2)
            let labelHeight = placeholderLabel.frame.height
            
            placeholderLabel.frame = CGRect(x: labelX, y: labelY, width: labelWidth, height: labelHeight)
        }
    }
    
    /// Adds a placeholder UILabel to this UITextView
    private func addPlaceholder(_ placeholderText: String) {
        let placeholderLabel = UILabel()
        
        placeholderLabel.text = placeholderText
        placeholderLabel.sizeToFit()
        
        placeholderLabel.font = self.font
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.tag = 100
        
        placeholderLabel.isHidden = self.text.characters.count > 0
        
        self.addSubview(placeholderLabel)
        self.resizePlaceholder()
        self.delegate = self
    }
    
}

//Extension of UIImagePickerController
extension NewSocialViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //MARK: - Delegates
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        eventImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        dismiss(animated:true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}


