//
//  EmailValidatedTextField.swift
//  NoughtsAndCrosses
//
//  Created by Jordan Donald on 6/1/16.
//  Copyright © 2016 Julian Hulme. All rights reserved.
//

import UIKit

class EmailValidatedTextField: UITextField, UITextFieldDelegate {

    //instantiating the UIImageView variable
    var imageView: UIImageView = UIImageView()
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    
        imageView = UIImageView(frame: CGRectMake(self.frame.width-30, 5, 22, 22))
        self.addSubview(imageView)
        
        self.delegate = self
                                
    }
    
    var message = ""
    


    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        if string == "" {
            message.removeAtIndex(message.endIndex.predecessor())
        }
        else {
            message = message + string
        }
        
        
        print("textfield.text \(textField.text)")
        print ("string \(string)")
        
        self.UIUpdate()
        
        return true
    }

    
    
    private func valid() -> Bool {
        
        print("Validating email: \(self.text!)")
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(message)
        
    }
    
    func UIUpdate() {
        
        if (self.valid()){
            imageView.image = UIImage(named:"input_valid")
            
        }
        else {
            imageView.image = UIImage(named:"input_invalid")
        }
        
    }
    
    func validate () -> Bool {
        
        self.UIUpdate()
        return self.valid()
    }
    
}
