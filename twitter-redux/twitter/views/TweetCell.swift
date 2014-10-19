//
//  TweetCell.swift
//  twitter
//
//  Created by Maricel Quesada on 10/11/14.
//  Copyright (c) 2014 Maricel Quesada. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var replyBtn: UIButton!
    @IBOutlet weak var retweetBtn: UIButton!
    @IBOutlet weak var favoriteBtn: UIButton!
    @IBOutlet weak var retweetedImageView: UIImageView!
    @IBOutlet weak var retweetedByLabel: UILabel!
    @IBOutlet weak var topMarginConstraint: NSLayoutConstraint!
    
    var tweet: Tweet? {
        didSet {
            self.retweetedImageView.hidden = true
            self.retweetedByLabel.hidden = true
            self.topMarginConstraint.constant = 10
            
            if (self.tweet!.isRetweet) {
                setData(self.tweet!.embeddedTwitted, user: self.tweet!.user)
            } else {
                setData(self.tweet!, user:nil)
            }
            
            self.layoutIfNeeded()
        }
    }
    
    var index: Int? {
        didSet {
            replyBtn.tag = self.index!
            retweetBtn.tag = self.index!
            favoriteBtn.tag = self.index!
            profileImageView.tag = self.index!
        }
    }
    
    func setData(tweet: Tweet, user: User?) {
        self.profileImageView.setImageWithURL(tweet.user.profileImageUrl)
        self.profileImageView.userInteractionEnabled = true

        self.nameLabel.text = tweet.user.name
        self.usernameLabel.text = "@\(tweet.user.screenName)"
        self.tweetTextLabel.text = tweet.text
        self.timeLabel.text = tweet.createdAt.shortTimeAgoSinceNow()
        
        self.profileImageView.layer.cornerRadius = 10.0
        self.profileImageView.clipsToBounds = true
        
        self.favoriteBtn.setImage(UIImage(named: "favoriteEnabled"), forState: UIControlState.Selected)
        self.favoriteBtn.selected = tweet.favorited
        
        self.retweetBtn.setImage(UIImage(named: "retweetEnabled"), forState: UIControlState.Selected)
        self.retweetBtn.selected = tweet.retweeted
        //            self.retweetBtn.enabled = !tweet!.retweeted
        if (user != nil) {
            self.retweetedByLabel.text = "\(user!.name) retweeted"
            self.retweetedImageView.hidden = false
            self.retweetedByLabel.hidden = false
            self.topMarginConstraint.constant = 30
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.autoresizingMask = UIViewAutoresizing.FlexibleHeight
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
