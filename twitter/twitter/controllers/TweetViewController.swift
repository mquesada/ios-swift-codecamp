//
//  TweetViewController.swift
//  twitter
//
//  Created by Maricel Quesada on 10/11/14.
//  Copyright (c) 2014 Maricel Quesada. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var countLabel: UILabel!
    
    var tweetReplyId: Int!
    var tweetReplyUsername: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var user = User.currentUser
        self.profileImageView.setImageWithURL(user?.profileImageUrl)
        self.profileImageView.layer.cornerRadius = 10.0
        self.profileImageView.clipsToBounds = true
        
        self.nameLabel.text = user!.name
        self.userNameLabel.text = "@\(user!.screenName)"
        
        self.tweetTextView.layer.cornerRadius = 10.0
        self.tweetTextView.clipsToBounds = true

        self.tweetTextView.delegate = self
        
        TSMessage.setDefaultViewController(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func postTweet(sender: AnyObject) {
        var text = self.tweetTextView.text
        if (self.tweetReplyUsername != nil) {
            text = "@\(self.tweetReplyUsername) \(self.tweetTextView.text)"
        }
        TwitterClient.sharedInstance.postTweetWithCompletion(text, replyId: tweetReplyId) { (tweet, error) -> Void in
            if (tweet != nil) {
                self.navigationController?.popViewControllerAnimated(true)
            } else {
                println(error)
                TSMessage.showNotificationWithTitle("Error posting tweet", type: TSMessageNotificationType.Error)
            }
            
        }
    }
    
}
