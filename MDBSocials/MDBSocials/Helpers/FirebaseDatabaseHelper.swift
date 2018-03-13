//
//  AppDelegate.swift
//  MDBSocials
//
//  Created by Nikhar Arora on 2/19/18.
//  Copyright © 2018 Nikhar Arora. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage
import ObjectMapper
import SwiftyJSON
import PromiseKit
import CoreLocation

class FirebaseDatabaseHelper {
    
    static var postsRef = Database.database().reference()
    
    static func newPostWithImage(selectedImage: UIImage, name: String, description: String, date: Date, location: CLLocationCoordinate2D) -> Promise<Bool>{
        return Promise { fulfill, error in
            let data = UIImagePNGRepresentation(selectedImage)!
            let imageRef = Storage.storage().reference().child("postImages/" + name.trimmingCharacters(in: .whitespaces) + ".png")
            imageRef.putData(data, metadata: nil) { (metadata, error) in
                guard let metadata = metadata else {
                    print("Error uploading")
                    return
                }
                let downloadURL = String(describing: metadata.downloadURL()!)
                print(downloadURL)
                let posterId = FirebaseAuthHelper.getCurrentUser()?.uid
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = Constants.dateFormat
                let dateString = dateFormatter.string(from: date)
                let postsRef = Database.database().reference().child("Posts")
                let key = postsRef.childByAutoId().key
                let newPost = ["postId": key,"name": name, "pictureURL": downloadURL, "posterId": posterId!, "description": description, "date": dateString, "latitude": location.latitude, "longitude": location.longitude] as [String : Any]
                let childUpdates = ["/\(key)/": newPost]
                postsRef.updateChildValues(childUpdates)
                print("Post created!")
                fulfill(true)
            }
        }
    }
    
    
    static func fetchPosts(withBlock: @escaping ([Post]) -> ()){
        print("Called fetch posts")
        postsRef.child("Posts").observe(.childAdded, with: { (snapshot) in
            print("Fetch posts observer called")
            let json = JSON(snapshot.value)
            if let result = json.dictionaryObject {
                if let post = Post(JSON: result){
                    withBlock([post])
                }
            }
        })
    }
    
    static func createNewUser(name: String, username: String, email: String, image: UIImage, successBlock: @escaping () -> ())  {
        let usersRef = Database.database().reference().child("User")
        let imageRef = Storage.storage().reference().child("profileImages/" + username.trimmingCharacters(in: .whitespaces) + ".png")
        let data = UIImagePNGRepresentation(image)!
        imageRef.putData(data, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {

                return
            }
            let downloadURL = String(describing: metadata.downloadURL()!)
            let userID = String(describing: FirebaseAuthHelper.getCurrentUser()!.uid)
            let newUser = ["name": name, "username": username, "email": email, "profilePictureURL": downloadURL, "userID": userID] as [String : Any]
            let childUpdates = ["/\(userID)/": newUser]
            usersRef.updateChildValues(childUpdates)
            successBlock()
        }
    }
    
    static func getUserWithId(id: String) -> Promise<UserModel> {
        return Promise { fulfill, error in
            let usersRef = Database.database().reference().child("User")
            usersRef.child(id).observeSingleEvent(of: .value, with: { (snapshot) in
                let json = JSON(snapshot.value)
                if let result = json.dictionaryObject {
                    if let user = UserModel(JSON: result){
                        fulfill(user)
                    }
                }
            })
        }
    }
    
    static func updateInterested(postId: String, userId: String) -> Promise<Bool> {
        return Promise { fulfill, _ in
            let postRef = Database.database().reference().child("Posts").child(postId).child("Interested")
            let newInterestedUser = [postRef.childByAutoId().key: userId] as [String : Any]
            postRef.updateChildValues(newInterestedUser)
            fulfill(true)
        }
    }
    
    static func getInterestedUsers(postId: String) -> Promise<[String]>{
        return Promise { fulfill, _ in
            let ref = Database.database().reference()
            ref.child("Posts").child(postId).child("Interested").observeSingleEvent(of: .value, with: { (snapshot) in
                var users: [String] = []
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    let value = snap.value as! String
                    users.append(value)
                }
                fulfill(users)
            })
        }
    }
}
