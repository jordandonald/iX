//
//  NetworkPlayViewController.swift
//  NoughtsAndCrosses
//
//  Created by Jordan Donald on 6/3/16.
//  Copyright © 2016 Julian Hulme. All rights reserved.
//

import UIKit

class NetworkPlayViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    var gameList = [OXGame]()
    
    var refreshControl: UIRefreshControl!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Do any additional setup after loading the view.
        
        //From Class
        //OXGameController.sharedInstance.gameList(self,viewControllerCompletionFunction: {(gameList, message) in self.gameListReceived(gameList, message:message)})
        
        tableView.dataSource = self
        tableView.delegate = self
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Release to refresh")
        refreshControl.addTarget(self, action: #selector(NetworkPlayViewController.refreshTable), forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //From Class
    func gameListReceived(games:[OXGame]?,message:String?) {
        
        print ("games received \(games)")
        if let newGames = games {
            self.gameList = newGames
        }
        self.tableView.reloadData()
    }
    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (gameList.count > 0){
            return gameList.count
        }
        else {
            return 0
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        cell.textLabel?.text = "\(self.gameList[indexPath.row].hostUser!.email) (\(self.gameList[indexPath.row].gameId!))"

        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Available Network Games"
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var gameRowSelected = indexPath.row
        OXGameController.sharedInstance.acceptGame(self.gameList[indexPath.row].gameId!, presentingViewController: self, viewControllerCompletionFunction: {(game, message) in self.acceptGameComplete(game,message:message)})

    }
    
    func acceptGameComplete(game:OXGame?, message:String?){
        print("accept game call complete")
        
        if let gameAcceptedSuccess = game {
            let networkBoardView = BoardViewController(nibName: "BoardViewController", bundle: nil)
            networkBoardView.networkMode = true
            networkBoardView.currentGame = gameAcceptedSuccess
            self.navigationController?.pushViewController(networkBoardView, animated: true)
        }
    }

    
    override func viewWillAppear(animated: Bool) {
        self.title = "Network Play"
        
        self.navigationController?.navigationBarHidden = false
        
        OXGameController.sharedInstance.gameList( self, viewControllerCompletionFunction: {(gameList ,message) in self.gameListReceived(gameList, message: message )})
        self.tableView.reloadData()
        refreshControl.endRefreshing()

    }
    
    
    @IBAction func startNetworkGameButton(sender: UIButton) {
        
        print("startNetworkGameButtonTapped")
        OXGameController.sharedInstance.createNewGame(UserController.sharedInstance.getLoggedInUser()!, presentingViewController: self,viewControllerCompletionFunction: {(game, message) in self.newStartGameCompleted(game, message:message)})
   
        
    }
    
    func newStartGameCompleted(game:OXGame?,message:String?) {
        if let newGame = game {
            let networkBoardView = BoardViewController(nibName: "BoardViewController", bundle: nil)
            networkBoardView.networkMode = true
            networkBoardView.currentGame = newGame
            self.navigationController?.pushViewController(networkBoardView, animated: true)
        }
    }
    
    func refreshTable() {
        
        OXGameController.sharedInstance.gameList( self, viewControllerCompletionFunction: {(gameList ,message) in self.gameListReceived(gameList, message: message )})
        self.tableView.reloadData()
        refreshControl.endRefreshing()
        
    }
   
}
    

    

    


