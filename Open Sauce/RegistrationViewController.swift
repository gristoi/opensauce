//
//  RegistrationViewController.swift
//  Open Sauce
//
//  Created by Ian Gristock on 31/10/2015.
//  Copyright © 2015 Ian Gristock. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController {

    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBOutlet weak var usernameInput: UITextField!
    
    @IBOutlet weak var passwordInput: UITextField!
    
    @IBOutlet weak var emailInput: UITextField!
    
    @IBOutlet weak var signupBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        modalTransitionStyle = .FlipHorizontal
        let blurEffect = UIBlurEffect(style: .Dark)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.frame = backgroundImage.bounds
        backgroundImage.addSubview(blurredEffectView)
        let inputColor = UIColor(red: 207.0/255.0, green: 207.0/255.0, blue: 207.0/255.0, alpha: 0.3)
        emailInput.setStyleAndPadding(1, borderColor: inputColor, padding: 15.00, radius: 5, placeHolder: "Email address")
        passwordInput.setStyleAndPadding(2, borderColor: inputColor, padding: 15.00, radius: 5, placeHolder: "Password")
        usernameInput.setStyleAndPadding(2, borderColor: inputColor, padding: 15.00, radius: 5, placeHolder: "Username")
    }

    @IBAction func signupBtnClicked(sender: AnyObject) {
        OpensauceApi.sharedInstance().createUser(usernameInput.text!, password: passwordInput.text!, email: emailInput.text!,
            success: {
                data in
                print(data)
            },
            failure: {
                error in
                print(error)
        })

    }
}
