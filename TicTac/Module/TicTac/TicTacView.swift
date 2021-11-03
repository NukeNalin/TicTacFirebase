//
//  TicTacView.swift
//  TicTac
//
//  Created by Nalin Porwal on 31/10/21.
//

import UIKit

class TicTacView: UIView {

    var tictacManager = TicTacManager.shared
    var imageView =  UIImageView()
    var index: (Int,Int)? 
    override func awakeFromNib() {
        imageView.frame = bounds
        imageView.tintColor = UIColor(displayP3Red: 246/255, green: 215/255, blue: 143/255, alpha: 1)
        self.addSubview(imageView)
    }
}

extension TicTacView {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            if imageView.image == nil  {
                let team = tictacManager.teamSupport ?? .zero
                tictacManager.updateStatefor(tag: tag, team: team)
                imageView.image = UIImage(systemName: team == .cross ? "multiply" : "circle")
                guard let index = index else {return}
                tictacManager.pressAction(index)
            }
    }
}
