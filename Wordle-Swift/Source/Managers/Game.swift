//
//  Game.swift
//  ©️ 2023 0100
//

import Foundation

class Game {
    
    private var words = Words()
    
    public var gameState: GameState = .playing
    public var correctWord: String?
    public let numberOfAttempts = 6
    public let wordLength = 5
    
    init() {}
    
    public func start() {
        self.correctWord = self.words.randomWord
        print("Word:", correctWord ?? "Unknown")
    }
    
    public func isValid(attemptedWord: String) -> Bool {
        return self.words.isValid(attemptedWord)
    }
    
    public func isCorrect(attemptedWord: String) -> Bool {
        return attemptedWord == self.correctWord
    }
}

