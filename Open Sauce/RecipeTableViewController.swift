//
//  RecipeTableViewController.swift
//  Open Sauce
//
//  Created by Ian Gristock on 04/11/2015.
//  Copyright © 2015 Ian Gristock. All rights reserved.
//

import UIKit

class RecipeTableViewController: UIViewController , UITableViewDelegate{

    var recipes = [Recipe]()
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func showMenu(sender: AnyObject) {
        presentLeftMenuViewController()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 131.00/255.0, green: 28.0/255.0, blue: 81.0/255.0, alpha:1.0)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        OpensauceApi.sharedInstance().getRecipes(
            {
                data in
                for recipe :[String:AnyObject] in data {
                    self.recipes.append(Recipe(dict: recipe))
                }
                self.tableView.reloadData()
            },
            failure:{
                error in
                print(error)
        })

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
        return recipes.count
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RecipeListTableViewCell", forIndexPath: indexPath) as! RecipeListTableViewCell
            cell.recipeTitle?.text = recipes[indexPath.row].title
            cell.background.image = UIImage(named:"sushi")
        OpensauceApi.sharedInstance().getImage(recipes[indexPath.row].image_url, completionHandler: {
            responseCode, data in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                let image = UIImage(data: data)
                OpensauceApi.Caches.imageCache.storeImage(image, withIdentifier: "\(self.recipes[indexPath.row].id)" )
                // Assign image to image view of cell
                cell.background.image = image
                
            })
            }, errorHandler: {
                error in
                print(error)
        });
            cell.serves.text = recipes[indexPath.row].serves
            cell.difficulty.text = recipes[indexPath.row].difficulty
            cell.duration.text = recipes[indexPath.row].duration
        //cell.profilePic.image = UIImage(named:"sushi")
        // Configure the cell...

        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        
        if (segue.identifier == "showRecipe") {
            
            // initialize new view controller and cast it as your view controller
            let viewController = segue.destinationViewController as! RecipeDetailViewController
            // your new view controller should have property that will store passed value
            let selectedRow = tableView.indexPathForSelectedRow!.row
            viewController.recipe = recipes[selectedRow]
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
