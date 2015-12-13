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
     @IBOutlet weak var collectionView: UICollectionView!
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
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
                        let message = error["Error"] as! String
                        self.refreshControl?.endRefreshing()
                        let alertController = UIAlertController(title: "Error getting recipes", message:message, preferredStyle: .Alert)
                        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action:UIAlertAction!) in
                        }
                        alertController.addAction(OKAction)
                        self.presentViewController(alertController, animated: true, completion:nil)
                        
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
        self.collectionView.addSubview(refreshControl)
        collectionView!.decelerationRate = UIScrollViewDecelerationRateFast

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
            let cell = sender as! UICollectionViewCell
            let indexPath = collectionView.indexPathForCell(cell)
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
        collectionView.reloadData()
    }
}

extension RecipeTableViewController: UICollectionViewDelegate, UICollectionViewDataSource
{
        
        func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
            return 1
        }
        
        func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return fetchedResultsController.fetchedObjects?.count ?? 0
        }
        
        func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("InspirationCell", forIndexPath: indexPath) as! InspirationCell
            let recipe = fetchedResultsController.objectAtIndexPath(indexPath) as! Recipe

            cell.recipe = recipe
            return cell
        }
}