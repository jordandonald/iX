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
         self.title = "Network Play"
        self.navigationController?.navigationBarHidden = false
       
        
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
    
    func gameListReceived(games:[OXGame]?,message:String?) {
        
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
        
    OXGameController.sharedInstance.acceptGameWithId(String(gameList[indexPath.row].gameId!))
        
        
        let bvc = BoardViewController (nibName: "BoardViewController", bundle:nil)
        bvc.networkMode = true
        self.navigationController?.pushViewController(bvc, animated: true)
        
        

    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
        
        gameList = OXGameController.sharedInstance.getListOfGames()!
        
        self.gameList = OXGameController.sharedInstance.getListOfGames()!
        self.tableView.reloadData()
        refreshControl.endRefreshing()

        }

    
    @IBAction func startNetworkGameButton(sender: UIButton) {
        
    OXGameController.sharedInstance.createNewGame((UserController.sharedInstance.logged_in_user)!)
    
    }
    
    
    func refreshTable() {
        
        self.gameList = OXGameController.sharedInstance.getListOfGames()!
        self.tableView.reloadData()
        refreshControl.endRefreshing()
        
    }
    
    }
    


