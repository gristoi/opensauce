//
//  UITextFieldExtensions.swift
//  Open Sauce
//
//  Created by Ian Gristock on 24/10/2015.
//  Copyright © 2015 Ian Gristock. All rights reserved.
//

import Foundation
import UIKit

// solution found at https://gist.github.com/namanhams/dc3b491557ec6fb12060
extension UITextField {
    func setTextLeftPadding(left:CGFloat) {
        let leftView:UIView = UIView(frame: CGRectMake(0, 0, left, 1))
        leftView.backgroundColor = UIColor.clearColor()
        self.leftView = leftView;
        self.leftViewMode = UITextFieldViewMode.Always;
    }
    
    func setStyleAndPadding(borderWidth: Int, borderColor: UIColor, padding: Float, radius: Int, placeHolder: String ) {
        self.layer.borderWidth = 2
        self.layer.cornerRadius = 5
        let placeholder = NSAttributedString(string: placeHolder, attributes: [NSForegroundColorAttributeName : UIColor.whiteColor()])
        self.attributedPlaceholder = placeholder
        self.layer.borderColor = borderColor.CGColor
        self.setTextLeftPadding(15.00)
    }
}