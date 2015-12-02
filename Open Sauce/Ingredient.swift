//
//  Ingredient.swift
//  Open Sauce
//
//  Created by Ian Gristock on 09/11/2015.
//  Copyright © 2015 Ian Gristock. All rights reserved.
//

import Foundation
import CoreData

class Ingredient: NSManagedObject {
    
    @NSManaged var id:NSNumber
    @NSManaged var name:String
    @NSManaged var recipe: Recipe
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(id: Int, name: String, recipe: Recipe,  context: NSManagedObjectContext) {
        
        let entity = NSEntityDescription.entityForName("Ingredient", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        self.id = Int(id as NSNumber)
        self.name = name
        self.recipe = recipe
    }
}