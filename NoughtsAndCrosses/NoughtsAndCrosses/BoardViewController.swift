//
//  BoardViewController.swift
//  NoughtsAndCrosses
//
//  Created by Alejandro Castillejo on 5/27/16.
//  Copyright © 2016 Julian Hulme. All rights reserved.
//

import UIKit

class BoardViewController: UIViewController,UIGestureRecognizerDelegate {
    
    @IBOutlet weak var boardView: UIView!
    
    
    @IBOutlet var buttons: [UIButton]!

    var networkMode:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Rotation
        
        //Create an instance of UIRotationGestureRecognizer
        let rotation: UIRotationGestureRecognizer = UIRotationGestureRecognizer(target: self, action:#selector(BoardViewController.handleRotation(_:)))
        self.boardView.addGestureRecognizer(rotation)
        
        /**
        let pinch = UIPinchGestureRecognizer(target: self, action:#selector(BoardViewController.handlePinch(_:)))
        self.boardView.addGestureRecognizer(pinch)
        **/
        
        ClosureExperiment()
        
    }
    
    
    func handleRotation(sender: UIRotationGestureRecognizer? = nil) {
        
        self.boardView.transform = CGAffineTransformMakeRotation(sender!.rotation)
    
        //Rotation Ends
        print("rotation detected")
        if (sender!.state == UIGestureRecognizerState.Ended) {
            
            print("rotation \(sender!.rotation)")
            
            
            if (sender!.rotation < CGFloat(M_PI)/4) {
            
                //snap action
                UIView.animateWithDuration(NSTimeInterval(3), animations: {
                    self.boardView.transform = CGAffineTransformMakeRotation(0)
                })
                
            } else if (true) {
                //ADD Here
            }
        }
        
        
    }

    func handlePinch(sender: UIRotationGestureRecognizer? = nil) {
        print("pinch detected")
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //This should be a UI Button --> 
    @IBAction func BoardTapped(sender: AnyObject) {
    
        let tag = sender.tag
    
        //set cell value
        let cellValue = String(OXGameController.sharedInstance.playMove(tag))
        sender.setTitle(cellValue, forState: UIControlState.Normal)
 
    
        let gameState = OXGameController.sharedInstance.getCurrentGame()!.state()
        let player = OXGameController.sharedInstance.getCurrentGame()!.whosTurn()
    
    
        if (gameState == OXGameState.complete_someone_won){
            print("\(String(player)) wins!")
    
            OXGameController.sharedInstance.finishCurrentGame()
        
            if (networkMode) {
            
                self.navigationController?.popViewControllerAnimated(true)
            
            }
            else
            {
                restartGame()
            }
        }
        else if (gameState == OXGameState.complete_no_one_won){
        print("Tie game!")
    
            OXGameController.sharedInstance.finishCurrentGame()
        
            if (networkMode) {
            
                self.navigationController?.popViewControllerAnimated(true)

            }
            else
            {
                restartGame()
            }
  
        }
        else {
        
            if (networkMode) {
            
                let (cellType, index) = OXGameController.sharedInstance.playRandomMove()!
            
                buttons[index].setTitle(String(cellType), forState: UIControlState.Normal)
            
            }
            if (gameState == OXGameState.complete_someone_won){
                print("\(String(player)) wins!")
                self.navigationController?.popViewControllerAnimated(true)
            
            }
            if (gameState == OXGameState.complete_no_one_won){
                print("Tie game!")
                self.navigationController?.popViewControllerAnimated(true)
            }
        }
        
}

    @IBOutlet weak var networkButton: UIButton!
    
    @IBAction func networkButtonTapped(sender: UIButton) {
        
        
        let npc = NetworkPlayViewController (nibName: "NetworkPlayViewController", bundle:nil)
        self.navigationController?.pushViewController(npc, animated: true)
        
    }


func restartGame() {
    OXGameController.sharedInstance.getCurrentGame()!.reset()
    for button in buttons {
        button.setTitle("", forState: UIControlState.Normal)
    }
}

    @IBOutlet weak var newGameButton: UIButton!

    @IBAction func newgame(sender: UIButton) {
        
        
            restartGame()
            
        }

    
    
    @IBOutlet weak var logOutButton: UIButton!
    
    @IBAction func logOutButton(sender: UIButton) {
        
        
        if (networkMode){
            
            OXGameController.sharedInstance.finishCurrentGame()
            
            self.navigationController?.popViewControllerAnimated(true)
            
            logOutButton.setTitle("Cancel Game", forState: UIControlState.Normal)
        }
        else {
            let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            appDelegate.navigateToLandingViewNavigationController()
            
            NSUserDefaults.standardUserDefaults().setValue(nil, forKey: "userIdLoggedIn")
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
        
        if (networkMode) {
            
            networkButton.hidden = true
            
            logOutButton.setTitle("Cancel Game", forState: UIControlState.Normal)
        }
        
    }


}