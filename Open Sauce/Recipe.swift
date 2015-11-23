//
//  Recipe.swift
//  Open Sauce
//
//  Created by Ian Gristock on 09/11/2015.
//  Copyright © 2015 Ian Gristock. All rights reserved.
//

import Foundation
import UIKit
class Recipe {
    
    var id: Int
    var title: String
    var ingredients:[Ingredient] = []
    var steps: [Step] = []
    var serves: String
    var difficulty: String
    var duration: String
    var image_url: String
    var image:UIImage?  {
        get {
            return OpensauceApi.Caches.imageCache.imageWithIdentifier("\(self.id)")
        }
    }

    init(dict: [String: AnyObject]) {
        self.id = dict["id"] as! Int
        self.title = dict["title"] as! String
        self.serves = dict["serves"] as! String
        self.difficulty = dict["difficulty"] as! String
        self.duration = dict["preparation_time"] as! String
        self.image_url = (dict["img_src"] as? String)!
        
        let ingredientsArray = dict["ingredients"]!["data"]! as? [[String:AnyObject]]!
        let stepsArray = dict["steps"]!["data"]! as? [[String:AnyObject]]!
        
        for i:[String:AnyObject] in ingredientsArray! {
            let ingredient = Ingredient(id: i["id"] as! Int, name:i["title"] as! String)
            print("appending ingredient")
            ingredients.append(ingredient)
        }
        
        for s:[String:AnyObject] in stepsArray! {
            print("appending step")
            let step = Step(id: s["id"] as! Int, name:s["title"] as! String)
            steps.append(step)
        }
    }
    
}