//
//  RecipeListTableViewCell.swift
//  Open Sauce
//
//  Created by Ian Gristock on 04/11/2015.
//  Copyright © 2015 Ian Gristock. All rights reserved.
//

import UIKit

class RecipeListTableViewCell: UITableViewCell {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var serves: UILabel!
    
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var difficulty: UILabel!
    @IBOutlet weak var whiteBackgroundView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        let blackColor = UIColor(red:0/255, green:0/255, blue:0/255, alpha:0.3)
        super.setSelected(selected, animated: animated)
        
        if(selected) {
            recipeTitle.backgroundColor = blackColor
        }
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        let blackColor = UIColor(red:0/255, green:0/255, blue:0/255, alpha:0.3)
        super.setHighlighted(highlighted, animated: animated)
        
        if(highlighted) {
            recipeTitle.backgroundColor = blackColor
        }
    }

}
