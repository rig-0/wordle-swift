//
//  Words.swift
//  ©️ 2023 0100
//

import Foundation

struct WordList: Decodable {
    var valid: [String]
    var starters: [String]
    
    public func isValid(_ word: String) -> Bool {
        if (valid + starters).contains(where: { $0.caseInsensitiveCompare(word) == .orderedSame }) {
            return true
        }
        
        return false
    }
}

class Words {
    
    lazy var wordList: WordList = {
        return Bundle.main.decode(WordList.self, from: "word_list.json")
    }()

    public var randomWord: String {
        if let testWord = UITesting() {
            return testWord
        }
        
        return self.wordList.starters.randomElement()?.uppercased() ?? ""
    }
    
    public func isValid(_ word: String) -> Bool {
        return self.wordList.isValid(word)
    }
    
    private func UITesting() -> String? {
        return ProcessInfo.processInfo.environment["correctWord"]
    }
}
