//
//  OptionsViewCell.swift
//  app
//
//  Created by MAC on 3/14/18.
//  Copyright © 2018 Ladrope. All rights reserved.
//

import UIKit

class OptionsViewCell: UITableViewCell {

   
    @IBOutlet weak var optionImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var statusText: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
