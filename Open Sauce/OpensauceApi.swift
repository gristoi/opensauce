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
import CoreData
class OpensauceApi:NSObject {
    
    // Session object
    var session: NSURLSession
    
    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }
    
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
                        print(response)
                        let failureResponse = JSON(data: response.data!)
                    failure(failureResponse.dictionaryObject as [String:AnyObject]!)
            }
        }
    }
    
    func getRecipes(context: NSManagedObjectContext, success:([Recipe]) -> () = {_ in}, failure:([String:AnyObject]) -> () = {_ in}) {
        let url = "\(Constants.URL)/\(Methods.GetRecipes)"
        print(url)
        let token = OauthApi.sharedInstance().getToken()!
        let headers = ["Accept" : "application/json",
                       "Authorization" : "Bearer \(token["access_token"]!)" ]
        
        Alamofire.request(.GET, url, encoding: .JSON, headers:headers )
            .validate()
            .responseJSON {
                response in
                dispatch_async(dispatch_get_main_queue(), {
                switch response.result {
                case .Success(let JSON):
                    
                    var recipeArray = [Recipe]()
                    let recipes = JSON["data"] as! [[String:AnyObject]]
                    for recipe in recipes {
                        let newRecipe = Recipe(dict:recipe, context:context)
                        let ingredients = recipe["ingredients"] as! [String:AnyObject]
                        let ingredientdata = ingredients["data"] as! [[String:AnyObject]]
                        for ingredient in ingredientdata {
                            let ing = ingredient as [String: AnyObject]
                            let id = ing["id"] as! Int
                            let title = ing["title"] as! String
                            let _ = Ingredient(id:id, name: title, recipe: newRecipe, context:context)
                        }
                        let steps = recipe["steps"] as! [String:AnyObject]
                        let stepdata = steps["data"] as! [[String:AnyObject]]
                        for step in stepdata {
                            let s = step as [String: AnyObject]
                            let stepId = s["id"] as! Int
                            let stepTitle = s["title"] as! String
                            let _ = Step(id:stepId, name: stepTitle, recipe: newRecipe, context: context)
                        }
                        recipeArray.append(newRecipe)
                        success(recipeArray)
                       
                    }

                case .Failure:
                    let failureResponse = JSON(data: response.data!)
                    print(response)
                    failure(failureResponse.dictionaryObject as [String:AnyObject]!)
                    
                }
                        })
        }

    }
    
    func getBookmarks(success:([[String:AnyObject]]) -> () = {_ in}, failure:([String:AnyObject]) -> () = {_ in}) {
        let url = "\(Constants.URL)/\(Methods.GetBookmarks)"
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
                    success(response.result.value!["data"]! as! [[String:AnyObject]])
                case .Failure:
                    let failureResponse = JSON(data: response.data!)
                    print(failureResponse)
                    failure(failureResponse.dictionaryObject as [String:AnyObject]!)
                }
        }
        
    }
    
    func getSites(success:([[String:AnyObject]]) -> () = {_ in}, failure:([String:AnyObject]) -> () = {_ in}) {
        let url = "\(Constants.URL)/\(Methods.GetSites)"
        let token = OauthApi.sharedInstance().getToken()!
        let headers = ["Accept" : "application/json",
            "Authorization" : "Bearer \(token["access_token"]!)" ]
        
        Alamofire.request(.GET, url, encoding: .JSON, headers:headers )
            .validate()
            .responseJSON {
                response in
                switch response.result {
                case .Success:
                    success(response.result.value!["data"]! as! [[String:AnyObject]])
                case .Failure:
                    let failureResponse = JSON(data: response.data!)
                    print(failureResponse)
                    failure(failureResponse.dictionaryObject as [String:AnyObject]!)
                }
        }
        
    }
    
    func scrapeRecipe(site: String, success:([String:AnyObject]) -> () = {_ in}, failure:([String:AnyObject]) -> () = {_ in})
    {
        let url = "\(Constants.URL)/\(Methods.ScrapeRecipe)"
        print(url)
        let token = OauthApi.sharedInstance().getToken()!
        let headers = ["Accept" : "application/json",
            "Authorization" : "Bearer \(token["access_token"]!)" ]
        let parameters = ["site" : site]
        print(parameters)
        Alamofire.request(.POST, url, encoding: .JSON, headers:headers, parameters:parameters )
            .validate()
            .responseJSON {
                response in
                print(response)
                switch response.result {
                case .Success:
                   success(response.result.value! as! [String:AnyObject])
                    
                case .Failure:
                    failure(["response": "Cannot save recipe"])
                }
        }

    }
    
    func saveBookmark(site: String, title: String,  image_url: String,  success:([String:AnyObject]) -> () = {_ in}, failure:([String:AnyObject]) -> () = {_ in})
    {
        let url = "\(Constants.URL)/\(Methods.PostBookmarks)"
        let token = OauthApi.sharedInstance().getToken()!
        let headers = ["Accept" : "application/json",
            "Authorization" : "Bearer \(token["access_token"]!)" ]
        let parameters = ["site" : site, "title": title, "image_url": image_url]
        Alamofire.request(.POST, url, encoding: .JSON, headers:headers, parameters:parameters )
            .validate()
            .responseJSON {
                response in
                print(response.data)
                switch response.result {
                case .Success:
                    success(response.result.value! as! [String:AnyObject])
                    
                case .Failure:
                    failure(["response": "Cannot save bookmark"])
                }
        }
        
    }
    
    func scrapeBookmarkImages(site: String, success:([[String:AnyObject]]) -> () = {_ in}, failure:([String:AnyObject]) -> () = {_ in})
    {
        let url = "\(Constants.URL)/\(Methods.ScrapeBookmarkImages)"
        print(url)
        let token = OauthApi.sharedInstance().getToken()!
        let headers = ["Accept" : "application/json",
            "Authorization" : "Bearer \(token["access_token"]!)" ]
        let parameters = ["site" : site]
        print(parameters)
        Alamofire.request(.POST, url, encoding: .JSON, headers:headers, parameters:parameters )
            .validate()
            .responseJSON {
                response in
                print(response)
                switch response.result {
                case .Success:
                    success(response.result.value! as! [[String:AnyObject]])
                    
                case .Failure:
                    failure(["response": "Cannot save recipe"])
                }
        }
        
    }
    
    func getImage(imageSrc: String, completionHandler:(Int, NSData) -> (), errorHandler:(String) -> ()) -> NSURLSessionTask {
        let url = NSURL(string: imageSrc)!
        
        let request = NSURLRequest(URL: url)
        
        let task = session.dataTaskWithRequest(request) {data, response, downloadError in
            
            if let _ = downloadError {
                errorHandler("failed to download image")
            } else {
                completionHandler(200, data!)
            }
        }
        
        task.resume()
        
        return task
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
        static let ScrapeRecipe: String = "recipes/scrape"
        static let GetSites: String = "recipes/sites"
        static let GetBookmarks: String = "recipes/bookmarks"
        static let PostBookmarks: String = "recipes/bookmarks"
        static let ScrapeBookmarkImages: String = "recipes/scrape/images"
    }
    struct Caches {
        static let imageCache = ImageCache()
    }
}