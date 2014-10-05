//
//  BusinessCell.swift
//  yelp
//
//  Created by Maricel Quesada on 9/30/14.
//  Copyright (c) 2014 Maricel Quesada. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var ratingImage: UIImageView!
    @IBOutlet weak var reviewsLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
    var business: Business {
        get {
            return self.business
        }
        set(data) {
            self.profileImage.setImageWithURL(data.profileImageUrl)
            self.nameLabel.text = data.name
            self.distanceLabel.text = "12 mi"
            self.ratingImage.setImageWithURL(data.ratingImageUrl)
            self.reviewsLabel.text = "\(data.reviewCount) Reviews"
            self.addressLabel.text = data.address
            self.typeLabel.text = data.categories

            // Set rounded corners
            self.profileImage.layer.cornerRadius = 10.0
            self.profileImage.clipsToBounds = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
