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
    
    var gameObject = OXGame()
    
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
    let cellValue = String(gameObject.playMove(tag))
    sender.setTitle(cellValue, forState: UIControlState.Normal)

    
    let gameState = gameObject.state()
    let player = gameObject.whosTurn()
    
    if (gameState == OXGameState.complete_someone_won){
    print("\(String(player)) wins!")
    restartGame()
    }
    else if (gameState == OXGameState.complete_no_one_won){
    print("Tie game!")
    restartGame()
    }
   
}


    @IBOutlet var buttons: [UIButton]!


func restartGame() {
    gameObject.reset()
    for button in buttons {
        button.setTitle("", forState: UIControlState.Normal)
    }
}


    @IBAction func newgame(sender: UIButton) {
        restartGame()
}
    
    @IBAction func logOutButton(sender: UIButton) {
        
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appDelegate.navigateToLandingViewNavigationController()
    }


}