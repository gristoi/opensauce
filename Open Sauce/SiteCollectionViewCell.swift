//
//  SiteCollectionViewCell.swift
//  Open Sauce
//
//  Created by Ian Gristock on 24/11/2015.
//  Copyright © 2015 Ian Gristock. All rights reserved.
//

import UIKit

class SiteCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.imageView.layer.cornerRadius = self.imageView.frame.size.width / 2;
        self.imageView.clipsToBounds = true;
        self.imageView.layer.borderWidth = 1.0;
        self.imageView.layer.borderColor = UIColor.grayColor().CGColor;

    }
}
