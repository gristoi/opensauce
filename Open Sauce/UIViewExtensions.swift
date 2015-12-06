//
//  UIViewExtensions.swift
//  Fudi
//
//  Created by Ian Gristock on 04/12/2015.
//  Copyright © 2015 Ian Gristock. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func layerGradient() {
        let layer : CAGradientLayer = CAGradientLayer()
        layer.frame.size = self.frame.size
        layer.frame.origin = CGPointMake(0.0,0.0)
        
        let color0 = UIColor(red:0/255, green:0/255, blue:0/255, alpha:0.1).CGColor
        let color1 = UIColor(red:0/255, green:0/255, blue:0/255, alpha:0.3).CGColor
        
        layer.colors = [color0,color1]
        self.layer.insertSublayer(layer, atIndex: 0)
    }
}