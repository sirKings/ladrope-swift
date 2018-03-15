//
//  NewsViewCell.swift
//  app
//
//  Created by MAC on 3/14/18.
//  Copyright © 2018 Ladrope. All rights reserved.
//

import UIKit

class NewsViewCell: UITableViewCell {

    @IBOutlet weak var newsDescription: UILabel!
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var newsImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func seeMorePressed(_ sender: Any) {
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
