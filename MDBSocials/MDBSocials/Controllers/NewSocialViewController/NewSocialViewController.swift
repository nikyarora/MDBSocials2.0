// AppDelegate.swift
//  MDBSocials
//
//  Created by Nikhar Arora on 2/19/18.
//  Copyright © 2018 Nikhar Arora. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class NewSocialViewController: UIViewController {
    
    var mainView: NewSocialView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
        
        mainView = NewSocialView(frame: view.frame, controller: self)
        view.addSubview(mainView)
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        mainView.eventNameField.resignFirstResponder()
        mainView.eventDescriptionField.resignFirstResponder()
    }
}

