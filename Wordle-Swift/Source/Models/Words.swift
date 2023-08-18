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

class WordListParser {
    static func fetch() -> WordList {
        return Bundle.main.decode(WordList.self, from: "word_list.json")
    }
}
