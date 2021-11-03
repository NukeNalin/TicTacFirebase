//
//  GameMabnger.swift
//  TicTac
//
//  Created by Nalin Porwal on 31/10/21.
//
import Foundation
import UIKit
import Firebase
class GameRoomMamanger {
    let rootRef = Database.database().reference()
    var currentPlayerRef: DatabaseReference?
    var currentRoomRef: DatabaseReference?
    var teamChangeHook: ((TicTacManager.State)->Void)?
    
    func createRoom(id: String) {
        currentRoomRef = rootRef.child(id)
        let playerRef = currentRoomRef?.child("player")
        currentPlayerRef = playerRef?.childByAutoId()
        let teamRef = currentPlayerRef?.child("team")
        teamRef?.setValue("x")
        teamChangeHook?(.cross)
    }
    func joinRoom(id: String) {
        currentRoomRef = rootRef.child(id)
        let playerRef = currentRoomRef?.child("player")
        currentPlayerRef = playerRef?.childByAutoId()
        let teamRef = currentPlayerRef?.child("team")
        teamRef?.setValue("o")
        teamChangeHook?(.zero)
    }
    
    func updateState(state: [String:String]) {
        let stateRef = currentRoomRef?.child("state")
        stateRef?.setValue(state as Any)
    }
    
    func teamDidUpdated(_ action: @escaping (TicTacManager.State)->Void) {
        teamChangeHook = action
    }
    
    func updateWinner(_ state: String) {
        let winnerRef = currentRoomRef?.child("winner")
        let stateRef = currentRoomRef?.child("state")
        stateRef?.removeValue()
        winnerRef?.setValue(state)
    }

    
    func observeState(_ action: @escaping ([Int:String]) -> Void) {
        let stateRef = currentRoomRef?.child("state")
        func update(snapshot: DataSnapshot) {
            if let value = snapshot.value as? [String: String] {
                let dict = Dictionary<Int, String>(uniqueKeysWithValues: value.compactMap({ key, value in
                    if let intKey = Int(key) {
                        return (intKey, value)
                    } else {
                        return nil
                    }
                }))
                action(dict)
            }
        }
        stateRef?.getData(completion: { _, snapshot in
            update(snapshot: snapshot)
        })
        stateRef?.observe(.value, with: { snapshot in
            update(snapshot: snapshot)
        })
    }
    
    func observeLostState(forState state: TicTacManager.State, action: @escaping () -> Void) {
        currentRoomRef?.observe(.childAdded, with: { snapshot in
            print(snapshot)
            if let teamStr = snapshot.value as? String, let team = TicTacManager.State(rawValue: teamStr), state != team {
                action()
            }
        })
    }
}
