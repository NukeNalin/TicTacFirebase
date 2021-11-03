//
//  ViewController.swift
//  TicTac
//
//  Created by Nalin Porwal on 31/10/21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var stackView: UIStackView!
    
    lazy var tictacManager = TicTacManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    func initialSetup() {
        for (i,stack) in stackView.subviews
                .enumerated() where stack.isKind(of: UIStackView.self) {
            for (j,innerView) in stack.subviews
                    .enumerated() where innerView.isKind(of: TicTacView.self)   {
                if let tictacView = innerView as? TicTacView {
                    tictacView.tictacManager = self.tictacManager
                    tictacView.index = (i,j)
                }
            }
        }
        tictacManager.callBackWinner = {
            let alert = UIAlertController(title: "You won", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {_ in
                self.navigationController?.popViewController(animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
        }
        tictacManager.callBackLost = {
            let alert = UIAlertController(title: "You lost", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {_ in
                self.navigationController?.popViewController(animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
        }
        tictacManager.observeState(update(forDict:))
        tictacManager.setLoseObserver()
    }
    
    func update(forDict dict: [Int: TicTacManager.State]) {
        for value in dict {
            if let view = view.viewWithTag(value.key) as? TicTacView {
                if view.imageView.image == nil {
                    view.imageView.image = UIImage(systemName: value.value == .cross ? "multiply" : "circle")
                }
            }
        }
    }
}

