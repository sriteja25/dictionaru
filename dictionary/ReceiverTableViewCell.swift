//
//  ReceiverTableViewCell.swift
//  dictionary
//
//  Created by Sriteja Chilakamarri on 13/07/17.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit

class ReceiverTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet var meaning: UILabel!
    @IBOutlet var examples: UILabel!
    @IBOutlet var ReceivercontentView: UIView!
    @IBOutlet var meaningLabel: UILabel!
    @IBOutlet var exampleLabel: UILabel!
    
    
    
}
