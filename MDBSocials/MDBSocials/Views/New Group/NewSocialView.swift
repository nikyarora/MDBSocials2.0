//
//  NewSocialView.swift
//  MDBSocials
//
//  Created by Nikhar Arora on 3/3/18.
//  Copyright © 2018 Nikhar Arora. All rights reserved.
//

import UIKit
import CoreLocation
import LocationPicker

class NewSocialView: UIView {
    
    var eventNameField: UITextField!
    var eventDescriptionField: UITextField!
    
    var selectLibraryImageButton: UIButton!
    var selectCameraImageButton: UIButton!
    var selectLocationButton: UIButton!
    var selectedImageView: UIImageView!
    
    var datePickerView: UIView!
    var datePicker: UIDatePicker!
    
    var submitButton: UIButton!
    
    var selectedImage: UIImage!
    var selectedLocation: CLLocationCoordinate2D!
    
    var viewController: UIViewController!
    
    init(frame: CGRect, controller: UIViewController){
        super.init(frame: frame)
        viewController = controller
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        setupNavigationBar()
        getEventInfo()
        getImage()
        getDate()
    }
    
    func setupNavigationBar(){
        viewController.navigationController?.navigationBar.tintColor = .white
        viewController.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        let textAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        viewController.navigationController?.navigationBar.titleTextAttributes = textAttributes
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 74, height: 44))
        imageView.contentMode = .scaleAspectFit
        let image = #imageLiteral(resourceName: "mdbsocials")
        imageView.image = image
        viewController.navigationItem.titleView = imageView
        viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelNewPost))
        
        submitButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 30))
        submitButton.setTitle("Post", for: .normal)
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.addTarget(self, action: #selector(newPost), for: .touchUpInside)
        viewController.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: submitButton)
    }
    
    func getEventInfo(){
        eventNameField = UITextField(frame: CGRect(x: 10, y: 100, width: 500, height: 50))
        eventNameField.placeholder = "Event Name"
        eventNameField.backgroundColor = .MDBYellow
        eventNameField.textColor = .white
        self.addSubview(eventNameField)
        
        eventDescriptionField = UITextField(frame: CGRect(x: 10, y: 170, width: 500, height: 80))
        eventDescriptionField.placeholder = "Event Description"
        eventDescriptionField.backgroundColor = .MDBYellow
        eventDescriptionField.textColor = .white
        self.addSubview(eventDescriptionField)
    }
    
    func getImage(){
        selectCameraImageButton = UIButton(frame: CGRect(x: 200, y: 420, width: 150, height: 40))
        selectCameraImageButton.setTitle("Take Picture", for: .normal)
        selectCameraImageButton.backgroundColor = .MDBYellow
        selectCameraImageButton.layer.cornerRadius = 10
        selectCameraImageButton.setTitleColor(.MDBBlue, for: .normal)
        selectCameraImageButton.addTarget(self, action: #selector(selectPictureFromCamera), for: .touchUpInside)
        self.addSubview(selectCameraImageButton)
        
        selectLibraryImageButton = UIButton(frame: CGRect(x: 30, y: 420, width: 150, height: 40))
        selectLibraryImageButton.setTitle("Select Picture", for: .normal)
        selectLibraryImageButton.layer.cornerRadius = 10
        selectLibraryImageButton.backgroundColor = .MDBYellow
        selectLibraryImageButton.setTitleColor(.MDBBlue, for: .normal)
        selectLibraryImageButton.addTarget(self, action: #selector(selectPictureFromLibrary), for: .touchUpInside)
        self.addSubview(selectLibraryImageButton)
        
        selectLocationButton = UIButton(frame: CGRect(x: self.frame.width/2-100, y: 675, width: 200, height: 40))
        selectLocationButton.setTitle("Select Location", for: .normal)
        selectLocationButton.layer.cornerRadius = 10
        selectLocationButton.backgroundColor = .MDBYellow
        selectLocationButton.setTitleColor(.MDBBlue, for: .normal)
        selectLocationButton.addTarget(self, action: #selector(selectLocation), for: .touchUpInside)
        self.addSubview(selectLocationButton)
        
        selectedImageView = UIImageView(frame: CGRect(x: self.frame.width/2-150, y: 275, width: 300, height: 150))
        selectedImageView.contentMode = .scaleAspectFit
        selectedImageView.layer.cornerRadius = 10
        selectedImageView.image = #imageLiteral(resourceName: "image")
        self.addSubview(selectedImageView)
    }
    
    func getDate(){
        datePickerView = UIView(frame: CGRect(x: 10, y: 475, width: self.frame.width - 20, height: 200))
        datePickerView.layer.cornerRadius = 10
        self.addSubview(datePickerView)
        
        datePicker = UIDatePicker(frame: CGRect(x: 10, y: 10, width: datePickerView.frame.width - 20, height: datePickerView.frame.height - 20))
        datePickerView.addSubview(datePicker)
    }
    
    @objc func newPost() {
        if eventNameField.hasText && eventDescriptionField.hasText && selectedImage != nil && selectedLocation != nil {
            FirebaseDatabaseHelper.newPostWithImage(selectedImage: selectedImage, name: eventNameField.text!, description: eventDescriptionField.text!, date: datePicker.date, location: selectedLocation).then { success -> Void in
                self.viewController.dismiss(animated: true, completion: {
                    print("Post Complete")
                })
            }
        }
        else{
            let alertController = UIAlertController(title: "Fields Blank", message:
                "Make sure you enter all required information.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            viewController.present(alertController, animated: true, completion: nil)
        }
    }
    
    @objc func selectPictureFromLibrary() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        viewController.present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func selectPictureFromCamera() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .camera
        viewController.present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func selectLocation() {
        let locationPicker = LocationPickerViewController()
        
        locationPicker.showCurrentLocationButton = true
        locationPicker.currentLocationButtonBackground = .MDBBlue
        locationPicker.showCurrentLocationInitially = true
        locationPicker.mapType = .standard
        locationPicker.useCurrentLocationAsHint = true
        locationPicker.resultRegionDistance = 500
        locationPicker.completion = { location in
            self.selectedLocation = location?.coordinate
        }
        
        viewController.present(locationPicker, animated: true) {
            print("Selecting location")
        }
    }
    
    @objc func cancelNewPost() {
        viewController.dismiss(animated: true) {
            print("Back to feed")
        }
    }
    
}

extension NewSocialView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        selectedImageView.image = selectedImage
        viewController.dismiss(animated:true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        viewController.dismiss(animated: true, completion: nil)
    }
}

