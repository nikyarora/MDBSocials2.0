//
//  AppDelegate.swift
//  MDBSocials
//
//  Created by Nikhar Arora on 2/19/18.
//  Copyright © 2018 Nikhar Arora. All rights reserved.
//

import UIKit
import MapKit

class DetailView: UIView {

    var imageBlock: UIView!
    var mainImageView: UIImageView!
    var mapView: MKMapView!
    var getDirectionsButton: UIButton!
    
    var eventInfoView: UIView!
    var descriptionLabel: UILabel!
    var posterNameLabel: UILabel!
    
    var interestedInformationView: UIView!
    var interestedButton: UIButton!
    var viewInterestedButton: UIButton!
    var interestedLabel: UILabel!
    
    var lyftInformationView: UIView!
    var lyftLogoImage: UIImageView!
    var lyftLabelText: UILabel!
    
    var viewController: DetailViewController!
    
    init(frame: CGRect, controller: DetailViewController){
        super.init(frame: frame)
        viewController = controller
        setupHost()
        setupMap()
        setupInterested()
        setupLyft()
        mainImageView.image = viewController.post.image ?? UIImage(named: "defaultImage")
        setInterestedButtonState()
        populateLabelInfo()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupMap(){
        let yPos = CGFloat(200)
        imageBlock = UIView(frame: CGRect(x: 15, y: yPos, width: self.frame.width - 30, height: 200))
        imageBlock.backgroundColor = .MDBYellow
        imageBlock.layer.cornerRadius = 10
        self.addSubview(imageBlock)
        
        mainImageView = UIImageView(frame: CGRect(x: 0, y:0, width: imageBlock.frame.width, height: imageBlock.frame.height))
        mainImageView.contentMode = .scaleAspectFill
        mainImageView.layer.cornerRadius = 10
        mainImageView.layer.masksToBounds = true
        imageBlock.addSubview(mainImageView)
        
        mapView = MKMapView(frame: CGRect(x: 10, y: 650, width: 100, height: 100))
        mapView.mapType = .standard
        mapView.layer.cornerRadius = 10
        mapView.layer.masksToBounds = true
        self.addSubview(mapView)
        
        
        getDirectionsButton = UIButton(frame: CGRect(x: 150, y: 675, width: 200, height: 50))
        getDirectionsButton.addTarget(self, action: #selector(getDirections), for: .touchUpInside)
        getDirectionsButton.layer.cornerRadius = 10
        getDirectionsButton.setTitle("Directions", for: .normal)
        getDirectionsButton.setTitleColor(.MDBBlue, for: .normal)
        getDirectionsButton.backgroundColor = .MDBYellow
        getDirectionsButton.titleLabel?.adjustsFontSizeToFitWidth = true
        self.addSubview(getDirectionsButton)
    }
    
    func setupHost(){
        let yPos = 100
        eventInfoView = UIView(frame: CGRect(x: 15, y: yPos , width: Int(self.frame.width - 30), height: 90))
        eventInfoView.backgroundColor = .MDBYellow
        eventInfoView.layer.cornerRadius = 10
        self.addSubview(eventInfoView)
        
        posterNameLabel = UILabel(frame: CGRect(x: 15, y: 5, width: self.frame.width - 30, height: 30))
        posterNameLabel.textAlignment = .left
        
        posterNameLabel.textColor = .white
        eventInfoView.addSubview(posterNameLabel)
    
        descriptionLabel = UILabel(frame: CGRect(x: 15, y: 50, width: eventInfoView.frame.width - 30, height: 30))
        descriptionLabel.numberOfLines = 2
        descriptionLabel.textColor = .white
        descriptionLabel.textAlignment = .left
        eventInfoView.addSubview(descriptionLabel)
    }
    
    func setupInterested(){
        let yPos = CGFloat(410)
        interestedInformationView = UIView(frame: CGRect(x: 15, y: yPos, width: self.frame.width - 30, height: 125))
        interestedInformationView.backgroundColor = .MDBYellow
        interestedInformationView.layer.cornerRadius = 10
        self.addSubview(interestedInformationView)
        
        interestedLabel = UILabel(frame: CGRect(x: 15, y: 5, width: interestedInformationView.frame.width - 30, height: 30))
        interestedLabel.textColor = .white
        interestedInformationView.addSubview(interestedLabel)
        
        interestedButton = UIButton(frame: CGRect(x: 10, y: 60, width: interestedInformationView.frame.width/2 - 20, height: 50))
        interestedButton.addTarget(self, action: #selector(tappedInterested), for: .touchUpInside)
        interestedButton.layer.cornerRadius = 10
        interestedButton.titleLabel?.numberOfLines = 2
        interestedInformationView.addSubview(interestedButton)
        
        viewInterestedButton = UIButton(frame: CGRect(x: interestedInformationView.frame.width/2 + 10, y: 60, width: interestedInformationView.frame.width/2 - 20, height: 50))
        viewInterestedButton.addTarget(self, action: #selector(tappedViewInterested), for: .touchUpInside)
        viewInterestedButton.layer.cornerRadius = 10
        viewInterestedButton.setTitle("See Interested", for: .normal)
        viewInterestedButton.setTitleColor(.MDBYellow, for: .normal)
        viewInterestedButton.backgroundColor = .MDBBlue
        viewInterestedButton.titleLabel?.adjustsFontSizeToFitWidth = true
        interestedInformationView.addSubview(viewInterestedButton)
    }
    
    func setupLyft(){
        let yPos = CGFloat(545)
        lyftInformationView = UIView(frame: CGRect(x: 15, y: yPos, width: self.frame.width - 30, height: 80))
        lyftInformationView.backgroundColor = .MDBYellow
        lyftInformationView.layer.cornerRadius = 10
        self.addSubview(lyftInformationView)
        
        lyftLogoImage = UIImageView(frame: CGRect(x: 10, y: 10, width: lyftInformationView.frame.height - 20, height: lyftInformationView.frame.height - 20))
        lyftLogoImage.image = #imageLiteral(resourceName: "lyftLogo")
        lyftInformationView.addSubview(lyftLogoImage)
        
        lyftLabelText = UILabel(frame: CGRect(x: 80, y: 10, width: lyftInformationView.frame.width - 80, height: lyftInformationView.frame.height - 20))
        lyftLabelText.textColor = .white
        lyftLabelText.numberOfLines = 2
        lyftInformationView.addSubview(lyftLabelText)
    }
    
    func queryLyft(){
        let eventLocation = CLLocationCoordinate2DMake(viewController.post.latitude!, viewController.post.longitude!)
        if viewController.currentLocation != nil {
            LyftAPIHelper.getRideEstimate(pickup: viewController.currentLocation!, dropoff: eventLocation) { costEstimate in
                self.lyftLabelText.text = "A Lyft ride currently costs $" + String(describing: costEstimate.estimate!.maxEstimate.amount) + " from your current location."
            }
        } else {
            print("Unable to find current location.")
        }
    }
    
    func populateLabelInfo(){
        descriptionLabel.text = viewController.post.description
        interestedLabel.text = "Number Interested: " + String(describing: viewController.post.getInterestedUserIds().count)
        posterNameLabel.text = "Host: " + viewController.post.posterName!
    }
    
    func addAnnotationToMap(){
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: viewController.post.latitude!, longitude: viewController.post.longitude!)
        mapView.addAnnotation(annotation)
        mapView.setRegion(MKCoordinateRegionMake(annotation.coordinate, MKCoordinateSpanMake(0.001, 0.001)), animated: true)
    }
    
    func setInterestedButtonState(){
        var userHasSaidInterested = false
        for id in viewController.post.getInterestedUserIds() {
            if id as! String == FirebaseAuthHelper.getCurrentUser()?.uid {
                userHasSaidInterested = true
                break
            }
        }
        
        if userHasSaidInterested {
            interestedButton.setTitle("Already Interested", for: .normal)
            interestedButton.setTitleColor(.MDBBlue, for: .normal)
            interestedButton.backgroundColor = .clear
            interestedButton.isUserInteractionEnabled = false
        }
        else{
            interestedButton.setTitle("Interested", for: .normal)
            interestedButton.setTitleColor(.MDBYellow, for: .normal)
            interestedButton.backgroundColor = .MDBBlue
            interestedButton.isUserInteractionEnabled = true
        }
    }
    
    @objc func tappedInterested(){
        FirebaseDatabaseHelper.updateInterested(postId: viewController.post.id!, userId: (FirebaseAuthHelper.getCurrentUser()?.uid)!).then { success -> Void in
            print("Updated interested")
            self.interestedButton.setTitle("Already Interested", for: .normal)
            self.interestedButton.setTitleColor(.darkGray, for: .normal)
            self.interestedButton.isUserInteractionEnabled = false
            self.viewController.post.addInterestedUser(userID: (FirebaseAuthHelper.getCurrentUser()?.uid)!)
            self.interestedLabel.text = "Members Interested: " + String(describing: self.viewController.post.getInterestedUserIds().count)
        }
    }
    
    @objc func getDirections(){
        let urlString = "http://maps.apple.com/?saddr=&daddr=\(viewController.post.latitude!),\(viewController.post.longitude!)"
        let url = URL(string: urlString)
        UIApplication.shared.open(url!)
    }
    
    @objc func tappedViewInterested(){
        viewController.performSegue(withIdentifier: "showInterestedUsers", sender: self)
    }
}
