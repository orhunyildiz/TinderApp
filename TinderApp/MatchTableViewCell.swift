//
//  MatchTableViewCell.swift
//  TinderApp
//
//  Created by Orhun YILDIZ on 10.06.2019.
//  Copyright © 2019 Orhun YILDIZ. All rights reserved.
//

import UIKit

class MatchTableViewCell: UITableViewCell {

    @IBOutlet weak var matchUserPhoto: UIImageView!
    
    @IBOutlet weak var matchUserName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
