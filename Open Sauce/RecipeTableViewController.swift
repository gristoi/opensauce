//
//  RecipeTableViewController.swift
//  Open Sauce
//
//  Created by Ian Gristock on 04/11/2015.
//  Copyright © 2015 Ian Gristock. All rights reserved.
//

import UIKit
import CoreData

class RecipeTableViewController: UIViewController , UITableViewDelegate, NSFetchedResultsControllerDelegate{

    // Keep track of insertions, deletions and updates
    var insertedIndexPaths: [NSIndexPath]!
    var deletedIndexPaths: [NSIndexPath]!
    var updatedIndexPaths: [NSIndexPath]!

    var recipes = [Recipe]()
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func showMenu(sender: AnyObject) {
        presentLeftMenuViewController()
    }
    
    //# MARK: - NSFetchedResultsController
    lazy var fetchedResultsController: NSFetchedResultsController = {
        
        let fetchRequest = NSFetchRequest(entityName: "Recipe")
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
            managedObjectContext: self.sharedContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        return fetchedResultsController
        
    }()
    
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext!
    }
    

    
    func getRecipes() {
        do {
            try fetchedResultsController.performFetch()
            print("herererere")
        } catch let error as NSError {
            print(error)
        }
        if let foundRecipes = fetchedResultsController.fetchedObjects as? [Recipe] {
            if foundRecipes.isEmpty {
                OpensauceApi.sharedInstance().getRecipes(
                    {
                        recipes in
                        print(recipes as [[String:AnyObject]])
                        for recipe in recipes {
                            let newRecipe = Recipe(dict:recipe, context:self.sharedContext)
                            let ingredients = recipe["ingredients"] as! [String:AnyObject]
                            let ingredientdata = ingredients["data"] as! [[String:AnyObject]]
                            for ingredient in ingredientdata {
                                let ing = ingredient as [String: AnyObject]
                                let id = ing["id"] as! Int
                                let title = ing["title"] as! String
                                let _ = Ingredient(id:id, name: title, recipe: newRecipe, context: self.sharedContext )
                            }
                            let steps = recipe["steps"] as! [String:AnyObject]
                            let stepdata = steps["data"] as! [[String:AnyObject]]
                            for step in stepdata {
                                let s = step as [String: AnyObject]
                                let stepId = s["id"] as! Int
                                let stepTitle = s["title"] as! String
                                let _ = Step(id:stepId, name: stepTitle, recipe: newRecipe, context: self.sharedContext )
                            }
                            CoreDataStackManager.sharedInstance().saveContext()
                        }

                    },
                    failure :
                    {
                        error in
                    }
                    
                )
                
            }
        }
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 131.00/255.0, green: 28.0/255.0, blue: 81.0/255.0, alpha:1.0)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        getRecipes()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RecipeListTableViewCell", forIndexPath: indexPath) as! RecipeListTableViewCell
        
        
        let recipe = fetchedResultsController.objectAtIndexPath(indexPath) as! Recipe
            cell.recipeTitle?.text = recipe.title
            cell.background.image = UIImage(named:"sushi")
        
        
        OpensauceApi.sharedInstance().getImage(recipe.image_url, completionHandler: {
            responseCode, data in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                let image = UIImage(data: data)
                OpensauceApi.Caches.imageCache.storeImage(image, withIdentifier: "recipe-\(recipe.id)" )
                // Assign image to image view of cell
                cell.background.image = image
                
            })
            }, errorHandler: {
                error in
                print(error)
        });
            cell.serves.text = recipe.serves
            cell.difficulty.text = recipe.difficulty
            cell.duration.text = recipe.duration
        //cell.profilePic.image = UIImage(named:"sushi")
        // Configure the cell...

        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        
        if (segue.identifier == "showRecipe") {
            
            // initialize new view controller and cast it as your view controller
            let viewController = segue.destinationViewController as! RecipeDetailViewController
            // your new view controller should have property that will store passed value
            let selectedRow = tableView.indexPathForSelectedRow!
            let recipe = fetchedResultsController.objectAtIndexPath(selectedRow) as! Recipe
            viewController.recipe = recipe
        }
        
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            // handle delete (by removing the data from your array and updating the tableview)
        }
    }
}