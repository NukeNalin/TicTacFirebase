//
//  TicTacManager.swift
//  TicTac
//
//  Created by Nalin Porwal on 31/10/21.
//


class TicTacManager {
    static let shared = TicTacManager()
    private init() {
        roomManager.teamDidUpdated { state in
            self.teamSupport = state
        }
    }
    let roomManager = GameRoomMamanger()
    var callBackWinner: ()-> Void = {}
    var callBackLost: () -> Void = {}
    var teamSupport: State?
    enum State: String, Equatable {
        case cross
        case zero
    }
    var ticTacdic: [(Int):State] = [:] 
    lazy var  matrixArray: [[Bool]] = Array(0...2)
        .map { _ in
            return [false,false,false]
        }
    
    func updateStatefor(tag: Int, team: State) {
        ticTacdic[tag] = team
        let dict = Dictionary(uniqueKeysWithValues: ticTacdic.map({ key,value in
            return (String(key), value.rawValue)
        }))
        roomManager.updateState(state: dict)
    }
    
    func pressAction(_ index: (Int, Int)) {
        matrixArray[index.0][index.1] = true
        checkWinner(on: index)
    }
    
    func setLoseObserver() {
        roomManager.observeLostState(forState: self.teamSupport ?? .cross) {
            self.callBackLost()
        }
    }
    func checkWinner(on index: (Int,Int)) {
        
        var isWinner = true
        
        // Check Horizontal
        for value in matrixArray[index.0] {
            if !value {
                isWinner = false
                break
            }
        }
        if isWinner {
            roomManager.updateWinner((teamSupport ?? .cross).rawValue)
            callBackWinner()
            return
        }
        
        // Check Vertical
        isWinner = true
        for row in matrixArray {
            if !row[index.1] {
                isWinner = false
                break
            }
        }
        
        if isWinner {
            roomManager.updateWinner((teamSupport ?? .cross).rawValue)
            callBackWinner()
            return
        }
        
        // Check diagonal
        isWinner = true
        for (i,row) in matrixArray.enumerated(){
            if !row[i] {
                isWinner = false
                break
            }
        }
        if isWinner {
            roomManager.updateWinner((teamSupport ?? .cross).rawValue)
            callBackWinner()
            return
        }
        
        isWinner = true
        for (i,row) in matrixArray.enumerated(){
            if !row[2-i] {
                isWinner = false
                break
            }
        }
        if isWinner {
            roomManager.updateWinner((teamSupport ?? .cross).rawValue)
            callBackWinner()
            return
        }
    }
    
    func observeState(_ action: @escaping ([Int:State]) -> Void) {
        roomManager.observeState { stateDict in
            let dict = Dictionary<Int, State>(uniqueKeysWithValues: stateDict.compactMap({ key, value in
                if let state = State(rawValue: value) {
                    return (key, state)
                } else {
                    return nil
                }
            }))
            action(dict)
        }
    }
}
