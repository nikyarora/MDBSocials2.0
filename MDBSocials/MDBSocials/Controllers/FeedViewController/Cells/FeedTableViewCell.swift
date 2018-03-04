//
//  AppDelegate.swift
//  MDBSocials
//
//  Created by Nikhar Arora on 2/19/18.
//  Copyright © 2018 Nikhar Arora. All rights reserved.
//
import UIKit

class FeedTableViewCell: UITableViewCell {

    var background: UIView!
    var mainImageView: UIImageView!
    var titleLabel: UILabel!
    var posterNameLabel: UILabel!
    var postInterested: UILabel!
    var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
        
        setupBackgroundView()
    }
    
    func setupBackgroundView(){
        background = UIView(frame: CGRect(x: 10, y: 10, width: contentView.frame.width - 20, height: contentView.frame.height - 20))
        background.backgroundColor = .MDBYellow
        background.layer.cornerRadius = 10
        addSubview(background)
        setupActivityIndidicator()
        setupMainImageView()
        setupEventNameLabel()
        setupPosterNameLabel()
        setupInterestedLabal()
    }
    
    func setupActivityIndidicator(){
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 50, y: background.frame.height/2 - 20, width: 40, height: 40))
        activityIndicator.hidesWhenStopped = true
        activityIndicator.backgroundColor = (UIColor (white: 0.3, alpha: 0.8))
        activityIndicator.layer.cornerRadius = 5
        background.addSubview(activityIndicator)
    }
    
    func setupMainImageView(){
        mainImageView = UIImageView(frame: CGRect(x: 0, y:0, width: contentView.frame.width-20, height: contentView.frame.height-20))
        mainImageView.clipsToBounds = true
        mainImageView.layer.cornerRadius = 10
        mainImageView.contentMode = .scaleAspectFill
        background.addSubview(mainImageView)
    }
    
    func setupEventNameLabel(){
        titleLabel = UILabel(frame: CGRect(x: contentView.frame.width * 0.05, y: contentView.frame.height * 0.05, width: contentView.frame.width * 0.5, height: contentView.frame.height * 0.17))
        titleLabel.textColor = .MDBYellow
        titleLabel.layer.shadowColor = UIColor.black.cgColor
        titleLabel.layer.shadowOffset = CGSize(width: 0, height: 0)
        titleLabel.layer.shadowOpacity = 1.0
        titleLabel.layer.shadowRadius = 1.0
        background.addSubview(titleLabel)
        
        //titleLabel = UILabel(frame: CGRect(x: 160, y: 10, width: background.frame.width - 140, height: 30))
        //titleLabel.font = UIFont(name: "Helvetica Bold", size: 20)
        //background.addSubview(titleLabel)
    }
    
    func setupPosterNameLabel(){
        posterNameLabel = UILabel(frame: CGRect(x: contentView.frame.width * 0.36, y: contentView.frame.height * 0.05, width: contentView.frame.width * 0.5, height: contentView.frame.height * 0.17))
        posterNameLabel.textColor = .MDBYellow
        posterNameLabel.layer.shadowOffset = CGSize(width: 0, height: 0)
        posterNameLabel.layer.shadowOpacity = 1.0
        posterNameLabel.layer.shadowRadius = 1.0
        background.addSubview(posterNameLabel)
        
        /**posterNameLabel = UILabel(frame: CGRect(x: 160, y: 40, width: background.frame.width - 140, height: 20))
        posterNameLabel.font = UIFont(name: "Helvetica", size: 12)
        background.addSubview(posterNameLabel)**/
    }
    
    func setupInterestedLabal(){
        postInterested = UILabel(frame: CGRect(x: contentView.frame.width * 0.05, y: contentView.frame.height * 0.3, width: contentView.frame.width * 0.5, height: contentView.frame.height * 0.17))
        postInterested.textColor = .MDBYellow
        postInterested.layer.shadowColor = UIColor.black.cgColor
        postInterested.layer.shadowOffset = CGSize(width: 0, height: 0)
        postInterested.layer.shadowOpacity = 1.0
        postInterested.layer.shadowRadius = 1.0
        background.addSubview(postInterested)
        
        /**interestedLabel = UILabel(frame: CGRect(x: 160, y: background.frame.height - 50, width: background.frame.width - 140, height: 60))
        background.addSubview(interestedLabel)**/
    }
    
    func startLoadingView() {
        activityIndicator.startAnimating()
    }
    
    func stopLoadingView() {
        activityIndicator.stopAnimating()
    }
}

