//
//  Step.swift
//  Open Sauce
//
//  Created by Ian Gristock on 09/11/2015.
//  Copyright © 2015 Ian Gristock. All rights reserved.
//

import Foundation

class Step: NSObject {
    
    var id:Int
    var name:String
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}