//
//  RegistrationViewController.swift
//  Open Sauce
//
//  Created by Ian Gristock on 31/10/2015.
//  Copyright © 2015 Ian Gristock. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBOutlet weak var usernameInput: UITextField!{
        didSet {
            usernameInput.setTextLeftPadding(35.0)
            let placeholder = NSAttributedString(string:  "Username", attributes: [NSForegroundColorAttributeName : UIColor.whiteColor()])
            usernameInput.attributedPlaceholder = placeholder
            //  emailTextInput.setStyleAndPadding(1, padding: 25.00, radius: 5, placeHolder: "Email address")
        }
    }

    
    @IBOutlet weak var passwordInput: UITextField!{
        didSet {
            passwordInput.delegate = self
            passwordInput.setTextLeftPadding(35.0)
            let placeholder = NSAttributedString(string:  "Password", attributes: [NSForegroundColorAttributeName : UIColor.whiteColor()])
            passwordInput.attributedPlaceholder = placeholder
            //  emailTextInput.setStyleAndPadding(1, padding: 25.00, radius: 5, placeHolder: "Email address")
        }
    }

    
    @IBOutlet weak var emailInput: UITextField! {
        didSet {
            emailInput.setTextLeftPadding(35.0)
            let placeholder = NSAttributedString(string:  "Email address", attributes: [NSForegroundColorAttributeName : UIColor.whiteColor()])
            emailInput.attributedPlaceholder = placeholder
            //  emailTextInput.setStyleAndPadding(1, padding: 25.00, radius: 5, placeHolder: "Email address")
        }
    }

    
    @IBOutlet weak var signupBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidden = true
        modalTransitionStyle = .CrossDissolve
    
    }

    @IBAction func signupBtnClicked(sender: AnyObject) {
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        if (emailInput.text!.isEmpty) || (passwordInput.text!.isEmpty || usernameInput.text!.isEmpty) {
            activityIndicator.stopAnimating()
            activityIndicator.hidden = true
            let alertController = UIAlertController(title: "Invalid Parameters", message: "No fields can be empty", preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action:UIAlertAction!) in
            }
            alertController.addAction(OKAction)
            self.presentViewController(alertController, animated: true, completion:nil)
            
        } else {

        OpensauceApi.sharedInstance().createUser(usernameInput.text!, password: passwordInput.text!, email: emailInput.text!,
            success: {
                data in
                let alertController = UIAlertController(title: "Successfully registered!!", message: "Thank you for registering. please log in to continue", preferredStyle: .Alert)
                let OKAction = UIAlertAction(title: "OK", style: .Default) { (action:UIAlertAction!) in
                    dispatch_async(dispatch_get_main_queue()){
                    self.performSegueWithIdentifier("backToLogin", sender: self)
                    }
                }
                alertController.addAction(OKAction)
                self.activityIndicator.hidden = true
                self.activityIndicator.stopAnimating()
                self.presentViewController(alertController, animated: true, completion:nil)
            },
            failure: {
                error in
                let alertController = UIAlertController(title: "Could not register", message: "There was an issue registering", preferredStyle: .Alert)
                let OKAction = UIAlertAction(title: "OK", style: .Default) { (action:UIAlertAction!) in
                }
                self.activityIndicator.hidden = true
                self.activityIndicator.stopAnimating()
                alertController.addAction(OKAction)
                self.presentViewController(alertController, animated: true, completion:nil)
        })
            
        }

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        
        
    }
    
    //MARK: keyboard subscriber methods
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        
    }

    
    func keyboardWillShow(notification: NSNotification) {
        if passwordInput.isFirstResponder() {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
}

extension RegistrationViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
