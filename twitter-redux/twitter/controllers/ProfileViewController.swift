//
//  ProfileViewController.swift
//  twitter
//
//  Created by Maricel Quesada on 10/18/14.
//  Copyright (c) 2014 Maricel Quesada. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tagLineLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setData()
        if (self.navigationController? != nil) {
            self.navigationController?.navigationBar
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func setData() {
        if (user.bannerImageUrl != nil) {
            self.bannerImageView.setImageWithURL(user.bannerImageUrl)
        } else {
            self.bannerImageView.backgroundColor = UIColor.grayColor()
        }
        self.profileImageView.setImageWithURL(user.profileImageUrl)
        self.profileImageView.layer.borderWidth = 3.0
        self.profileImageView.layer.borderColor = UIColor.whiteColor().CGColor
        self.profileImageView.layer.cornerRadius = 10.0
        self.profileImageView.clipsToBounds = true
        self.view.bringSubviewToFront(self.profileImageView)
        
        self.nameLabel.text = user.name
        self.screenNameLabel.text = "@\(user.screenName)"
        self.tagLineLabel.text = user.tagLine
        self.locationLabel.text = user.location
        if (user.url != nil) {
            self.urlLabel.text = user.url
            self.urlLabel.hidden = false
        }
        self.followingCountLabel.text = "\(user.followingCount)"
        self.followersCountLabel.text = "\(user.followersCount)"
    }

}
