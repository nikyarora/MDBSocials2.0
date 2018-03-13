//
//  AppDelegate.swift
//  MDBSocials
//
//  Created by Nikhar Arora on 2/19/18.
//  Copyright © 2018 Nikhar Arora. All rights reserved.
//
import UIKit
import CoreGraphics
import CoreLocation
import MapKit

class DetailViewController: UIViewController {
    
    var post: Post!
    var currentLocation: CLLocationCoordinate2D?
    let locationManager = CLLocationManager()
    
    var mainView: DetailView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        view.backgroundColor = .MDBBlue
        mainView = DetailView(frame: view.frame, controller: self)
        view.addSubview(mainView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = post.eventName
    }
    
    override func viewDidAppear(_ animated: Bool) {
        mainView.queryLyft()
        mainView.addAnnotationToMap()
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is InterestedUsersViewController {
            let dest = segue.destination as! InterestedUsersViewController
            dest.userIDs = post.interestedUserIds
        }
    }
}

extension DetailViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Updated location")
        guard let currentLoc: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        self.currentLocation = currentLoc
    }
}
