//
//  OXGame.swift
//  NoughtsAndCrosses
//
//  Created by Jordan Donald on 5/30/16.
//  Copyright © 2016 Julian Hulme. All rights reserved.
//

import Foundation

enum CellType:String {
    case O = "0"
    case X = "X"
    case EMPTY = ""
}

enum OXGameState:String {
    case inProgress
    case complete_no_one_won
    case complete_someone_won
}

class OXGame {
    
    //the board data, stored in 1D array
    private var board = [CellType] (count: 9, repeatedValue: CellType.EMPTY)
    
    //decide which CellType is going to start
    private var startType = CellType.X
    
    private func turn() -> Int {
        
        var count = 0
        for cell in board {
            if (cell != CellType.EMPTY) {
                count = count + 1
            }
            
        }
        //print ("turn is \(count)")
        return count
    }
    
    //who's turn is it?
    func whosTurn() -> CellType {
        
        if (turn() % 2 == 0)  {
            return CellType.O
        }
        else
        {
            return CellType.X
        }
    }
    
    //reports type at a specific position on the board
    func typeAtIndex(index:Int) -> CellType {
        
        return board[index]
        
    }
    
    // updates the cell based on who's turn it is and returns the cellType
    func playMove(index:Int) -> CellType {
        
        board[index] = whosTurn()
        
        return whosTurn()
    }
    
    //Detects a winner
    func winDetection() -> Bool {
        if ((typeAtIndex(0) == typeAtIndex(1)) && (typeAtIndex(1) == typeAtIndex(2)) && (typeAtIndex(0) != CellType.EMPTY))
            || ((typeAtIndex(3) == typeAtIndex(4)) && (typeAtIndex(4) == typeAtIndex(5)) && (typeAtIndex(3) != CellType.EMPTY))
            || ((typeAtIndex(6) == typeAtIndex(7)) && (typeAtIndex(7) == typeAtIndex(8)) && (typeAtIndex(6) != CellType.EMPTY))
            || ((typeAtIndex(0) == typeAtIndex(3)) && (typeAtIndex(3) == typeAtIndex(6)) && (typeAtIndex(0) != CellType.EMPTY))
            || ((typeAtIndex(1) == typeAtIndex(4)) && (typeAtIndex(4) == typeAtIndex(7)) && (typeAtIndex(1) != CellType.EMPTY))
            || ((typeAtIndex(2) == typeAtIndex(5)) && (typeAtIndex(5) == typeAtIndex(8)) && (typeAtIndex(2) != CellType.EMPTY))
            || ((typeAtIndex(0) == typeAtIndex(4)) && (typeAtIndex(4) == typeAtIndex(8)) && (typeAtIndex(0) != CellType.EMPTY))
            || ((typeAtIndex(2) == typeAtIndex(4)) && (typeAtIndex(4) == typeAtIndex(6)) && (typeAtIndex(2) != CellType.EMPTY))
        {
            return true
        }
        else {
            return false
        }
    }
    
    // return the state of the game
    func state() -> OXGameState {
        
        if (winDetection() == true){
            return OXGameState.complete_someone_won
        }
        else if ((winDetection() == false) && (turn() == 8)){
            return OXGameState.complete_no_one_won
        }
        else {
            return OXGameState.inProgress
        }
    }
    
    //
    func reset() {
        
        for (count, _) in board.enumerate() {
            board[count] = CellType.EMPTY
        }
        
    }
    
}
