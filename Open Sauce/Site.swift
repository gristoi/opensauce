//
//  Site.swift
//  Open Sauce
//
//  Created by Ian Gristock on 24/11/2015.
//  Copyright © 2015 Ian Gristock. All rights reserved.
//

import Foundation
import CoreData

class Site:  NSManagedObject {
    
   @NSManaged var id:NSNumber
   @NSManaged var host: String
   @NSManaged var name:String
   @NSManaged var img_src: String
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(dict:[String:AnyObject], context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName("Site", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        let theID = dict["id"] as! NSNumber
        name = dict["name"] as! String
        host = dict["host"] as! String
        img_src = dict["img_src"] as! String
        id = Int(theID)
        try! context.save()

    }
}