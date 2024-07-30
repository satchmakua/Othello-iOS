import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var playerTurnLabel: UILabel!
    @IBOutlet weak var othelloView: OthelloView!
    
    let gameModel = GameModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        othelloView.gameModel = gameModel
        updatePlayerTurnLabel()
    }
    
    func updatePlayerTurnLabel() {
        playerTurnLabel.text = "Player's Turn: \(gameModel.currentPlayer == .black ? "Black" : "White")"
    }
}
