//
//  AppDelegate.swift
//  MDBSocials
//
//  Created by Nikhar Arora on 2/19/18.
//  Copyright © 2018 Nikhar Arora. All rights reserved.
//

import UIKit

class InterestedUsersViewController: UIViewController {
    
    var userIDs: [String]?
    var users: [UserModel] = []
    
    var tableView: UITableView!
    
    override func viewDidLoad() {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 74, height: 44))
        imageView.contentMode = .scaleAspectFit
        let image = #imageLiteral(resourceName: "mdbsocials")
        imageView.image = image
        navigationItem.titleView = imageView
        self.navigationItem.titleView = imageView
        setupTableView()
    }
    
    func setupTableView(){
        tableView = UITableView(frame: view.frame)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = .clear
        tableView.register(FeedTableViewCell.self, forCellReuseIdentifier: "user")
        view.addSubview(tableView)
    }
    
    func getUsers(){
        if userIDs != nil {
            for u in userIDs!{
                print("Getting User")
                FirebaseDatabaseHelper.getUserWithId(id: u).then {user in
                    self.users.append(user)
                    }.then {
                        self.tableView.reloadData()
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getUsers()
    }
}

extension InterestedUsersViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "user", for: indexPath) as! FeedTableViewCell
        let user = users[indexPath.row]
        cell.awakeFromNib()
        cell.titleLabel.text = user.name!
        cell.posterNameLabel.text = user.username!
        cell.startLoadingView()
        if user.profilePicture == nil {
            user.getPicture().then { picture in
                DispatchQueue.main.async {
                    user.profilePicture = picture
                    cell.mainImageView.image = picture
                    cell.stopLoadingView()
                }
            }
        }
        cell.isUserInteractionEnabled = false
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
}
