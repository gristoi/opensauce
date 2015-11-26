//
//  Recipe.swift
//  Open Sauce
//
//  Created by Ian Gristock on 09/11/2015.
//  Copyright © 2015 Ian Gristock. All rights reserved.
//

import Foundation
import UIKit
class Bookmark {
    
    var id: Int
    var title: String
    var originalLink: String
    var host: String
    var image_url: String
    var image:UIImage?  {
        get {
            return OpensauceApi.Caches.imageCache.imageWithIdentifier("\(self.id)")
        }
    }
    
    init(dict: [String: AnyObject]) {
        self.id = dict["id"] as! Int
        self.title = dict["title"] as! String
        self.originalLink = dict["original_link"] as! String
        self.image_url = (dict["img_src"] as? String)!
        self.host = dict["source"] as! String
    }
    
}