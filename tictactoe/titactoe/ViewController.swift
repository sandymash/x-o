//
//  ViewController.swift
//  titactoe
//
//  Created by sandy mashinsky on 23/04/2022.
//

import UIKit
import SwiftUI

class ViewController: UIViewController {
    enum Turn {
        case ex
        case oh
    }
    enum GameStatus {
        case Active
        case Draw
        case Won
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        turnLabel.text = getTurnLabel(firstTurn)
        setupViews()
    }
    
    @IBOutlet weak var turnLabel: UILabel!
    @IBOutlet weak var gameStatusLabel: UILabel!
    @IBOutlet weak var gameScoreLabel: UILabel!
    
    @IBOutlet weak var a1: UIButton!
    @IBOutlet weak var a2: UIButton!
    @IBOutlet weak var a3: UIButton!
    
    @IBOutlet weak var b1: UIButton!
    @IBOutlet weak var b2: UIButton!
    @IBOutlet weak var b3: UIButton!
    
    @IBOutlet weak var c1: UIButton!
    @IBOutlet weak var c2: UIButton!
    @IBOutlet weak var c3: UIButton!
    
    var firstTurn = Turn.ex
    var currentTurn = Turn.ex
    
    let X = "X"
    let O = "O"
    let EMPTY = " "
    
    var scores : [String: Int] = ["O": 0, "X": 0]
    
    @IBAction func onSquareTap(_ sender: UIButton) {
        if (makeAMove(sender)) {
            if(hasWin(getTurnLabel(currentTurn))) {
                updateGameStatus(.Won)
                return
            }
            
            if(isBoardFull()) {
                updateGameStatus(.Draw)
                return
            }
            
            switchTurn(&currentTurn)
        }
    }
    
    func makeAMove(_ sender: UIButton) -> Bool {
        if(isSlotEmpty(sender)) {
            let label = getTurnLabel(currentTurn)
            sender.setTitle(label, for: .normal)
            return true;
        }
        
        return false;
    }
    
    func isSlotEmpty(_ sender: UIButton) -> Bool {
        return sender.title(for: .normal) == nil || sender.title(for: .normal) == EMPTY
    }

    private let statusDrawText = "Game Is A Draw!"
    private var grid = [UIButton]()
    
    private func setupViews() {
        grid = [a1, a2, a3,
                b1, b2, b3,
                c1, c2, c3]
        scores = [O: 0, X: 0]
    }
    
    func isBoardFull() -> Bool {
        for square in grid {
            if(isSlotEmpty(square)) {
                return false
            }
        }
        
        return true
    }
    
    func switchTurn(_ turn: inout Turn) {
        var oppositeTurn : Turn? = nil
        switch turn {
        case Turn.oh:
            oppositeTurn = Turn.ex
        case Turn.ex:
            oppositeTurn = Turn.oh
        }
        
        if (oppositeTurn != nil) {
            turnLabel.text = getTurnLabel(oppositeTurn!)
            turn = oppositeTurn!
        }
    }
    
    func getTurnLabel(_ turn: Turn) -> String {
        switch turn {
        case Turn.oh:
            return O
        case Turn.ex:
            return X
        }
    }
    
    private func updateGameStatus(_ status: GameStatus) {
        switch status {
            case .Draw:
                gameStatusLabel.text = "\(statusDrawText)"
                showResetButton(true)
            case .Won:
                gameStatusLabel.text = "player \(getTurnLabel(currentTurn)) won"
                showResetButton(true)
            case .Active:
                gameStatusLabel.text = " "
            break;
            
        }
    }
    
    private func showResetButton(_ enable: Bool) {
        turnLabel.isUserInteractionEnabled = enable
        for button in grid {
            button.isUserInteractionEnabled = !enable
        }

        if(enable) {
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.labelTapped))
            turnLabel.addGestureRecognizer(tap)
            
            turnLabel.text = "replay"
            
            showScores()
        }
    }

    @objc func labelTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        resetGame()
        print("Label clicked")
    }
    
    
    func slotHasValue(square: UIButton, value: String) -> Bool {
        return square.title(for: .normal) == value
    }
    
    func trioHasValue(_ sqrs: [UIButton], _ value: String) -> Bool {
        return sqrs.allSatisfy({
            slotHasValue(square: $0, value: value)
        })
    }
    
    func hasWin(_ player: String) -> Bool {
        let rowWin =
        trioHasValue([a1,a2,a3], player) ||
        trioHasValue([b1,b2,b3], player) ||
        trioHasValue([c1,c2,c3], player)
        
        if(rowWin) {
            scores[player]! += 1
            return true;
        }
        
        let colWin =
        trioHasValue([a1,b1,c1], player) ||
        trioHasValue([a2,b2,c2], player) ||
        trioHasValue([a3,b3,c3], player)
        
        if(colWin) {
            scores[player]! += 1
            return true;
        }
        
        let diagonalWin =
        trioHasValue([a1,b2,c3], player) ||
        trioHasValue([a3,b2,c1], player)
        
        if(diagonalWin) {
            scores[player]! += 1
            return true
        }
        
        return false
    }
    
    func resetSquare(_ button: UIButton) {
        button.setTitle(EMPTY, for: .normal)
    }
    
    func resetGame() {
        updateGameStatus(.Active)
        
        for square in grid {
            resetSquare(square)
        }
        
        switchTurn(&firstTurn)
        currentTurn = firstTurn
        showResetButton(false)
    }
    
    func showScores() {
        let scoreString =
        "X: " + String(scores[X]!) + "       |       O: " + String(scores[O]!)
        
        gameScoreLabel.text = scoreString
    }

}

