//
//  JoinAndCreateViewController.swift
//  TicTac
//
//  Created by Nalin Porwal on 31/10/21.
//

import UIKit

class JoinAndCreateViewController: UIViewController {
    
    @IBOutlet weak var textfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func createRoomAction(_ sender: Any) {
        guard let roomCode = textfield.text else {
            return
        }
        TicTacManager.shared.roomManager.createRoom(id: roomCode)
        navigateToNextScreen()
    }
    @IBAction func joinRoomAction(_ sender: Any) {
        guard let roomCode = textfield.text else {
            return
        }
        TicTacManager.shared.roomManager.joinRoom(id: roomCode)
        navigateToNextScreen()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        TicTacManager.shared.ticTacdic.removeAll()
        TicTacManager.shared.matrixArray =   Array(0...2)
            .map { _ in
                return [false,false,false]
            }
    }
    
    func navigateToNextScreen() {
        performSegue(withIdentifier: "next", sender: nil)
    }
}
