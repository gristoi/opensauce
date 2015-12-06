//
//  RecipeTableViewController.swift
//  Open Sauce
//
//  Created by Ian Gristock on 04/11/2015.
//  Copyright © 2015 Ian Gristock. All rights reserved.
//

import UIKit
import CoreData

class RecipeTableViewController: UIViewController , NSFetchedResultsControllerDelegate{

    // Keep track of insertions, deletions and updates
    var insertedIndexPaths: [NSIndexPath]!
    var deletedIndexPaths: [NSIndexPath]!
    var updatedIndexPaths: [NSIndexPath]!
    var refreshControl:UIRefreshControl!

    var recipes = [Recipe]()
    @IBOutlet weak var tableView: UITableView!
    @IBAction func showMenu(sender: AnyObject) {
        presentLeftMenuViewController()
    }
    
    //# MARK: - NSFetchedResultsController
    lazy var fetchedResultsController: NSFetchedResultsController = {
        
        let fetchRequest = NSFetchRequest(entityName: "Recipe")
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
        
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
                FudiApi.sharedInstance().getRecipes(self.sharedContext,
                    success: {
                        recipes in
                    
                        CoreDataStackManager.sharedInstance().saveContext()
                        self.refreshControl?.endRefreshing()

                    },
                    failure :
                    {
                        error in
                        self.refreshControl?.endRefreshing()

                    }
                    
                )
                
            }
        }
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl?.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
        
        fetchedResultsController.delegate = self
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 131.00/255.0, green: 28.0/255.0, blue: 81.0/255.0, alpha:1.0)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        
        getRecipes()
       
    }

    func refresh(sender:AnyObject)
    {
            for recipe in fetchedResultsController.fetchedObjects as! [Recipe] {
                if recipe.image != nil {
                    FudiApi.Caches.imageCache.storeImage(nil, withIdentifier: "recipe-\(recipe.id)")
                }
                self.sharedContext.deleteObject(recipe)
            }
            CoreDataStackManager.sharedInstance().saveContext()
            getRecipes()
        }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        
        if (segue.identifier == "showRecipe") {
            
            // initialize new view controller and cast it as your view controller
            let viewController = segue.destinationViewController as! RecipeDetailViewController
            // your new view controller should have property that will store passed value
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)
            let recipe = fetchedResultsController.objectAtIndexPath(indexPath!) as! Recipe
            viewController.recipe = recipe
        
        }
        
    }
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        insertedIndexPaths = [NSIndexPath]()
        deletedIndexPaths = [NSIndexPath]()
        updatedIndexPaths = [NSIndexPath]()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            insertedIndexPaths.append(newIndexPath!)
            break
        case .Delete:
            deletedIndexPaths.append(indexPath!)
            break
        case .Update:
            updatedIndexPaths.append(indexPath!)
            break
        case .Move:
            print("move")
            break
        }
    }
    

    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.reloadData()
    }
}

extension RecipeTableViewController: UITableViewDelegate {
    
    
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
        cell.activityIndicator.activityIndicatorViewStyle = .WhiteLarge
        cell.activityIndicator.startAnimating()
        FudiApi.sharedInstance().getImage(recipe.image_url, completionHandler: {
            responseCode, data in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                let image = UIImage(data: data)
                FudiApi.Caches.imageCache.storeImage(image, withIdentifier: "recipe-\(recipe.id)" )
                // Assign image to image view of cell
                cell.background.image = image
                cell.activityIndicator.stopAnimating()
                cell.activityIndicator.hidden = true
                
            })
            }, errorHandler: {
                error in
                cell.activityIndicator.stopAnimating()
                cell.activityIndicator.hidden = true
        });
        cell.serves.text = recipe.serves
        cell.difficulty.text = recipe.difficulty
        cell.duration.text = recipe.duration.isEmpty ? "no duration": recipe.duration
        
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            let recipe = fetchedResultsController.objectAtIndexPath(indexPath) as! Recipe
            sharedContext.deleteObject(recipe)
        }
    }
}