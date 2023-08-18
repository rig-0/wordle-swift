//
//  Game.swift
//  ©️ 2023 0100
//

import Foundation

class Game {
    
    static let instance = Game()
    
    public var correctWord: String
    public var wordList: WordList
    
    init() {
        let wordList = WordListParser.fetch()
        self.wordList = wordList
        self.correctWord = ""
    }
    
    public func start() {
        self.correctWord = wordList.starters.randomElement()?.uppercased() ?? ""
        print("Word:", correctWord)
    }
}

