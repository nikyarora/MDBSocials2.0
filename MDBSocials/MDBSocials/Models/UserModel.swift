
//  AppDelegate.swift
//  MDBSocials
//
//  Created by Nikhar Arora on 2/19/18.
//  Copyright © 2018 Nikhar Arora. All rights reserved.
//


import UIKit
import ObjectMapper
import PromiseKit
import FirebaseStorage

class UserModel: Mappable {
    var id: String?
    var name: String?
    var username: String?
    var imageUrl: String?
    var email: String?
    var profilePicture: UIImage?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id                  <- map["id"]
        name                <- map["name"]
        username            <- map["username"]
        imageUrl            <- map["profilePictureURL"]
        email               <- map["email"]
    }
    
    func getPicture() -> Promise<UIImage> {
        return Promise { fulfill, _ in
            let urlReference = Storage.storage().reference(forURL: imageUrl!)
            urlReference.getData(maxSize: 30 * 1024 * 1024) { data, error in
                if let error = error {
                    print("Error getting image")
                    print(error.localizedDescription)
                } else {
                    let image = UIImage(data: data!)!
                    fulfill(image)
                }
            }
        }
    }
}
