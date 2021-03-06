//
//  Card.swift
//  Schnapsen
//
//  Created by Joseph Schmidt on 1/9/19.
//  Copyright © 2019 Joseph Schmidt. All rights reserved.
//

import Foundation

struct Card: Hashable {
    
    var suit: String
    var value: Int
    var symbol: String
    private var identifier: Int
    var isHighlighted = false
    var marriage = false
    
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    private static var identifierFactory = 0
    
    private static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    
    init(suit: String, value: Int, symbol: String) {
        self.suit = suit
        self.value = value
        self.symbol = symbol
        self.identifier = Card.getUniqueIdentifier()
    }
    
}
