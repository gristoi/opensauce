//
//  BookmarkTableViewController.swift
//  Open Sauce
//
//  Created by Ian Gristock on 25/11/2015.
//  Copyright © 2015 Ian Gristock. All rights reserved.
//

import UIKit
import CoreData

class BookmarkTableViewController: UIViewController {

    // Keep track of insertions, deletions and updates
    var insertedIndexPaths: [NSIndexPath]!
    var deletedIndexPaths: [NSIndexPath]!
    var updatedIndexPaths: [NSIndexPath]!
    var refreshControl:UIRefreshControl!
    @IBOutlet weak var collectionView: UICollectionView!
        
    //# MARK: - NSFetchedResultsController
    lazy var fetchedResultsController: NSFetchedResultsController = {
        
        let fetchRequest = NSFetchRequest(entityName: "Bookmark")
        
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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 131.00/255.0, green: 28.0/255.0, blue: 81.0/255.0, alpha:1.0)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl?.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.collectionView.addSubview(refreshControl)
        
        fetchedResultsController.delegate = self
        getBookmarks()
    }
    
    
    func refresh(sender:AnyObject)
    {
        for bookmark in fetchedResultsController.fetchedObjects as! [Bookmark] {
            if bookmark.image != nil {
                FudiApi.Caches.imageCache.storeImage(nil, withIdentifier: "bookmarks-\(bookmark.id)")
            }
            self.sharedContext.deleteObject(bookmark)
        }
        CoreDataStackManager.sharedInstance().saveContext()
        getBookmarks()
    }
    
    func getBookmarks() {
        do {
            try fetchedResultsController.performFetch()
            
        } catch let error as NSError {
            print(error)
        }
        if let foundBookmarks = fetchedResultsController.fetchedObjects as? [Bookmark] {

            if foundBookmarks.isEmpty {
                FudiApi.sharedInstance().getBookmarks(self.sharedContext,
                    success: {
                        bookmarks in
                        CoreDataStackManager.sharedInstance().saveContext()
                        self.refreshControl?.endRefreshing()
                    },
                    failure :
                    {
                        error in
                        self.refreshControl?.endRefreshing()
                        let message = error["Error"] as! String
                        self.refreshControl?.endRefreshing()
                        let alertController = UIAlertController(title: "Error getting bookmarks", message:message, preferredStyle: .Alert)
                        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action:UIAlertAction!) in
                        }
                        alertController.addAction(OKAction)
                        self.presentViewController(alertController, animated: true, completion:nil)
                    }
                    
                )
                
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){

        if (segue.identifier == "showBookmark") {
            
            // initialize new view controller and cast it as your view controller
            let viewController = segue.destinationViewController as! BookmarkDetailViewController
            let cell = sender as! UICollectionViewCell
            let indexPath = collectionView.indexPathForCell(cell)
            let bookmark = fetchedResultsController.objectAtIndexPath(indexPath!) as! Bookmark
            viewController.url = NSURL(string: bookmark.originalLink)

        }
        
    }
    

}

extension BookmarkTableViewController: NSFetchedResultsControllerDelegate{
    
    
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

extension BookmarkTableViewController: UICollectionViewDelegate, UICollectionViewDataSource
{
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("InspirationCell", forIndexPath: indexPath) as! InspirationCell
        let bookmark = fetchedResultsController.objectAtIndexPath(indexPath) as! Bookmark
        
        cell.bookmark = bookmark
        return cell
    }
}