//
//  PopupViewController.swift
//  Open Sauce
//
//  Created by Ian Gristock on 28/11/2015.
//  Copyright © 2015 Ian Gristock. All rights reserved.
//

import UIKit

class PopupViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var recipeUrl: String!
    
    @IBOutlet weak var addATitle: UILabel!
    
    @IBOutlet weak var checkImage: UIImageView!
    
    @IBOutlet weak var bookmarkTitle: UITextField!
    @IBOutlet weak var savingRecipeTitle: UILabel!
    
    @IBAction func saveBookmarkClicked(sender: AnyObject) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doneButton.hidden = true
        addATitle.hidden = true
        bookmarkTitle.hidden = true
        checkImage.hidden = true
        getRecipe()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var doneButton: UIButton!
    
    
    @IBAction func doneClicked(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    func getRecipe() {
        activityIndicator.startAnimating()
                OpensauceApi.sharedInstance().scrapeRecipe(recipeUrl,
                    success: {
                        data in
                        self.doneButton.hidden = false
                        self.activityIndicator.stopAnimating()
                        self.activityIndicator.hidden = true
                        self.savingRecipeTitle.text = "Recipe saved successfully !!"
                        self.checkImage.hidden = false
        
                    }, failure: {
                        error in
                        self.savingRecipeTitle.text = "Could not save recipe."
                        self.activityIndicator.stopAnimating()
                        self.activityIndicator.hidden = true
                        
                })

    }

}
