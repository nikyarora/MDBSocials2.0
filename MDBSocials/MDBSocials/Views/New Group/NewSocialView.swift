//
//  NewSocialView.swift
//  MDBSocials
//
//  Created by Nikhar Arora on 3/3/18.
//  Copyright © 2018 Nikhar Arora. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import MKSpinner
import CoreLocation
import LocationPicker

class NewSocialView: UIView {
    
    var firstBlockView: UIView!
    var eventNameField: SkyFloatingLabelTextField!
    var eventDescriptionField: SkyFloatingLabelTextField!
    
    var secondBlockView: UIView!
    var selectLibraryImageButton: UIButton!
    var selectCameraImageButton: UIButton!
    var selectLocationButton: UIButton!
    var selectedImageView: UIImageView!
    
    var thirdBlockView: UIView!
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
        setupFirstBlock()
        setupSecondBlock()
        setupThirdBlock()
    }
    
    func setupNavigationBar(){
        viewController.navigationController?.navigationBar.tintColor = .white
        viewController.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        let textAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        viewController.navigationController?.navigationBar.titleTextAttributes = textAttributes
        viewController.navigationItem.title = "New Post"
        viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelNewPost))
        
        submitButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 30))
        submitButton.setTitle("Submit!", for: .normal)
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.addTarget(self, action: #selector(newPost), for: .touchUpInside)
        viewController.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: submitButton)
    }
    
    func setupFirstBlock(){
        firstBlockView = UIView(frame: CGRect(x: 15, y: 85, width: self.frame.width - 30, height: 130))
        firstBlockView.backgroundColor = .MDBBlue
        firstBlockView.layer.cornerRadius = 10
        self.addSubview(firstBlockView)
        
        eventNameField = SkyFloatingLabelTextField(frame: CGRect(x: 10, y: 10, width: firstBlockView.frame.width - 20, height: 40))
        eventNameField.placeholder = "Event Name"
        eventNameField.title = "Event Name"
        eventNameField.textColor = .white
        eventNameField.placeholderColor = .MDBYellow
        eventNameField.lineColor = .MDBYellow
        eventNameField.selectedTitleColor = .MDBYellow
        eventNameField.titleColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        eventNameField.selectedLineColor = .MDBYellow
        eventNameField.tintColor = .white
        firstBlockView.addSubview(eventNameField)
        
        eventDescriptionField = SkyFloatingLabelTextField(frame: CGRect(x: 10, y: 70, width: firstBlockView.frame.width - 20, height: 40))
        eventDescriptionField.placeholder = "Event Description"
        eventDescriptionField.title = "Event Description"
        eventDescriptionField.textColor = .white
        eventDescriptionField.placeholderColor = .MDBYellow
        eventDescriptionField.lineColor = .MDBYellow
        eventDescriptionField.selectedTitleColor = .MDBYellow
        eventDescriptionField.titleColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        eventDescriptionField.selectedLineColor = .MDBYellow
        eventDescriptionField.tintColor = .white
        firstBlockView.addSubview(eventDescriptionField)
    }
    
    func setupSecondBlock(){
        secondBlockView = UIView(frame: CGRect(x: 15, y: 240, width: self.frame.width - 30, height: 200))
        secondBlockView.backgroundColor = .MDBBlue
        secondBlockView.layer.cornerRadius = 10
        self.addSubview(secondBlockView)
        
        selectCameraImageButton = UIButton(frame: CGRect(x: secondBlockView.frame.width/2 + 20, y: 30, width: secondBlockView.frame.width/2 - 40, height: 40))
        selectCameraImageButton.setTitle("Take Picture", for: .normal)
        selectCameraImageButton.backgroundColor = .white
        selectCameraImageButton.layer.cornerRadius = 10
        selectCameraImageButton.setTitleColor(.MDBBlue, for: .normal)
        selectCameraImageButton.addTarget(self, action: #selector(selectPictureFromCamera), for: .touchUpInside)
        secondBlockView.addSubview(selectCameraImageButton)
        
        selectLibraryImageButton = UIButton(frame: CGRect(x: secondBlockView.frame.width/2 + 20, y: 80, width: secondBlockView.frame.width/2 - 40, height: 40))
        selectLibraryImageButton.setTitle("Select Picture", for: .normal)
        selectLibraryImageButton.layer.cornerRadius = 10
        selectLibraryImageButton.backgroundColor = .white
        selectLibraryImageButton.setTitleColor(.MDBBlue, for: .normal)
        selectLibraryImageButton.addTarget(self, action: #selector(selectPictureFromLibrary), for: .touchUpInside)
        secondBlockView.addSubview(selectLibraryImageButton)
        
        selectLocationButton = UIButton(frame: CGRect(x: secondBlockView.frame.width/2 + 20, y: 130, width: secondBlockView.frame.width/2 - 40, height: 40))
        selectLocationButton.setTitle("Select Location", for: .normal)
        selectLocationButton.layer.cornerRadius = 10
        selectLocationButton.backgroundColor = .white
        selectLocationButton.setTitleColor(.MDBBlue, for: .normal)
        selectLocationButton.addTarget(self, action: #selector(selectLocation), for: .touchUpInside)
        secondBlockView.addSubview(selectLocationButton)
        
        selectedImageView = UIImageView(frame: CGRect(x: 10, y: 10, width: secondBlockView.frame.width/2 - 20, height: secondBlockView.frame.height - 20))
        selectedImageView.contentMode = .scaleAspectFit
        selectedImageView.layer.cornerRadius = 10
        selectedImageView.image = #imageLiteral(resourceName: "defaultImage")
        secondBlockView.addSubview(selectedImageView)
    }
    
    func setupThirdBlock(){
        thirdBlockView = UIView(frame: CGRect(x: 10, y: 475, width: self.frame.width - 20, height: 200))
        secondBlockView.backgroundColor = .MDBBlue
        thirdBlockView.layer.cornerRadius = 10
        self.addSubview(thirdBlockView)
        
        datePicker = UIDatePicker(frame: CGRect(x: 10, y: 10, width: thirdBlockView.frame.width - 20, height: thirdBlockView.frame.height - 20))
        thirdBlockView.addSubview(datePicker)
    }
    
    @objc func newPost() {
        if eventNameField.hasText && eventDescriptionField.hasText && selectedImage != nil && selectedLocation != nil {
            MKFullSpinner.show("Uploading Post", animated: true)
            FirebaseDatabaseHelper.newPostWithImage(selectedImage: selectedImage, name: eventNameField.text!, description: eventDescriptionField.text!, date: datePicker.date, location: selectedLocation).then { success -> Void in
                MKFullSpinner.hide()
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

