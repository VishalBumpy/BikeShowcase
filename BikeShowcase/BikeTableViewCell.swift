//
//  BikeTableViewCell.swift
//  BikeShowcase
//
//  Created by Vishal on 24/12/17.
//  Copyright © 2017 Vishal. All rights reserved.
//

import UIKit

class BikeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var detailsImageView: UIImageView!
    @IBOutlet weak var bikeName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
