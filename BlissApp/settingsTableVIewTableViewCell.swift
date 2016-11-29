//
//  settingsTableVIewTableViewCell.swift
//  BlissApp
//
//  Created by Valentina Henao on 11/25/16.
//  Copyright © 2016 Valentina Henao. All rights reserved.
//

import UIKit

class settingsTableVIewTableViewCell: UITableViewCell {

    @IBOutlet var settingTitle: UILabel!
    @IBOutlet var settingImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
