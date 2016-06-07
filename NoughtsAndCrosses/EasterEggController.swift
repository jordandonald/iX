//
//  EasterEggController.swift
//  NoughtsAndCrosses
//
//  Created by Jordan Donald on 6/1/16.
//  Copyright © 2016 Julian Hulme. All rights reserved.
//

import Foundation
import UIKit

class EasterEggController: NSObject, UIGestureRecognizerDelegate
{
    
    
    var key = ["rightSwipe", "downSwipe"]
    var index = 0
    
    
    enum gesture
    {
        case CWRotation
        case LongPress
        case CCWRotation
        case downSwipe
        case rightSwipe
        case none
    }
 
 
    var lastGesture = gesture.none
    
    
    //MARK: Class Singleton
    class var sharedInstance: EasterEggController
    {
        struct Static
        {
            static var instance:EasterEggController?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token)
        {
            Static.instance = EasterEggController()
        }
        return Static.instance!
    }
    
    
    func initiate(view:UIView)
    {
       
        //Long press
        
        let longPress: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action:#selector(EasterEggController.handlelongPress(_:)))
            view.addGestureRecognizer(longPress)
        
        //Right swipe
        
        let rightSwipe: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action:#selector(EasterEggController.handlerightSwipe(_:)))
            rightSwipe.direction = UISwipeGestureRecognizerDirection.Right
            view.addGestureRecognizer(rightSwipe)
        
        //Two finger down swipe
        
        let downSwipe: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action:#selector(EasterEggController.handledownSwipe(_:)))
            downSwipe.direction = UISwipeGestureRecognizerDirection.Down
            view.addGestureRecognizer(downSwipe)
        
        //Rotation
        
        let rotation: UIRotationGestureRecognizer = UIRotationGestureRecognizer(target: self, action:#selector(EasterEggController.handleRotation(_:)))
            view.addGestureRecognizer(rotation)
        
    }
    
    func checkKey()
    {
        if index == key.endIndex
        {
            let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.navigateToEasterEggScreen()
        }
    }
    
    func handlelongPress(sender: UILongPressGestureRecognizer? = nil)
    {
        print("long press")
        if (key[index] == "longPress")
        {
            print("long press")
            index += 1
            checkKey()
        }
        else
        {
            index = 0
        }
     
    }
    
    func handlerightSwipe(sender: UISwipeGestureRecognizer? = nil)
    {
        print("rightswipe")
        if (key[index] == "rightSwipe")
        {
            
            index += 1
            checkKey()
        }
        else
        {
            index = 0
        }

    
    }
    
    func handledownSwipe(sender: UISwipeGestureRecognizer? = nil)
    {
        print("down swipe")
        if (key[index] == "downSwipe")
        {
            index += 1
            checkKey()
        }
        else
        {
            index = 0
        }
    }
    
    func handleRotation(sender: UIRotationGestureRecognizer? = nil)
    {
        
        //self.lastGesture = gesture.rotation
        
        if (sender!.state == UIGestureRecognizerState.Ended)
        {
            
            // Here we differentiate between counterclockwise and clockwise
            if (sender!.rotation < 0)
            {
                
                self.lastGesture = gesture.CCWRotation
                
                print("counterclockwise")
                if (key[index] == "CCWRotation")
                {
                    index += 1
                    checkKey()
                }
                else
                {
                    index = 0
                }
            }
            else
            {
                print("clockwise")
                self.lastGesture = gesture.CWRotation
                if (key[index] == "CWRotation")
                {
                    index += 1
                    checkKey()
                }
                else
                {
                    index = 0
                }
            }
        }
    }
    
    
    //Allow to recognize multiple gestures of the same type
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

}








