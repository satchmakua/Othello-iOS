import Foundation

class GameModel {
    enum Player: Int {
        case black = 1, white = 2
        
        var opposite: Player {
            return self == .black ? .white : .black
        }
    }
    
    var board: [[Int]] = Array(repeating: Array(repeating: 0, count: 8), count: 8)
    var currentPlayer: Player = .black
    
    init() {
        // Initial board setup
        board[3][3] = Player.white.rawValue
        board[3][4] = Player.black.rawValue
        board[4][3] = Player.black.rawValue
        board[4][4] = Player.white.rawValue
    }
    
    func isValidMove(row: Int, col: Int, for player: Player) -> Bool {
        guard board[row][col] == 0 else { return false }
        return findFlippableDiscs(fromRow: row, col: col, for: player).count > 0
    }
    
    func makeMove(row: Int, col: Int, for player: Player) {
        let flippableDiscs = findFlippableDiscs(fromRow: row, col: col, for: player)
        for (r, c) in flippableDiscs {
            board[r][c] = player.rawValue
        }
        board[row][col] = player.rawValue
        currentPlayer = currentPlayer.opposite
    }
    
    private func findFlippableDiscs(fromRow row: Int, col: Int, for player: Player) -> [(Int, Int)] {
        let directions = [(-1, 0), (1, 0), (0, -1), (0, 1), (-1, -1), (-1, 1), (1, -1), (1, 1)]
        var flippableDiscs: [(Int, Int)] = []
        
        for dir in directions {
            var discsToFlip: [(Int, Int)] = []
            var r = row + dir.0
            var c = col + dir.1
            
            while r >= 0 && r < 8 && c >= 0 && c < 8 {
                if board[r][c] == player.opposite.rawValue {
                    discsToFlip.append((r, c))
                } else if board[r][c] == player.rawValue {
                    flippableDiscs.append(contentsOf: discsToFlip)
                    break
                } else {
                    break
                }
                r += dir.0
                c += dir.1
            }
        }
        return flippableDiscs
    }
    
    func gameIsOver() -> Bool {
        for row in 0..<8 {
            for col in 0..<8 {
                if isValidMove(row: row, col: col, for: .black) || isValidMove(row: row, col: col, for: .white) {
                    return false
                }
            }
        }
        return true
    }
    
    var blackScore: Int {
        return board.flatMap { $0 }.filter { $0 == Player.black.rawValue }.count
    }
    
    var whiteScore: Int {
        return board.flatMap { $0 }.filter { $0 == Player.white.rawValue }.count
    }
    
    func winner() -> Player? {
        let blackScore = self.blackScore
        let whiteScore = self.whiteScore
        if gameIsOver() {
            if blackScore > whiteScore {
                return .black
            } else if whiteScore > blackScore {
                return .white
            }
        }
        return nil
    }
}
