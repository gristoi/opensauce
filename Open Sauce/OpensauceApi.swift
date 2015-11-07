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

class OpensauceApi {
    
    func createUser(username: String, password: String, email: String,  success:([String:AnyObject]) -> () = {_ in}, failure:([String:AnyObject]) -> () = {_ in}) {
        print(username, password, email)
        Alamofire.Manager.sharedInstance.session.configuration
            .HTTPAdditionalHeaders?.updateValue("application/json",
                forKey: "Accept")
        let parameters = [
            "name": username,
            "password": password,
            "email": email
        ]
        let url = "\(Constants.URL)/\(Methods.UserCreate)"
        Alamofire.request(.POST, url, parameters: parameters, encoding: .JSON, headers: ["Accept" : "application/json"])
            .validate()
            .responseJSON {
                response in
                 switch response.result {
                  case .Success:
                    success(response.result.value as! [String:AnyObject])
                    case .Failure:
                        let failureResponse = JSON(data: response.data!)
                    failure(failureResponse.dictionaryObject as [String:AnyObject]!)
            }
        }
    }
    
    func getRecipes(success:([String:AnyObject]) -> () = {_ in}, failure:([String:AnyObject]) -> () = {_ in}) {
        let url = "\(Constants.URL)/\(Methods.GetRecipes)"
        print(url)
        let token = OauthApi.sharedInstance().getToken()!
        let headers = ["Accept" : "application/json",
                       "Authorization" : "Bearer \(token["access_token"]!)" ]
        Alamofire.request(.GET, url, encoding: .JSON, headers:headers )
            .validate()
            .responseJSON {
                response in
                switch response.result {
                case .Success:
                    success(response.result.value as! [String:AnyObject])
                case .Failure:
                    let failureResponse = JSON(data: response.data!)
                    print(failureResponse)
                    failure(failureResponse.dictionaryObject as [String:AnyObject]!)
                }
        }

    }
    

    class func sharedInstance() -> OpensauceApi {
        
        struct Singleton {
            static var sharedInstance = OpensauceApi()
        }
        
        return Singleton.sharedInstance
    }
}

extension OpensauceApi {
    
    struct Constants {
        
        // URL
        static let URL : String = "http://192.168.99.100"
    }
    
    struct Methods {
        static let UserCreate: String = "user/create"
        static let GetRecipes: String = "recipes"
    }
}