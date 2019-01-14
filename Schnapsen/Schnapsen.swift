//
//  Schnapsen.swift
//  Schnapsen
//
//  Created by Joseph Schmidt on 1/9/19.
//  Copyright © 2019 Joseph Schmidt. All rights reserved.
//

import Foundation

struct Schnapsen {
    
    var suits: [String] = ["♠", "♣", "♥", "♦"]
    var values: [Int] = [1, 2, 3, 4, 5]
    var symbols: [String] = ["J", "Q", "K", "10", "A"]
    var cardPoints: [Int] = [10, 2, 3, 4, 11]
    
    var stock = [Card]()
    
    var stockIsClosed = false
    
    var playerOneCards = [Card]()
    var playerTwoCards = [Card]()
    
    var playerOneTricks = [Card]()
    var playerTwoTricks = [Card]()
    
    var trumpCard: Card
    
    var leadCard: Card?
    
    var playerOneWon = true
    
    var turn = 0
    
    // TODO - fix this... playerOneWon broke it
    func currentPlayer() -> Int {
        if leadCard == nil {
            return playerOneWon ? 1 : 2
        } else {
            return playerOneWon ? 2 : 1
        }
    }
    
    mutating func chooseCard( at index: Int) {
        // find and remove played card
        let card = turn == 0 ? playerOneCards.remove(at: index) : playerTwoCards.remove(at: index)
        if (stockIsClosed != true) { // stock has not been closed
            if leadCard != nil { // player is not on lead
                if leadCard?.suit == card.suit { // trick cards have same suit
                    if card.value > (leadCard?.value)! { // player who led lost
                        playerOneWon = !playerOneWon
                    } // else player who led won (lastTrickWinner)
                } else if card.suit == trumpCard.suit { // player who led lost
                    playerOneWon = !playerOneWon
                }
                if playerOneWon {
                    playerOneTricks += [leadCard!, card]
                    updatePlayersCards()
                } else {
                    playerTwoTricks += [leadCard!, card]
                    playerOneWon = false
                    updatePlayersCards()
                }
                leadCard = nil
            } else { // player is on lead
                leadCard = card
            }
        } else { // stock has been closed
//            if leadCard != nil { // player is not on lead
//                // Cases:
//                // - player not on lead must follow suit
//                // - cannot follow suit, must play trump card
//                // - cannot play trump, choose any card
//
//                // get current player's cards
//                let currPlayerCards = lastTrickWinner == 0 ? playerOneCards : playerTwoCards
//
//                // make sure currernt player follows suit if can
//                var hasSuit = false
//                for card in currPlayerCards {
//                    if card.suit == leadCard?.suit {
//                        hasSuit = true
//                    }
//                }
//
//             // TODO: start here -- make sure current player plays trump if in hand
//
//                if leadCard?.suit == card.suit {
//                    if card.value > (leadCard?.value)! { // player who led lost
//                        winner = ~winner
//                    } // else player who led won
//                }
//            } else { // player is on lead
//                leadCard = card
//            }
        }
        turn += 1
    }
    
    private mutating func updatePlayersCards() {
        if stock.count > 1 {
            if playerOneWon {
                playerOneCards.append(stock.remove(at: stock.startIndex))
                playerTwoCards.append(stock.remove(at: stock.startIndex))
            } else {
                playerTwoCards.append(stock.remove(at: stock.startIndex))
                playerOneCards.append(stock.remove(at: stock.startIndex))
            }
        } else if stockIsClosed != true {
            stockIsClosed = true
        }
    }
    
    mutating func swapTrumpCard( at index: Int) {
        if (stockIsClosed != true) {
            if turn == 0 { // player one's turn
                let card = playerOneCards[index]
                if card.suit == trumpCard.suit {
                    playerOneCards.append(trumpCard)
                    trumpCard = playerOneCards.remove(at: index)
                }
            } else { // player two's turn
                let card = playerTwoCards[index]
                if card.suit == trumpCard.suit {
                    playerTwoCards.append(trumpCard)
                    trumpCard = playerTwoCards.remove(at: index)
                }
            }
        }
    }
    
    init() {
        // create cards and add to stock
        for suit in suits {
            let ten = Card(suit: suit, value: values[0], symbol: symbols[0], cardPoints: cardPoints[0])
            let jack = Card(suit: suit, value: values[1], symbol: symbols[1], cardPoints: cardPoints[1])
            let queen = Card(suit: suit, value: values[2], symbol: symbols[2], cardPoints: cardPoints[2])
            let king = Card(suit: suit, value: values[3], symbol: symbols[3], cardPoints: cardPoints[3])
            let ace = Card(suit: suit, value: values[4], symbol: symbols[4], cardPoints: cardPoints[4])
            stock += [ten, jack, queen, king, ace]
        }
        // shuffle cards by swapping two cards at a time between 20 and 40 times
        stock.shuffle()
//        let randomInt = Int.random(in: 20..<40)
//        for _ in 0..<randomInt {
//            let randomIndex1 = Int.random(in: 0..<stock.count)
//            var randomIndex2 = Int.random(in: 0..<stock.count)
//            while (randomIndex1 == randomIndex2) {
//                randomIndex2 = Int.random(in: 0..<stock.count)
//            }
//            let card = stock[randomIndex1]
//            stock[randomIndex1] = stock[randomIndex2]
//            stock[randomIndex2] = card
//        }
        // deal 5 cards to each player
        for _ in 0..<5 {
            playerOneCards.append(stock.remove(at: stock.startIndex))
        }
        for _ in 0..<5 {
            playerTwoCards.append(stock.remove(at: stock.startIndex))
        }
        // pick trump card
        trumpCard = stock.remove(at: stock.startIndex)
        // add trump card to end of stock
        stock.append(trumpCard)
    }
    
}
