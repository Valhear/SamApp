//
//  ListTableViewCell.swift
//  BlissApp
//
//  Created by Valentina Henao on 10/21/16.
//  Copyright © 2016 Valentina Henao. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel!
    
    @IBOutlet var ScreenNameLabel: UILabel!
    
    @IBOutlet var cellImage: UIImageView!
    
    @IBOutlet var bioLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
