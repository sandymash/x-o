//
//  GameController.swift
//  titactoe
//
//  Created by sandy mashinsky on 23/04/2022.
//

import Foundation

class ScoreManager {
    
    private var markedCount = 0 // counter to determine if the game is a draw
    private var scoreList = [Game.Player.O: Score(), Game.Player.X: Score()]
    
    // check if the current move is a winning move
    //
    func isWinningMove(player: Game.Player, position pos: (x: Int, y: Int)) -> Game.Status {
        markedCount += 1

        if checkHAndVWins(in: scoreList[player] ?? Score(), pos: pos)
            || checkDiagonalWins(in: scoreList[player] ?? Score(), pos: pos) {
            return Game.Status.Won
        }
        
        // check if the game is a draw
        if markedCount > 8 {
            return Game.Status.Draw
        }
        
        return Game.Status.Active
    }
    
    // reset scores
    //
    func reset() {
        markedCount = 0
        for scoreItem in scoreList.values {
            scoreItem.reset()
        }
    }
    
    // check horizontal and vertical wins
    //
    private func checkHAndVWins(in score: Score, pos:(x: Int, y: Int)) -> Bool {
        score.column[pos.x] = (score.column[pos.x] ?? 0) + 1
        score.row[pos.y] = (score.row[pos.y] ?? 0) + 1
        
        guard let col = score.column[pos.x], col < Game.Board.Size, let row = score.row[pos.y], row < Game.Board.Size else {
            return true
        }
        
        return false
    }
    
    // check diagonal wins
    //
    private func checkDiagonalWins(in score: Score, pos:(x: Int, y: Int)) -> Bool {
        score.diagonal[0] = (score.diagonal[0] ?? 0)
        score.diagonal[1] = (score.diagonal[1] ?? 0)
        
        if pos.x == pos.y { //first diagonal
            score.diagonal[0] = (score.diagonal[0] ?? 0) + 1
        }
        if (Game.Board.Size - pos.x - 1) == pos.y { //second diagonal
            score.diagonal[1] = (score.diagonal[1] ?? 0) + 1
        }
        
        guard let diagOne = score.diagonal[0], diagOne < Game.Board.Size, let diagTwo = score.diagonal[1], diagTwo < Game.Board.Size else {
            return true
        }
        
        return false
    }
}

class GameManager {
    
    private let gameBoard = GameBoard()
    private let scoreManager = ScoreManager()
    private var gameStatus = Game.Status.Active
    private(set) public var currentPlayer = Game.Player.O
    private(set) public var session = GameSession()
    
    // callback function for game status updates
    //
    var onGameStatusUpdate: (Game.Status)->() = { status in
        print(status)
    }
    
    func startNewGame() {
        gameBoard.reset()
        scoreManager.reset()
        currentPlayer = currentPlayer.flip()
        gameStatus = Game.Status.Active
        onGameStatusUpdate(gameStatus)
    }
    
    // update game session object
    //
    private func updateSession(status: Game.Status) {
        switch status {
        case .Draw:
            session.draws += 1
        case .Won:
            session.wins[currentPlayer]? += 1
        case .Active:
            // switch to the other player
            currentPlayer = currentPlayer.flip()
            return
        }
    }
}
