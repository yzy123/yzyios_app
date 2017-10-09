//
//  BrandTableViewCell.swift
//  StreetBrand
//
//  Created by 杨芷一 on 10/8/17.
//  Copyright © 2017 杨芷一. All rights reserved.
//

import UIKit

class BrandTableViewCell: UITableViewCell {
    
    //MARK: Properties
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBOutlet weak var ratingControl: RatingControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
