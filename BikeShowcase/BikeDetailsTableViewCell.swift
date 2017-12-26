//
//  BikeDetailsTableViewCell.swift
//  BikeShowcase
//
//  Created by Vishal on 26/12/17.
//  Copyright © 2017 Vishal. All rights reserved.
//

import UIKit

class BikeDetailsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var stationName: UILabel!
    @IBOutlet weak var slots: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
