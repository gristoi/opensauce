//
//  AuthApi.swift
//  Open Sauce
//
//  Created by Ian Gristock on 28/10/2015.
//  Copyright © 2015 Ian Gristock. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class OauthApi {
    
    func authenticate(username: String, password: String, success:(Bool) -> () = {_ in}, failure:(String) -> () = {_ in}) {
        let parameters = [
            "username": username,
            "password": password,
            "client_id": Constants.ClientId,
            "client_secret": Constants.ClientSecret,
            "grant_type": Constants.GrantType
        ]
        Alamofire.request(.POST, Constants.URL, parameters: parameters).validate().responseJSON{
            response in
            switch response.result {
            case .Success:
                self.storeToken(response.result.value as! [String:AnyObject])
                success(true)
            case .Failure(let error):
                failure("Incorrect username or password")
                print(error)
            }
        }
    }
    
    func storeToken(token: [String:AnyObject] ) {
        NSUserDefaults.standardUserDefaults().setObject(token, forKey: "oauth")
    }
    
    func getToken() -> NSDictionary? {
        if (NSUserDefaults.standardUserDefaults().objectForKey("oauth") != nil) {
            
            let token: NSDictionary! = NSUserDefaults.standardUserDefaults().objectForKey("oauth") as! NSDictionary
            return token
        }
        return nil
    }
    
    func hasToken() -> Bool {
        return NSUserDefaults.standardUserDefaults().objectForKey("oauth") as? NSDictionary != nil
    }
    func clearToken() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.removeObjectForKey("oauth")
        userDefaults.synchronize()
    }
    
    class func sharedInstance() -> OauthApi {
        
        struct Singleton {
            static var sharedInstance = OauthApi()
        }
        
        return Singleton.sharedInstance
    }
}

extension OauthApi {
    
    struct Constants {
        
        // URL
        static let URL : String = "http://178.62.26.224/oauth/access_token"
        static let ClientId: String = "5a85e4c949a366baa97509f306b9d3cdfd21efa8"
        static let ClientSecret: String = "51953aa2387722c31d3e9a4dfa53c1834e8d0e52"
        static let GrantType: String = "password"
    }

}