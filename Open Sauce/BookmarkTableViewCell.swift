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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
