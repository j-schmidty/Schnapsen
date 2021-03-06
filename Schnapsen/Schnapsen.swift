//
//  Schnapsen.swift
//  Schnapsen
//
//  Created by Joseph Schmidt on 1/9/19.
//  Copyright © 2019 Joseph Schmidt. All rights reserved.
//

import Foundation

struct Schnapsen {
    
    let POINTS = 66
    
    var suits: [String] = ["♠", "♣", "♥", "♦"]
    var values: [Int] = [2, 3, 4, 10, 11]
    var symbols: [String] = ["J", "Q", "K", "10", "A"]
    
    var stock = [Card]()
    
    var stockIsClosed = false
    
    var playerOneCards = [Card]()
    var playerTwoCards = [Card]()
    
    var playerOneTricks = [Card]()
    var playerTwoTricks = [Card]()
    
    var playerOnePoints: Int
    var playerTwoPoints: Int
    
    var trumpCard: Card
    
    var leadCard: Card?
    
    var playerOneWon = true
    
    var playerOneTurn = true
    
    var playersSwitched = false
    
    var marriageSuit: String?
    
    var gameIsOver = false
    
    // Returns 1 if current player is player one and returns 2
    // if current player is player two
    func currentPlayer() -> Int {
        if leadCard == nil {
            return playerOneWon ? 1 : 2
        } else {
            return playerOneWon ? 2 : 1
        }
    }
    
    // Returns true if the given index points to a card
    // in the current player's hand that can be played
    // and is then played
    mutating func chooseCard( at index: Int) -> Bool {
        assert(index >= 0 && index < 5)
        let cards = playerOneTurn ? playerOneCards : playerTwoCards
        
        // if player declared a marriage, they must play the king or queen
        if marriageSuit != nil && cards[index].suit != marriageSuit
            && cards[index].value != 3 && cards[index].value != 4 {
            return false
        }
        marriageSuit = nil
        
        if leadCard == nil { // if there is no lead card, then set card to be new lead card
            
            if index >= cards.count {
                return false
            }
            leadCard = playerOneTurn ? playerOneCards.remove(at: index) : playerTwoCards.remove(at: index)
            playerOneTurn.toggle()
            playersSwitched = true
            return true
            
        } else if !stockIsClosed { // if stock is open
            
            let card = playerOneTurn ? playerOneCards.remove(at: index) : playerTwoCards.remove(at: index)
            playCards(card: card)
            return true
            
        } else { // if stock is closed
            
            // Cases:
            // - the player is not on lead, you must follow suit
            // - if they cannot follow suit, they must play trump card
            // - if they cannot play trump, they can play any card

            // get current player's cards
            let currPlayerCards = playerOneTurn ? playerOneCards : playerTwoCards
            
            if index >= currPlayerCards.count {
                return false
            }

            // find if current player is able to follow suit
            // find if current player has any trump cards
            var hasSuit = false
            var hasTrump = false
            for currPlayerCard in currPlayerCards {
                if currPlayerCard.suit == leadCard?.suit {
                    hasSuit = true
                }
                if currPlayerCard.suit == trumpCard.suit {
                    hasTrump = true
                }
            }

            // peek at card at index -- don't want to remove it if it cannot be played
            var card = playerOneTurn ? playerOneCards[index] : playerTwoCards[index]
            // if the current player could follow suit and did not, return false
            // if the current player could not follow suit and had any trumps
            // and did not play them, return false
            if hasSuit && leadCard!.suit != card.suit {
                return false
            } else if !hasSuit && hasTrump && card.suit != trumpCard.suit {
                return false
            }

            // we know the card can be played so we can remove it now
            if playerOneTurn {
                card = playerOneCards.remove(at: index)
            } else {
                card = playerTwoCards.remove(at: index)
            }
            
            playCards(card: card)
            return true
        }
    }
    
    // Completes the next trick by comparing leadCard to card and updating
    // players' hands based on who won. Also deals more cards if the stock
    // is not closed and clears the leadCard variable
    private mutating func playCards(card: Card) {
        // if trick cards have same suit, compare their values
        // to determine the winner of the trick
        var leadWon = false;
        if leadCard!.suit == card.suit {
            leadWon = leadCard!.value > card.value
        } else {
            // at this point we know that the cards do NOT have the same
            // suit so if the player not on lead played a trump, we know
            // they win, and if they did not play a trump, we know they lose
            leadWon = card.suit != trumpCard.suit
        }
        
        let playerOneWonLastTrick = playerOneWon
        
        // if it is player one's turn, then player one won if whoever was on lead lost (!leadWon)
        // if it is not player one's turn, then player one won if whoever was on lead won (leadWon)
        playerOneWon = playerOneTurn ? !leadWon : leadWon
        
        // keeps track of whether or not the player who
        // is on lead will change for the next trick
        if (playerOneWonLastTrick != playerOneWon) {
            playersSwitched = true
        }
        
        // give the trick cards to the winner
        if playerOneWon {
            playerOneTricks += [leadCard!, card]
            playerOnePoints += leadCard!.value + card.value
        } else {
            playerTwoTricks += [leadCard!, card]
            playerTwoPoints += leadCard!.value + card.value
        }
        
        // update who is on lead based on who won this trick
        playerOneTurn = playerOneWon
        
        // clear the leadCard variable in preparation of next trick
        leadCard = nil
        
        // Check if there is a winner
        if playerOnePoints >= POINTS || playerTwoPoints >= POINTS {
            gameIsOver = true
        } else {
            // deal more cards to players from the stock
            dealCards()
        }
    }
    
    private mutating func dealCards() {
        while playerOneCards.count < 5 && playerTwoCards.count < 5 && stock.count > 1 {
            playerOneCards.append(stock.remove(at: stock.startIndex))
            playerTwoCards.append(stock.remove(at: stock.startIndex))
        }
        if stock.count == 0 && !stockIsClosed {
            stockIsClosed = true
        }
    }
    
    mutating func swapTrumpCard( at index: Int) {
        if (stockIsClosed != true) {
            if playerOneTurn { // player one's turn
                if playerOneCards[index].suit == trumpCard.suit &&
                    playerOneCards[index].value == 2 { // make sure you can swap
                    
                    let card = playerOneCards.remove(at: index)
                    playerOneCards.insert(trumpCard, at: index)
                    stock.remove(at: stock.count - 1)
                    stock.append(card)
                    trumpCard = card
                }
            } else { // player two's turn
                if playerTwoCards[index].suit == trumpCard.suit &&
                    playerTwoCards[index].value == 2 { // make sure you can swap
                    
                    let card = playerTwoCards.remove(at: index)
                    playerTwoCards.insert(trumpCard, at: index)
                    stock.remove(at: stock.count - 1)
                    stock.append(card)
                    trumpCard = card
                }
            }
        }
    }
    
    mutating func declareMarriage(card1: Card, card2: Card) {
        let marriage = card1.marriage && card2.marriage
        let hasKing = card1.value == 4 || card2.value == 4
        let hasQueen = card1.value == 3 || card2.value == 3
        let isTrumpMarriage = card1.suit == trumpCard.suit
        if !marriage && card1.suit == card2.suit && hasKing && hasQueen {
            if playerOneTurn {
                if isTrumpMarriage {
                    playerOnePoints += 40
                } else {
                    playerOnePoints += 20
                }
            } else {
                if isTrumpMarriage {
                    playerTwoPoints += 40
                } else {
                    playerTwoPoints += 20
                }
            }
            marriageSuit = card1.suit
        }
    }
    
    init() {
        // create cards and add to stock
        for suit in suits {
            let jack = Card(suit: suit, value: values[0], symbol: symbols[0])
            let queen = Card(suit: suit, value: values[1], symbol: symbols[1])
            let king = Card(suit: suit, value: values[2], symbol: symbols[2])
            let ten = Card(suit: suit, value: values[3], symbol: symbols[3])
            let ace = Card(suit: suit, value: values[4], symbol: symbols[4])
            stock += [ten, jack, queen, king, ace]
        }
        playerOnePoints = 0
        playerTwoPoints = 0
        // shuffle cards
        stock.shuffle()
        // pick trump card
        trumpCard = stock.remove(at: stock.startIndex)
        // add trump card to end of stock
        stock.append(trumpCard)
        // deal 5 cards to each player
        dealCards()
    }
    
}
