//
//  ShopViewCell.swift
//  app
//
//  Created by MAC on 3/14/18.
//  Copyright © 2018 Ladrope. All rights reserved.
//

import UIKit
import Cosmos

protocol CustomCelDelegate {
    func likeBtnPressed(cell: ShopViewCell)
    func shareBtnPressed(cell: ShopViewCell)
    func commentBtnPressed(cell: ShopViewCell)
    //func clothSelected(cell: ShopViewCell)
}

class ShopViewCell: UITableViewCell {
    
    var delegate: CustomCelDelegate?
    
    var cloth: Cloth?
    
    @IBOutlet weak var numComment: UILabel!
    @IBOutlet weak var likeImage: UIButton!
    @IBOutlet weak var numLikes: UILabel!
    @IBOutlet weak var shopRating: CosmosView!
    @IBOutlet weak var shopPrice: UILabel!
    @IBOutlet weak var shopLabel: UILabel!
    @IBOutlet weak var shopName: UILabel!
    @IBOutlet weak var shopImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        shopPrice.layer.zPosition = 3
    }

    @IBAction func likeBtnPressed(_ sender: Any) {
        delegate?.likeBtnPressed(cell: self)
    }
    @IBAction func shareBtnPressed(_ sender: Any) {
        delegate?.shareBtnPressed(cell: self)
    }
    @IBAction func commentBtnPressed(_ sender: Any) {
        delegate?.commentBtnPressed(cell: self)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        //super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        //delegate?.clothSelected(cell: self)
    }
    
}
