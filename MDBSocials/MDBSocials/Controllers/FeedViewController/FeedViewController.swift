//
//  AppDelegate.swift
//  MDBSocials
//
//  Created by Nikhar Arora on 2/19/18.
//  Copyright © 2018 Nikhar Arora. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {

    var logoutButton: UIButton!
    var feedTableView: UITableView!
    var posts: [Post] = []
    var selectedPost: Post!
    var postsLoaded = false
    
    override func viewDidLoad() {
        view.backgroundColor = .MDBBlue
        super.viewDidLoad()
        setupTableView()
    }
        
    func setupNavigationBar(){
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 74, height: 44))
        imageView.contentMode = .scaleAspectFit
        let image = #imageLiteral(resourceName: "mdbsocials")
        imageView.image = image
        navigationItem.titleView = imageView
        self.tabBarController?.navigationItem.titleView = imageView
        self.tabBarController?.navigationController?.navigationBar.tintColor = .white
        self.tabBarController?.navigationController?.navigationBar.barTintColor = .MDBBlue
        let textAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        logoutButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 30))
        //logoutButton.setTitle("Logout", for: .normal)
        logoutButton.setImage(#imageLiteral(resourceName: "logout"), for: .normal)
        logoutButton.setTitleColor(.white, for: .normal)
        logoutButton.addTarget(self, action: #selector(logOut), for: .touchUpInside)
        self.tabBarController?.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: logoutButton)
        
        self.tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(newPost))
    }
    
    func setupTableView(){
        feedTableView = UITableView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        feedTableView.delegate = self
        feedTableView.dataSource = self
        feedTableView.separatorColor = .clear
        view.addSubview(feedTableView)
        feedTableView.register(FeedTableViewCell.self, forCellReuseIdentifier: "post")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupNavigationBar()
        if !FirebaseAuthHelper.isLoggedIn() {
            postsLoaded = false
            self.performSegue(withIdentifier: "showLogin", sender: self)
        }
        else if !postsLoaded{
            posts.removeAll()
            FirebaseDatabaseHelper.fetchPosts(withBlock: { posts in
                for p in posts{
                    if !(p.getDateFromString().timeIntervalSinceNow < 0) {
                        self.posts.insert(p, at: 0)
                    }
                }
                self.posts = self.posts.sorted(by: { $0.getDateFromString().compare($1.getDateFromString()) == .orderedAscending })
                
                self.feedTableView.reloadData()
            })
            
            postsLoaded = true
        }
        else{
            self.feedTableView.reloadData()
        }
        let myEventsViewController = self.tabBarController!.viewControllers![1] as! MyEventsViewController
        myEventsViewController.posts.removeAll()
        let userID = FirebaseAuthHelper.getCurrentUser()!.uid
        for p in self.posts {
            if p.posterId == userID || p.getInterestedUserIds().contains(userID) {
                myEventsViewController.posts.append(p)
            }
        }
    }
    
    @objc func logOut(){
        postsLoaded = false
        FirebaseAuthHelper.logOut(view: self).then { success -> Void in 
            self.performSegue(withIdentifier: "showLogin", sender: self)
        }
    }
    
    @objc func newPost(){
        self.performSegue(withIdentifier: "showNewSocial", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is DetailViewController {
            let dest = segue.destination as! DetailViewController
            dest.post = selectedPost
        }
    }
}

extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = feedTableView.dequeueReusableCell(withIdentifier: "post", for: indexPath) as! FeedTableViewCell
        let post = posts[indexPath.row]
        cell.awakeFromNib()
        cell.startLoadingView()
        if post.image == nil {
            post.getPicture().then { success -> Void in
                cell.mainImageView.image = post.image
                cell.stopLoadingView()
            }
        }
        else{
            cell.mainImageView.image = post.image
        }
        cell.titleLabel.text = post.eventName
        var u = ""
        if post.posterName == nil {
            FirebaseDatabaseHelper.getUserWithId(id: post.posterId!).then { user in
                u = user.username! }.then {
                    DispatchQueue.main.async {
                        cell.posterNameLabel.text = "Created by: " + u
                        post.posterName = u
                    }
            }
        }
        else{
            cell.posterNameLabel.text = "Created by: " + post.posterName!
        }
        
        FirebaseDatabaseHelper.getInterestedUsers(postId: post.id!).then { (users) -> Void in
            let count = users.count
            if count == 1{
                cell.postInterested.text = String(describing: count) + " person interested"
            }
            else{
                cell.postInterested.text = String(describing: count) + " people interested"
            }
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPost = posts[indexPath.row]
        self.performSegue(withIdentifier: "showSocialDetailFromMain", sender: self)
    }
}
