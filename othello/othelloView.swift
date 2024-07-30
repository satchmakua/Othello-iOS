import UIKit

class OthelloView: UIView {
    
    var gameModel: GameModel?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // Initialize the board with the starting position
        gameModel?.board[3][3] = 2
        gameModel?.board[3][4] = 1
        gameModel?.board[4][3] = 1
        gameModel?.board[4][4] = 2
        
        // Add a tap gesture recognizer to the view
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        self.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let gameModel = gameModel else { return }
        
        let point = gestureRecognizer.location(in: self)
        let width = self.bounds.width / 8
        let height = self.bounds.height / 8
        
        let row = Int(point.y / height)
        let col = Int(point.x / width)
        
        if gameModel.isValidMove(row: row, col: col, for: gameModel.currentPlayer) {
            gameModel.makeMove(row: row, col: col, for: gameModel.currentPlayer)
            self.setNeedsDisplay() // Redraw the board with updated state
            (self.superview?.next as? ViewController)?.updatePlayerTurnLabel() // Update the label
        }
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext(), let gameModel = gameModel else { return }
        
        let boardSize = min(self.bounds.width, self.bounds.height)
        let cellSize = boardSize / 8
        let xOffset = (self.bounds.width - boardSize) / 2
        let yOffset = (self.bounds.height - boardSize) / 2

        context.setFillColor(UIColor.green.cgColor)
        let boardRect = CGRect(x: xOffset, y: yOffset, width: boardSize, height: boardSize)
        context.fill(boardRect)
        
        context.setStrokeColor(UIColor.black.cgColor)
        for i in 0...8 {
            let position = CGFloat(i) * cellSize
            context.move(to: CGPoint(x: xOffset + position, y: yOffset))
            context.addLine(to: CGPoint(x: xOffset + position, y: yOffset + boardSize))
            context.move(to: CGPoint(x: xOffset, y: yOffset + position))
            context.addLine(to: CGPoint(x: xOffset + boardSize, y: yOffset + position))
        }
        context.strokePath()
        
        for row in 0..<8 {
            for col in 0..<8 {
                if gameModel.board[row][col] != 0 {
                    let x = xOffset + CGFloat(col) * cellSize + cellSize / 2
                    let y = yOffset + CGFloat(row) * cellSize + cellSize / 2
                    let radius = cellSize / 2 - 4
                    context.addArc(center: CGPoint(x: x, y: y), radius: radius, startAngle: 0, endAngle: CGFloat(2 * Double.pi), clockwise: true)
                    context.setFillColor(gameModel.board[row][col] == GameModel.Player.black.rawValue ? UIColor.black.cgColor : UIColor.white.cgColor)
                    context.fillPath()
                }
            }
        }
    }
}

