//
//  Post.swift
//  MDBSocials
//
//  Created by Will Oakley on 2/20/18.
//  Copyright © 2018 Will Oakley. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import ObjectMapper
import Haneke
import PromiseKit

class Post: Mappable {
    var dateString: String?
    var description: String?
    var eventName: String?
    var imageUrl: String?
    var posterId: String?
    var posterName: String?
    var id: String?
    var image: UIImage?
    var interestedUserDictionary: Dictionary<String, String>?
    var interestedUserIds: [String]?
    var latitude: Double?
    var longitude: Double?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        dateString                 <- map["date"]
        description                <- map["description"]
        eventName                  <- map["name"]
        imageUrl                   <- map["pictureURL"]
        posterId                   <- map["posterId"]
        interestedUserDictionary   <- map["Interested"]
        id                         <- map["postId"]
        latitude                   <- map["latitude"]
        longitude                  <- map["longitude"]
    }
    
    func getInterestedUserIds() -> [String]{
        if interestedUserDictionary != nil && self.interestedUserIds == nil{
            self.interestedUserIds = Array(self.interestedUserDictionary!.values) as! [String]
        }
        if self.interestedUserIds == nil {
            return []
        }
        else{
            return self.interestedUserIds!
        }
    }
    
    func addInterestedUser(userID: String){
        if self.interestedUserIds == nil {
            self.interestedUserIds =  [userID]
        }
        else{
            self.interestedUserIds!.append(userID)
        }
    }
    
    func getDateFromString() -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.dateFormat
        return dateFormatter.date(from: dateString!)!
    }
    
    func getPicture() -> Promise<Bool> {
        return Promise { fufill, _ in
            if self.image == nil {
                let cache = Shared.imageCache
                if let url = URL(string: self.imageUrl!){
                    cache.fetch(URL: url).onSuccess({ img in
                        self.image = img
                        fufill(true)
                    })
                }
            }
        }
    }
}
