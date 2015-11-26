//
//  Site.swift
//  Open Sauce
//
//  Created by Ian Gristock on 24/11/2015.
//  Copyright © 2015 Ian Gristock. All rights reserved.
//

import Foundation

class Site: NSObject {
    
    var id:Int
    var host: String
    var name:String
    var img_src: String
    
    init(dict:[String:AnyObject]) {
        self.id = dict["id"] as! Int
        self.name = dict["name"] as! String
        self.host = dict["host"] as! String
        self.img_src = dict["img_src"] as! String
    }
}