//
//  LoginViewController.swift
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
        
        if ((email == "") || (password == "")) {
            let alertController = UIAlertController(title: "WARNING", message: "Please complete the form!", preferredStyle: .Alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            
            alertController.addAction(OKAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
            
        else {
            
            let (failureMessage, user) = UserController.sharedInstance.loginUser(email, suppliedPassword: password)
            
            
            if (user != nil) {
                let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.navigateToBoardViewController()
                
            }
            else {
                if let failureMessageObj = failureMessage {
                    let alertController = UIAlertController(title: "WARNING", message: failureMessage, preferredStyle: .Alert)
                    
                    let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    
                    alertController.addAction(OKAction)
                    
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            }
        }
        
    }


    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        
        print("textfield.text \(textField.text)")
        print ("string \(string)")
        
        return true
    }
    
    
}
