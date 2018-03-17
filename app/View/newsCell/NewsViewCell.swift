//
//  NewsViewCell.swift
//  app
//
//  Created by MAC on 3/14/18.
//  Copyright © 2018 Ladrope. All rights reserved.
//

import UIKit

protocol NewsCellProtocol {
    func seeMore(cell: NewsViewCell)
}

class NewsViewCell: UITableViewCell {
    
    var link: String?
    var delegate: NewsCellProtocol?
    
    @IBOutlet weak var newsDescription: UILabel!
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var newsImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
    }

    @IBAction func seeMorePressed(_ sender: Any) {
        delegate?.seeMore(cell: self)
        print("see more pressed")
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        //super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
