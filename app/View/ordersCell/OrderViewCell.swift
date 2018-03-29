//
//  OrderViewCell.swift
//  app
//
//  Created by MAC on 3/27/18.
//  Copyright © 2018 Ladrope. All rights reserved.
//

import UIKit

class OrderViewCell: UITableViewCell {
    
    var cloth: Order?
    
    @IBOutlet var orderStatus: UILabel!
    @IBOutlet var deliveryDate: UILabel!
    @IBOutlet var startDate: UILabel!
    @IBOutlet var orderName: UILabel!
    @IBOutlet var orderImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        //super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
