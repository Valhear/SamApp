//
//  FbkFriendsTableViewCell.swift
//  Sam
//
//  Created by Valentina Henao on 12/23/16.
//  Copyright © 2016 Valentina Henao. All rights reserved.
//

import UIKit

class FbkFriendsTableViewCell: UITableViewCell {

    @IBOutlet var friendImage: UIImageView!
    @IBOutlet var friendName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
