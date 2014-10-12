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
    
    var tweet: Tweet? {
        didSet {
            self.profileImageView.setImageWithURL(self.tweet!.user.profileImageUrl)
            self.nameLabel.text = self.tweet!.user.name
            self.usernameLabel.text = "@\(self.tweet!.user.screenName)"
            self.tweetTextLabel.text = self.tweet!.text
            self.timeLabel.text = self.tweet!.createdAt.shortTimeAgoSinceNow()
            
            self.profileImageView.layer.cornerRadius = 10.0
            self.profileImageView.clipsToBounds = true
            
            self.layoutIfNeeded()
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