//
//  LoginViewController.swift
//  Open Sauce
//
//  Created by Ian Gristock on 24/10/2015.
//  Copyright © 2015 Ian Gristock. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController {
    
    let inputColor = UIColor(red: 207.0/255.0, green: 207.0/255.0, blue: 207.0/255.0, alpha: 0.3)
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var emailTextInput: UITextField! {
        didSet {
            emailTextInput.delegate = self
            emailTextInput.setStyleAndPadding(1, borderColor: inputColor, padding: 15.00, radius: 5, placeHolder: "Email address")
        }
    }
    @IBOutlet weak var passwordTextInput: UITextField! {
        didSet {
            passwordTextInput.delegate = self
            passwordTextInput.setStyleAndPadding(2, borderColor: inputColor, padding: 15.00, radius: 5, placeHolder: "Password")
        }
    }
    @IBOutlet weak var textInputConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var logoTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBAction func registerClicked(sender: AnyObject) {
        self.performSegueWithIdentifier("showRegistration", sender:self)
    }
    
    
    @IBAction func loginClicked(sender: AnyObject) {
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        if (emailTextInput.text!.isEmpty) || (passwordTextInput.text!.isEmpty) {
            activityIndicator.stopAnimating()
            activityIndicator.hidden = true
            let alertController = UIAlertController(title: "Invalid Credentials", message: "Both a username and password must be supplied", preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action:UIAlertAction!) in
            }
            alertController.addAction(OKAction)
            self.presentViewController(alertController, animated: true, completion:nil)
            
        } else {
            OauthApi.sharedInstance().authenticate(emailTextInput.text!, password: passwordTextInput.text!,
                success: {
                    ok in
                    dispatch_async(dispatch_get_main_queue()){
                        self.performSegueWithIdentifier("loginSuccess", sender:self)
                    }
                },
                failure: {
                    error in
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.hidden = true
            })

        }
    }
    
    @IBOutlet weak var passwordInputConstraint: NSLayoutConstraint!
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
       // view.frame.origin.y = -200
       // setupAnimateStart()
        
        
    }
    
    func setupAnimateStart() {
        textInputConstraint.constant -= view.bounds.width
        passwordInputConstraint.constant -= view.bounds.width
        logoTopConstraint.constant -= view.bounds.height
        emailTextInput.alpha = 0.0
        passwordTextInput.alpha = 0.0
        loginButton.alpha = 0.0
        registerButton.alpha = 0.0
        logo.alpha = 0.0
        
    }
    
    func animateEnd() {
        
        UIView.animateWithDuration(0.3, animations: {
            self.logoTopConstraint.constant += self.view.bounds.height
            self.passwordInputConstraint.constant += self.view.bounds.width
            self.passwordTextInput.alpha = 1.0
            self.loginButton.alpha = 1.0
            self.logo.alpha = 1.0
            self.view.layoutIfNeeded()
        })
        UIView.animateWithDuration(0.4, delay: 0.0, options: .CurveEaseOut, animations: {
            self.textInputConstraint.constant += self.view.bounds.width
            self.emailTextInput.alpha = 1.0
            self.registerButton.alpha = 1.0
            self.view.layoutIfNeeded()
            }, completion: { (finished: Bool) in
        })
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //animateEnd()
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidden = true
        modalTransitionStyle = .FlipHorizontal
       
        let blurEffect = UIBlurEffect(style: .Dark)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.frame = backgroundImageView.bounds
        backgroundImageView.addSubview(blurredEffectView)
        
        // Do any additional setup after loading the view.

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
        if passwordTextInput.isFirstResponder() {
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

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension UIView {
    /**
     Set x Position
     
     :param: x CGFloat
     by DaRk-_-D0G
     */
    func setX(x:CGFloat) {
        var frame:CGRect = self.frame
        frame.origin.x = x
        self.frame = frame
    }
    /**
     Set y Position
     
     :param: y CGFloat
     by DaRk-_-D0G
     */
    func setY(y:CGFloat) {
        var frame:CGRect = self.frame
        frame.origin.y = y
        self.frame = frame
    }
    /**
     Set Width
     
     :param: width CGFloat
     by DaRk-_-D0G
     */
    func setWidth(width:CGFloat) {
        var frame:CGRect = self.frame
        frame.size.width = width
        self.frame = frame
    }
    /**
     Set Height
     
     :param: height CGFloat
     by DaRk-_-D0G
     */
    func setHeight(height:CGFloat) {
        var frame:CGRect = self.frame
        frame.size.height = height
        self.frame = frame
    }
}
