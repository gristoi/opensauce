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
class Bookmark: NSManagedObject {
    
    @NSManaged var id: NSNumber
    @NSManaged var title: String
    @NSManaged var originalLink: String
    @NSManaged var host: String
    @NSManaged var image_url: String
    var image:UIImage?  {
        get {
            return OpensauceApi.Caches.imageCache.imageWithIdentifier("bookmarks-\(self.id)")
        }
    }
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(dict: [String: AnyObject], context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName("Bookmark", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        id = Int(dict["id"] as! NSNumber)
        title = dict["title"] as! String
        originalLink = dict["original_link"] as! String
        image_url = (dict["img_src"] as? String)!
        host = dict["source"] as! String
        try! context.save()
    }
    
}