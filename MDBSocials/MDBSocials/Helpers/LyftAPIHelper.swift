//
//  AppDelegate.swift
//  MDBSocials
//
//  Created by Nikhar Arora on 2/19/18.
//  Copyright © 2018 Nikhar Arora. All rights reserved.
//

import Foundation
import LyftSDK
import CoreLocation

class LyftAPIHelper {
    
    static func getRideEstimate(pickup: CLLocationCoordinate2D, dropoff: CLLocationCoordinate2D, withBlock: @escaping ((Cost)) -> ()){
        LyftAPI.costEstimates(from: pickup, to: dropoff, rideKind: .Standard) { result in
            result.value?.forEach { costEstimate in
                withBlock(costEstimate)
            }
        }
    }
}
