//
//  BookmarkTableViewCell.swift
//  Open Sauce
//
//  Created by Ian Gristock on 25/11/2015.
//  Copyright © 2015 Ian Gristock. All rights reserved.
//

import UIKit

class BookmarkTableViewCell: UITableViewCell {

    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var bookmarkTitle: UILabel!
    @IBOutlet weak var bookmarkSource: UILabel!
    @IBOutlet weak var whiteBackground: UIView!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        let whiteColor = whiteBackground.backgroundColor
        let blackColor = UIColor(red:0/255, green:0/255, blue:0/255, alpha:0.3)
        super.setSelected(selected, animated: animated)
        
        if(selected) {
            whiteBackground.backgroundColor = whiteColor
            bookmarkTitle.backgroundColor = blackColor
        }
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        let whiteColor = whiteBackground.backgroundColor
        let blackColor = UIColor(red:0/255, green:0/255, blue:0/255, alpha:0.3)
        super.setHighlighted(highlighted, animated: animated)
        
        if(highlighted) {
            whiteBackground.backgroundColor = whiteColor
            bookmarkTitle.backgroundColor = blackColor
        }
    }

}
