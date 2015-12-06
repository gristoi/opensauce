//
//  RecipeDetailViewController.swift
//  Open Sauce
//
//  Created by Ian Gristock on 19/11/2015.
//  Copyright © 2015 Ian Gristock. All rights reserved.
//

import UIKit

class RecipeDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    var recipe: Recipe?
    
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet var swipeGesture: UISwipeGestureRecognizer!
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var serves: UILabel!
    @IBOutlet weak var difficulty: UILabel!
    @IBOutlet weak var recipeTitleLabel: UILabel!
    
    @IBOutlet weak var toggle: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        recipeTitleLabel.text = recipe?.title
        difficulty.text = recipe?.difficulty
        serves.text = recipe?.serves
        duration.text = recipe?.duration
        
        if recipe?.image != nil {
            self.recipeImage.image = recipe!.image
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func indexChanged(sender: AnyObject) {
        tableView.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if(toggle.selectedSegmentIndex == 0 ) {
            return (recipe!.ingredients!.count)
        }
        return (recipe!.steps!.count)
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("IngredientCell", forIndexPath: indexPath) as! RecipeDetailTableViewCell

        if(toggle.selectedSegmentIndex == 0 ) {
            print(recipe?.ingredients![indexPath.row].name)
            cell.stepNumber!.text = "\(indexPath.row + 1)"
            cell.stepLabel!.text = recipe?.ingredients![indexPath.row].name
                   } else {
            cell.stepNumber!.text = "\(indexPath.row + 1)"
            cell.stepLabel!.text = recipe?.steps![indexPath.row].name
            cell.stepLabel.sizeToFit()

                    }
        
        
        return cell
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

}
