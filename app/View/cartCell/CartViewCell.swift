//
//  CartViewCell.swift
//  app
//
//  Created by MAC on 3/15/18.
//  Copyright © 2018 Ladrope. All rights reserved.
//

import UIKit

protocol CartCellProtocol {
    func removeItem(cell: CartViewCell)
}

class CartViewCell: UITableViewCell {
    
    var cloth: Cloth?
    
    var delegate: CartCellProtocol?
    
    @IBOutlet weak var cartImage: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func removeItem(_ sender: Any) {
        delegate?.removeItem(cell: self)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        //super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
