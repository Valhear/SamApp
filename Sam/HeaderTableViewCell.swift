//
//  HeaderTableViewCell.swift
//  SamApp
//
//  Created by Valentina Henao on 11/9/16.
//  Copyright © 2016 Valentina Henao. All rights reserved.
//

import UIKit

class HeaderTableViewCell: UITableViewCell {

    @IBOutlet var imageHeader: UIImageView!
    
    @IBOutlet var userHeader: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
