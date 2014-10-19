//
//  SlideMenuViewController.swift
//  twitter
//
//  Created by Maricel Quesada on 10/17/14.
//  Copyright (c) 2014 Maricel Quesada. All rights reserved.
//

import UIKit

class SlideMenuViewController: UIViewController {

    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userScreenName: UILabel!
    
    var menuDelegate: MenuDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setData() {
        if (User.currentUser != nil) {
            var current = User.currentUser
            self.userProfileImage.setImageWithURL(current!.profileImageUrl)
            self.userProfileImage.layer.borderWidth = 2.0
            self.userProfileImage.layer.borderColor = UIColor.whiteColor().CGColor
            self.userProfileImage.layer.cornerRadius = 10.0
            self.userProfileImage.clipsToBounds = true
            
            self.userName.text = current!.name
            self.userScreenName.text = "@\(current!.screenName)"
        }
    }

    @IBAction func tabProfileAction(sender: UITapGestureRecognizer) {
        self.menuDelegate.showProfile()
    }
    
    @IBAction func tabHomeAction(sender: UITapGestureRecognizer) {
        self.menuDelegate.showTimeline()
    }
    
    @IBAction func tabMentionsAction(sender: UITapGestureRecognizer) {
        self.menuDelegate.showMentions()
    }
    
    @IBAction func tabLogoutAction(sender: UITapGestureRecognizer) {
        User.currentUser?.logout()
    }
}
