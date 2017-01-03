//
//  FbkListTableViewCell.swift
//  Sam
//
//  Created by Valentina Henao on 12/20/16.
//  Copyright © 2016 Valentina Henao. All rights reserved.
//

import UIKit

class FbkListTableViewCell: UITableViewCell {
    
    @IBOutlet var nameLabel: UILabel?
        
    @IBOutlet var createdLabel: UILabel?
        
    @IBOutlet var profileImage: UIImageView?
    
    @IBOutlet var message: UILabel?

    @IBOutlet var link: UIImageView?
    
    @IBOutlet var reactionsCount: UILabel?

    @IBOutlet var reactionsLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
