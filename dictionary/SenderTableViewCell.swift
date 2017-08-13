//
//  SenderTableViewCell.swift
//  dictionary
//
//  Created by Sriteja Chilakamarri on 13/07/17.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit

class SenderTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBOutlet var senderText: UILabel!
    @IBOutlet var senderContentView: UIView!
    
}
