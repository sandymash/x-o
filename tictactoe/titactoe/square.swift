//
//  square.swift
//  titactoe
//
//  Created by sandy mashinsky on 23/04/2022.
//

import Foundation
import UIKit

enum SquareStatus {
    case empty
    case ex
    case oh
}

struct Game {
    struct Board {
        static let Size = 3
    }
    
    enum Player : String {
        case X = "X"
        case O = "O"
        case E = "E"
        
        func spriteName() -> String {
            return self.rawValue
        }
        
        func flip() -> Player {
            switch self {
            case .O:
                return .X
            case .X:
                return .O
            default:
                return .E
            }
        }
    }
        
    enum Status {
        case Active
        case Won
        case Draw
    }
}

class Square: UIButton {
    var ownedPlayer = Game.Player.E
    
    func reset() {
        ownedPlayer = Game.Player.E
    }
    
    public func isEmptySlot() -> Bool {
        return self.title(for: .normal) == nil
    }
    
    func markAs(label: String) {
//        ownedPlayer = player
        self.setTitle(label, for: .normal)
    }
}

class GameBoard {
    
    private let getSquares: [Square] = {
        var items = [Square]()
        let boardSize = Game.Board.Size * Game.Board.Size
        for _ in 0..<boardSize {
            items.append(Square())
        }
        return items
    }()
    
    // maps 2D grid position to linear position
    func get1DPosition(from point:(x: Int, y: Int)) -> Int {
        return point.x + Game.Board.Size * point.y;
    }
    
    // maps linear position to 2D grid position
    func get2DPosition(from index: Int) -> (x: Int, y: Int) {
        let x = index % Game.Board.Size;
        let y = index / Game.Board.Size;
        return (x, y)
    }
    
    func reset() {
        for gridItem in getSquares {
            gridItem.reset()
        }
    }
    
    // mark grid item locked, if a valid move is made with 2D position

    func markGridItem(at pos:(x: Int, y: Int), with player: Game.Player) -> Bool {
        let index = get1DPosition(from: pos)
        return markGridItem(at: index, with: player)
    }
    
    // mark grid item locked, if a valid move is made with 1D index
    //
    func markGridItem(at index: Int, with player: Game.Player) -> Bool {
        let gridItem = getSquares[index]
        
        if !gridItem.isEmptySlot() {
            return false
        }
        
        gridItem.ownedPlayer = player
        return true
    }
}

class GameSession {
    var wins = [Game.Player.O: 0, Game.Player.X: 0]
    var draws = 0
}

class Score {
    
    var column = [Int: Int]()
    var row = [Int: Int]()
    var diagonal = [Int: Int]()
    
    func reset () {
        column.removeAll()
        row.removeAll()
        diagonal.removeAll()
    }
}
