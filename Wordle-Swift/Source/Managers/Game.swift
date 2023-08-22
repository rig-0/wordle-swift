//
//  Game.swift
//  ©️ 2023 0100
//

import Foundation

class Game {
    
    static let instance = Game()
    
    public var gameState: GameState = .playing
    public var correctWord: String
    public var wordList: WordList
    public let numberOfAttempts = 6
    public var activeAttempt = 0
    
    init() {
        let wordList = WordListParser.fetch()
        self.wordList = wordList
        self.correctWord = ""
    }
    
    public func start() {
        self.correctWord = wordList.starters.randomElement()?.uppercased() ?? ""
        print("Word:", correctWord)
    }
    
    public func keyboardKeyStates(with tileViews: [[TileView]]) -> [Key : KeyState] {

        var keyStates: [Key : KeyState] = [:]
        for key in Key.allCases {
            keyStates[key] = .tbd
        }
        
        let tileViews = tileViews.joined()
        let absentTiles = tileViews.filter({ $0.state == .absent })
        for tileView in absentTiles {
            guard let key = tileView.key else { continue }
            keyStates[key] = tileView.state
        }
        
        let presentTiles = tileViews.filter({ $0.state == .present })
        for tileView in presentTiles {
            guard let key = tileView.key else { continue }
            keyStates[key] = tileView.state
        }
        
        let correctTiles = tileViews.filter({ $0.state == .correct })
        for tileView in correctTiles {
            guard let key = tileView.key else { continue }
            keyStates[key] = tileView.state
        }
        
        return keyStates
    }
}

