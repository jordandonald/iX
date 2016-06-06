//
//  UserController.swift
//  Onboarding
//
//  Created by Josh Broomberg on 2016/05/28.
//  Copyright © 2016 iXperience. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct User {
    var email: String
    var password: String
    var token:String
    var client:String
    
    //default contructor
    init(email:String, password:String, token:String, client:String)  {
        self.email = email
        self.password = password
        self.token = token
        self.client = client
    }
    
    //constructor from JSON
    init(json:JSON)  {
        //        print("json init")
        self.email = json["email"].stringValue
        self.client = json["client"].stringValue
        self.token = json["token"].stringValue
        self.password = json["password"].stringValue
        
    }
    
}


class UserController: WebService {
    
    class var sharedInstance: UserController {
        struct Static {
            static var instance:UserController?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token)    {
            Static.instance = UserController()
        }
        return Static.instance!
    }
    
    //private var users: [User] = []
    
    var logged_in_user: User?
    
    func loginUser(email:String, password:String, presentingViewController:UIViewController? = nil, viewControllerCompletionFunction:(User?,String?) -> ()) {
        
        let user = ["email":email,"password":password]
        
        let request = self.createMutableAnonRequest(NSURL(string: "https://ox-backend.herokuapp.com/auth/sign_in"), method: "POST", parameters: user)
        
        self.executeRequest(request, presentingViewController:presentingViewController, requestCompletionFunction: {(responseCode, json) in
            
            print( json)
            var user:User = User(email: "", password: "",token:"", client: "")
            
            
            if (responseCode / 100 == 2)   {
                
                user = User(email: json["data"]["email"].stringValue,password:"not_given_and_not_stored",token:json["data"]["token"].stringValue,client:"||")
                
                //Persist
                self.storeUser(user)
                self.setLoggedInUser(user)
                self.logged_in_user = user
                
                
                viewControllerCompletionFunction(user,nil)
            }   else    {
                
                let errorMessage = json["errors"]["full_messages"][0].stringValue
                
                viewControllerCompletionFunction(nil,errorMessage)
            }
        
            viewControllerCompletionFunction(user,nil)
        })
        
    }
    
    
    func registerUser(email:String, password:String, presentingViewController:UIViewController? = nil, viewControllerCompletionFunction:(User?,String?) -> ()) {
        
        let user = ["email":email,"password":password]
        
        let request = self.createMutableAnonRequest(NSURL(string: "https://ox-backend.herokuapp.com/auth"), method: "POST", parameters: user)
        
        self.executeRequest(request, presentingViewController:presentingViewController, requestCompletionFunction: {(responseCode, json) in
            
            //Here is our completion closure for the web request. when the web service is done, this is what is executed.
            //Not only is the code in this block executed, but we are given 2 input parameters, int and JSON.
            //int is the response code from the server.
            //JSON is the response data received
            
            print( json)
            var user:User = User(email: "", password: "",token:"", client: "")
            
            
            if (responseCode / 100 == 2)   { //if the responseCode is 2xx (any responseCode in the 200's range is a success case. For example, some servers return 201 for successful object creation)
                //successfully registered user. get the obtained data from the json response data and create the user object to give back to the calling ViewController
                user = User(email: json["data"]["email"].stringValue,password:"not_given_and_not_stored",token:json["data"]["token"].stringValue,client:"||")
                
                //we need to get our user security token out of the request's header (remember from Postman, we need those values when making in app calls)
                
                
                
                
                //Persist
                self.storeUser(user)
                self.setLoggedInUser(user)
                self.logged_in_user = user
                
                //Note that our registerUser function 4 parameters: email, password, presentingViewController and requestCompletionFunction
                //requestCompletionFunction is a closure for what is to happen in the ViewController when we are done with the webservice.
                
                //lets execute that closure now - Lets me be clear. This is 1 step more advanced than normal. We are executing a closure inside a closure (we are executing the viewControllerCompletionFunction from within the requestCompletionFunction.
                viewControllerCompletionFunction(user,nil)
            }   else    {
                //the web service to create a user failed. Lets extract the error message to be displayed
                
                let errorMessage = json["errors"]["full_messages"][0].stringValue
                
                //execute the closure in the ViewController
                viewControllerCompletionFunction(nil,errorMessage)
            }
            
            
            //Not that our registerUser function 4 parameters: email, password, presentingViewController and completion
            //completion is a closure for what is to happen in the ViewController when we are done with the webservice.
            //lets go back to that closure now
            viewControllerCompletionFunction(user,nil)
        })
        
        //we are now done with the registerUser function. Note that this function doesnt return anything. But because of the viewControllerCompletionFunction closure we are given as an input parameter, we can set in motion a function in the calling class when it is needed.
        
    }
    
    
    //MARK:- User Persistence Functions
    func storeUser(user:User)    {
        
        let userDict = ["email":user.email, "token":user.token, "password":user.password,"client":user.client]
        NSUserDefaults.standardUserDefaults().setObject(userDict, forKey:user.email)
        
        
    }
    
    func setLoggedInUser(user:User)    {
        
        NSUserDefaults.standardUserDefaults().setObject(user.email, forKey: "loggedInUser")
        
    }
    
    func getLoggedInUser()  -> User?    {
        
        if let userId = NSUserDefaults.standardUserDefaults().stringForKey("loggedInUser")    {
            //a user is logged in, return the User object for this user id
            return self.getStoredUser(userId)
        }   else    {
            //else user not found
            return nil
        }
        
    }
    
    func getStoredUser(id:String) -> User?    {
        
        if let userDict:Dictionary = NSUserDefaults.standardUserDefaults().objectForKey(id) as? Dictionary<String, String>   {
            //user found
            let user = User(email: id, password: userDict["password"]!, token: userDict["token"]!, client:userDict["client"]!)
            
            return user
        }   else    {
            //else user not found
            return nil
        }
        
    }
}