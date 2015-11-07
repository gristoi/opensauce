//
//  RecipeListTableViewCell.swift
//  Open Sauce
//
//  Created by Ian Gristock on 04/11/2015.
//  Copyright © 2015 Ian Gristock. All rights reserved.
//

import UIKit

class RecipeListTableViewCell: UITableViewCell {

    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
