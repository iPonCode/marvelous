//  ListCell.swift
//  marvelous
//
//  Created by Simón Aparicio on 05/10/2020.
//  Copyright © 2020 iPon.es. All rights reserved.
//

import UIKit
import AlamofireImage

protocol ListCellProtocol {
    func configure(id: Int, imageUrl: String?,
                   name: String, description: String,
                   comics: String, events: String, series: String)
}

class ListCell: UITableViewCell, ListCellProtocol {
    
    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var charName: UILabel!
    @IBOutlet weak var charDescription: UILabel!
    @IBOutlet weak var numComics: UILabel!
    @IBOutlet weak var numEvents: UILabel!
    @IBOutlet weak var numSeries: UILabel!
    
    // This occurs when the xib is ready
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(id: Int, imageUrl: String?,
                   name: String, description: String,
                   comics: String, events: String, series: String) {
        
        charName.text = "Character Name"
        charDescription.text = "Character Multiline description goes here, Character Multiline description goes here, Character Multiline description goes here"
        numComics.text = "33"
        numEvents.text = "22"
        numSeries.text = "11"

        // Set the default background image if imageUrl doesn't exist
        guard let bgUrl = imageUrl else {
            bgImage.image = UIImage(named: "placeholder-listCell")
            return
        }
        
        // Have bgUrl, so try to load poster image from the url
        guard let url = URL(string: bgUrl) else {
            return
        }
        bgImage.af.setImage(withURL: url)
    }
    
}
