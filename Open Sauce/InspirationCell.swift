//
//  InspirationCell.swift
//  Fudi
//
//  Created by Ian Gristock on 13/12/2015.
//  Copyright © 2015 Ian Gristock. All rights reserved.
//

import UIKit

class InspirationCell: UICollectionViewCell {
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var imageCoverView: UIView!
    
    @IBOutlet private weak var titleLabel: UILabel!
    
    @IBOutlet private weak var skillabel: UILabel!
    
    var recipe: Recipe? {
        didSet {
            if let recipe = recipe {
                if recipe.image == nil {
                    FudiApi.sharedInstance().getImage(recipe.image_url, completionHandler: {
                        responseCode, data in
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            let image = UIImage(data: data)
                            FudiApi.Caches.imageCache.storeImage(image, withIdentifier: "recipe-\(recipe.id)" )
                            // Assign image to image view of cell
                            self.imageView.image = image
                            
                        })
                        }, errorHandler: {
                            error in
                            print("could not load image")
                    });

                } else {
                    imageView.image = recipe.image
                }
                titleLabel.text = recipe.title
                skillabel.text = recipe.source
            }
        }
    }
    
    var bookmark: Bookmark? {
        didSet {
            if let bookmark = bookmark {
                if bookmark.image == nil {
                    FudiApi.sharedInstance().getImage(bookmark.image_url, completionHandler: {
                        responseCode, data in
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            let image = UIImage(data: data)
                            FudiApi.Caches.imageCache.storeImage(image, withIdentifier: "bookmarks-\(bookmark.id)" )
                            // Assign image to image view of cell
                            self.imageView.image = image
                            
                        })
                        }, errorHandler: {
                            error in
                            print("could not load image")
                    });
                    
                } else {
                    imageView.image = bookmark.image
                }
                titleLabel.text = bookmark.title
                skillabel.text = bookmark.host
            }
        }
    }

    
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) {
        super.applyLayoutAttributes(layoutAttributes)
        
        // 1
        let standardHeight = UltravisualLayoutConstants.Cell.standardHeight
        let featuredHeight = UltravisualLayoutConstants.Cell.featuredHeight
        
        // 2
        let delta = 1 - ((featuredHeight - CGRectGetHeight(frame)) / (featuredHeight - standardHeight))
        
        // 3
        let minAlpha: CGFloat = 0.4
        let maxAlpha: CGFloat = 0.75
        imageCoverView.alpha = maxAlpha - (delta * (maxAlpha - minAlpha))
        
        let scale = max(delta, 0.5)
        titleLabel.transform = CGAffineTransformMakeScale(scale, scale)
        skillabel.alpha = delta
    }
    
}
