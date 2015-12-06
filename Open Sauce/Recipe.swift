//
//  Recipe.swift
//  Open Sauce
//
//  Created by Ian Gristock on 09/11/2015.
//  Copyright © 2015 Ian Gristock. All rights reserved.
//

import Foundation
import UIKit
import CoreData
class Recipe: NSManagedObject {
    
    @NSManaged var id: NSNumber
    @NSManaged var title: String
    @NSManaged var ingredients: NSOrderedSet?
    @NSManaged var steps:  NSOrderedSet?
    @NSManaged var serves: String
    @NSManaged var difficulty: String
    @NSManaged var duration: String
    @NSManaged var image_url: String
    var image:UIImage?  {
        get {
            return FudiApi.Caches.imageCache.imageWithIdentifier("recipe-\(self.id)")
        }
    }
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }

    init(dict: [String: AnyObject], context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName("Recipe", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        id = Int(dict["id"] as! NSNumber)
        title = dict["title"] as! String
        serves = dict["serves"] as! String
        difficulty = dict["difficulty"] as! String
        duration = dict["preparation_time"] as! String
        image_url = (dict["img_src"] as? String)!
    }
    
}
