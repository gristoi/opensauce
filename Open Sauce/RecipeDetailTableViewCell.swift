//
//  RecipeDetailTableViewCell.swift
//  Open Sauce
//
//  Created by Ian Gristock on 22/11/2015.
//  Copyright © 2015 Ian Gristock. All rights reserved.
//

import UIKit

class RecipeDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var stepNumber: UILabel!
    @IBOutlet weak var stepLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
