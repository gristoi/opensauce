//
//  StartingViewController.swift
//  Open Sauce
//
//  Created by Ian Gristock on 28/11/2015.
//  Copyright © 2015 Ian Gristock. All rights reserved.
//

import UIKit

class StartingViewController: UIViewController {

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(false)
        if(OauthApi.sharedInstance().hasToken()) {
            print("has token")
            performSegueWithIdentifier("showApp", sender: nil)
        } else {
            performSegueWithIdentifier("showLogin", sender: nil)
        }
    }
}
