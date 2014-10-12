//
//  TweetDetailsViewController.swift
//  twitter
//
//  Created by Maricel Quesada on 10/11/14.
//  Copyright (c) 2014 Maricel Quesada. All rights reserved.
//

import UIKit

class TweetDetailsViewController: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var retweetsLabel: UILabel!
    @IBOutlet weak var favoritesLabel: UILabel!
    @IBOutlet weak var favoriteBtn: UIButton!
    
    var tweet: Tweet!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.profileImageView.setImageWithURL(tweet?.user.profileImageUrl)
        self.profileImageView.layer.cornerRadius = 10.0
        self.profileImageView.clipsToBounds = true

        self.nameLabel.text = tweet.user.name
        self.usernameLabel.text = "@\(tweet.user.screenName)"
        self.tweetTextLabel.text = tweet.text
        self.createdAtLabel.text = tweet.createdAtString
        self.retweetsLabel.text = "\(tweet.retweetCount!)"
        self.favoritesLabel.text = "\(tweet.favoritesCount)"
        
        self.favoriteBtn.enabled = !tweet.favorited!
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }    

    @IBAction func replyAction(sender: AnyObject) {        self.performSegueWithIdentifier("replyTweetFromDetails", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "replyTweetFromDetails") {
            var detailsController = segue.destinationViewController as TweetViewController
            detailsController.tweetReplyId = self.tweet.id
            detailsController.tweetReplyUsername = self.tweet.user.screenName
        }
    }

}
