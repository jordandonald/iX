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
    
    var currentGame = OXGame()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if (!networkMode){
         
                refreshButton.hidden = true
        }
        
        if (networkMode){
            
            updateUI(currentGame)
            
        }
        
        //Rotation
        
        //Create an instance of UIRotationGestureRecognizer
        let rotation: UIRotationGestureRecognizer = UIRotationGestureRecognizer(target: self, action:#selector(BoardViewController.handleRotation(_:)))
        self.boardView.addGestureRecognizer(rotation)
        
        //ClosureExperiment()
        
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
        
        let gameState = currentGame.state()
        let player = currentGame.whosTurn().rawValue
        
        if(networkMode){
            
            
            //if it's my turn, update the board locally
            if currentGame.guestUser!.email != ""
            {
                if currentGame.localUsersTurn() {
                
                    currentGame.playMove(tag)
                    OXGameController.sharedInstance.playMove(self.currentGame.serialiseBoard(), gameId: self.currentGame.gameId!, presentingViewController: self, viewControllerCompletionFunction: {(game, message) in self.gameUpdateReceived(game,message:message)})
                    
                }
                else{
                    
                    print("It's not your turn.")
                    
                }
            }
            
            
            
        }
        else
        {
            
            //set cell value
            let cellValue = String(currentGame.playMove(tag))
            
            //let cellValue = String(OXGameController.sharedInstance.playMove(tag))
            sender.setTitle(cellValue, forState: UIControlState.Normal)
            
            if (gameState == OXGameState.complete_someone_won){
                //print("\(player) wins!")
                
                let alert = UIAlertController(title:"\(player) wins!", message:"Head back to available games.", preferredStyle: UIAlertControllerStyle.Alert)
                let action = UIAlertAction(title: "Shweet", style: UIAlertActionStyle.Default, handler: {(action) in
                    //when the user clicks "Ok", do the following
                    self.restartGame()
                    
                })
                alert.addAction(action)
                self.presentViewController(alert, animated: true, completion: nil)
                
            }
            else if (gameState == OXGameState.complete_no_one_won){
                //print("Tie game!")
                
                let alert = UIAlertController(title:"Tie wins!", message:"Head back to available games.", preferredStyle: UIAlertControllerStyle.Alert)
                let action = UIAlertAction(title: "Shweet", style: UIAlertActionStyle.Default, handler: {(action) in
                    //when the user clicks "Ok", do the following
                    self.restartGame()
                    
                })
                alert.addAction(action)
                self.presentViewController(alert, animated: true, completion: nil)
            }
            
        }
        
}

    @IBOutlet weak var networkButton: UIButton!
    
    @IBAction func networkButtonTapped(sender: UIButton) {
        
        let npc = NetworkPlayViewController (nibName: "NetworkPlayViewController", bundle:nil)
        self.navigationController?.pushViewController(npc, animated: true)
        
    }


func restartGame() {
    currentGame.reset()
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
            
            //OXGameController.sharedInstance.finishCurrentGame()
            
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
    
    //func gameCancelCompletion(success:Bool, message:String?){}
    
    @IBOutlet weak var refreshButton: UIButton!
    
    @IBAction func refreshButton(sender: UIButton) {
        
        OXGameController.sharedInstance.getGame(self.currentGame.gameId!, presentingViewController: self, viewControllerCompletionFunction: {(game, message) in self.gameUpdateReceived(game,message:message)})
        
    }
    
    func gameUpdateReceived(game:OXGame?, message:String?) {
            
            if let gameReceived = game {
                self.currentGame = gameReceived
                print("success")
            }
            
            self.updateUI(self.currentGame)
        
    }
    
    
    func updateUI (game:OXGame) {

        var board = game.board
        
        
        for button in buttons {
            
            print(board[button.tag])
            button.setTitle("\(board[button.tag].rawValue)", forState: UIControlState.Normal)

        }
        
        
    
        if (networkMode){
            
            let gameState = currentGame.state()
            let player = currentGame.whosTurn().rawValue
            
            if (gameState == OXGameState.complete_someone_won){
                
                let alert = UIAlertController(title:"\(player) wins!", message:"HHead back to available games.", preferredStyle: UIAlertControllerStyle.Alert)
                let action = UIAlertAction(title: "Shweet", style: UIAlertActionStyle.Default, handler: {(action) in
                    //when the user clicks "Ok", do the following
                    self.navigationController?.popViewControllerAnimated(true)
                    
                })
                alert.addAction(action)
                self.presentViewController(alert, animated: true, completion: nil)
            }
            else if (gameState == OXGameState.complete_no_one_won){
                
                let alert = UIAlertController(title:"Tie game!", message:"Head back to available games.", preferredStyle: UIAlertControllerStyle.Alert)
                let action = UIAlertAction(title: "Shweet", style: UIAlertActionStyle.Default, handler: {(action) in
                    //when the user clicks "Ok", do the following
                    self.navigationController?.popViewControllerAnimated(true)
                    
                })
                alert.addAction(action)
                self.presentViewController(alert, animated: true, completion: nil)
                
            }
            
            if currentGame.guestUser!.email == ""
            {
                newGameButton.setTitle("Waiting for an opponent...", forState: UIControlState.Normal)
            
            }
            else {
                //sets the "New Game Button" to display the current game status
                newGameButton.setTitle("\(currentGame.whosTurn().rawValue)'s turn!", forState: UIControlState.Normal)
            }
        }
        
    }
        
}
    
