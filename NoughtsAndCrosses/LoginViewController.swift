//
//LoginViewController.swift
//  NoughtsAndCrosses
//
//  Created by Jordan Donald on 5/31/16.
//  Copyright © 2016 Julian Hulme. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var emailField: EmailValidatedTextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Login"
        
        //emailField.delegate = self
        //passwordField.delegate = self
        //userInput.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonTapped(sender: UIButton) {
        
        if (!emailField.validate()){
            return
        }
        
        let email = emailField.text!
        let password = passwordField.text!
        
        UserController.sharedInstance.loginUser(email, password: password, presentingViewController: self, viewControllerCompletionFunction: {(user,message) in self.loginCallComplete(user,message:message)})
        
    }
    
    func loginCallComplete(user:User?,message:String?){
        
        if let _ = user   {
            
            //successfully registered
            let alert = UIAlertController(title:"Login Successful", message:"You will now be logged in", preferredStyle: UIAlertControllerStyle.Alert)
            let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: {(action) in
                //when the user clicks "Ok", do the following
                let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.navigateToBoardViewController()
            })
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
            
        }   else    {
            
            //registration failed
            let alert = UIAlertController(title:"Login Failed", message:message!, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: {
                
            })
            
        }
    }
    
    
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        
        print("textfield.text \(textField.text)")
        print ("string \(string)")
        
        return true
    }
    
    
}
