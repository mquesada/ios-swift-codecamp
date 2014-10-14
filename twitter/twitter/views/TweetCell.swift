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
    
    var tweet: Tweet? {
        didSet {
            self.profileImageView.setImageWithURL(self.tweet!.user.profileImageUrl)
            self.nameLabel.text = self.tweet!.user.name
            self.usernameLabel.text = "@\(self.tweet!.user.screenName)"
            self.tweetTextLabel.text = self.tweet!.text
            self.timeLabel.text = self.tweet!.createdAt.shortTimeAgoSinceNow()
            
            self.profileImageView.layer.cornerRadius = 10.0
            self.profileImageView.clipsToBounds = true
            
            self.favoriteBtn.setImage(UIImage(named: "favoriteEnabled"), forState: UIControlState.Selected)
            self.favoriteBtn.selected = self.tweet!.favorited
            
            self.retweetBtn.setImage(UIImage(named: "retweetEnabled"), forState: UIControlState.Selected)
            self.retweetBtn.selected = tweet!.retweeted
            self.retweetBtn.enabled = !tweet!.retweeted
            
            self.layoutIfNeeded()
        }
    }
    
    var index: Int? {
        didSet {
            replyBtn.tag = self.index!
            retweetBtn.tag = self.index!
            favoriteBtn.tag = self.index!
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
