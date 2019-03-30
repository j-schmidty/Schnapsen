//
//  ViewController.swift
//  Schnapsen
//
//  Created by Joseph Schmidt on 1/9/19.
//  Copyright © 2019 Joseph Schmidt. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        updateViewFromModel()
        updateTrumpCardLabel()
        updateCurrentPlayerLabel()
        updateCurrentPlayerPointsLabel()
    }
    
    private var game = Schnapsen()
    
    @IBAction func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.firstIndex(of: sender) {
            let canChooseCard = game.chooseCard(at: cardNumber)
            if canChooseCard {
                if game.gameIsOver {
                    toggleHidingCardView()
                    updateGameOverView()
                } else if game.playersSwitched {
                    toggleHidingCardView()
                    updatePassPhoneView()
                }
                updateViewFromModel()
                updateCurrentTrickLabel()
                updateCurrentPlayerLabel()
                updateCurrentPlayerPointsLabel()
                updateTrumpCardLabel()
                toggleHidingPassPhoneView()
                print(game)
            } else {
                print("cannot choose card \(cardNumber)")
            }
        } else {
            print("chosen card was not in cardButtons")
        }
    }
    
    @IBOutlet var cardButtons: [UIButton]!
    
    @IBOutlet weak var currentTrickLabel: UILabel!
    
    @IBOutlet weak var trumpCardLabel: UILabel!
    
    @IBOutlet weak var trumpCardText: UILabel!
    
    @IBOutlet weak var currentPlayerLabel: UILabel!
    
    @IBOutlet weak var currentPlayerPointsLabel: UILabel!
    
    @IBOutlet weak var playersTurnLabel: UILabel!
    
    @IBOutlet weak var passPhoneLabel: UILabel!
    
    @IBOutlet weak var continueButton: UIButton!
    
    @IBOutlet var marriageButton: SMarriageButton!
    
    @IBAction func touchContinue() {
        if game.gameIsOver {
            game = Schnapsen()
            viewDidLoad()
        }
        toggleHidingPassPhoneView()
        toggleHidingCardView()
    }
    
    @IBAction func touchMarriage(_ sender: UIButton) {
        // Finds all marriages in the current player's hand
        let (m1Card1, m1Card2, m2Card1, m2Card2) = findMarriages()
        var card1: Card? = nil
        var card2: Card? = nil
        
        if m1Card1 != nil && m2Card1 != nil { // if there are two marriages in the player's hand
            
            let marriage1 = "\(m1Card1!.suit)\(m1Card1!.value) and \(m1Card2!.suit)\(m1Card2!.value)"
            let marriage2 = "\(m2Card1!.suit)\(m2Card1!.value) and \(m2Card2!.suit)\(m2Card2!.value)"
            let alert = UIAlertController(title: "Which marriage do you want to declare?", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: marriage1, style: .default, handler: { action in
                card1 = m1Card1
                card2 = m1Card2
                self.marriageButton.buttonPressed()
            }))
            alert.addAction(UIAlertAction(title: marriage2, style: .default, handler: { action in
                card1 = m2Card1
                card2 = m2Card2
                self.marriageButton.buttonPressed()
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action in
                self.marriageButton.buttonPressed()
            }))
            self.present(alert, animated: true)
            
        } else if m1Card1 != nil { // if there is one marriage in the player's hand
            
            let marriage1 = "\(m1Card1!.suit)\(m1Card1!.value) and \(m1Card2!.suit)\(m1Card2!.value)"
            
            let alert = UIAlertController(title: "Are you sure you want to declare this marriage?", message: marriage1, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                card1 = m1Card1
                card2 = m1Card2
                self.marriageButton.buttonPressed()
            }))
            alert.addAction(UIAlertAction(title: "No", style: .default, handler: { action in
                self.marriageButton.buttonPressed()
            }))
            self.present(alert, animated: true)
            
        } else { // if no marriages in the player's hand
            
            let alert = UIAlertController(title: "No marriages found!", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                self.marriageButton.buttonPressed()
            }))
            self.present(alert, animated: true)
            
        }
        
        // card1 == nil if there is no marriage to declare (player did not want to or no marriages found)
        
        if card1 != nil && card2 != nil {
            game.declareMarriage(card1: card1!, card2: card2!)
        }
        updateCurrentPlayerPointsLabel()
    }
    
    private func findMarriages() -> (Card?, Card?, Card?, Card?) {
        let cards = game.playerOneTurn ? game.playerOneCards : game.playerTwoCards
        var marriages = [String : [Card]]()
        for card in cards {
            if card.value == 4 || card.value == 3 {
                if card.suit == "♠" {
                    if marriages["♠"] != nil {
                        marriages["♠"]! += [card]
                    } else {
                        marriages["♠"] = [card]
                    }
                } else if card.suit == "♣" {
                    if marriages["♣"] != nil {
                        marriages["♣"]! += [card]
                    } else {
                        marriages["♣"] = [card]
                    }
                } else if card.suit == "♥" {
                    if marriages["♥"] != nil {
                        marriages["♥"]! += [card]
                    } else {
                        marriages["♥"] = [card]
                    }
                } else if card.suit == "♦" {
                    if marriages["♦"] != nil {
                        marriages["♦"]! += [card]
                    } else {
                        marriages["♦"] = [card]
                    }
                }
            }
        }
        var m1Card1: Card? = nil
        var m1Card2: Card? = nil
        var m2Card1: Card? = nil
        var m2Card2: Card? = nil
        for (_, cards) in marriages {
            if cards.count == 2 {
                if m1Card1 == nil {
                    m1Card1 = cards[0]
                    m1Card2 = cards[1]
                } else {
                    m2Card1 = cards[0]
                    m2Card2 = cards[1]
                }
            }
        }
        return (m1Card1, m1Card2, m2Card1, m2Card2)
    }
    
    //  ///////////////////////////////////////////////////////////////
    //  UPDATE VIEW
    //  ///////////////////////////////////////////////////////////////
    
    private func updateViewFromModel() {
        print("Updating view from model...")
        var cards = game.playerOneTurn ? game.playerOneCards : game.playerTwoCards
        for index in cardButtons.indices {
            print("grabbing card \(index) from player \(game.playerOneTurn ? 1 : 2)")
            print(cards.count)
            // get the button, get the card, update the button title with info from card
            let button = cardButtons[index]
            if index < cards.count {
                let card = cards[index]
                button.setTitle(title(for: card), for: UIControl.State.normal)
            } else {
                button.setTitle("", for: UIControl.State.normal)
            }
        }
    }
    
    private func updateCurrentTrickLabel() {
        if game.leadCard != nil {
            currentTrickLabel.text = "Your opponent played " + title(for: game.leadCard!)
        } else {
            currentTrickLabel.text = "You are on lead!"
        }
    }
    
    private func updateTrumpCardLabel() {
        var text = title(for: game.trumpCard)
        if (game.stock.count == 0) {
            text = game.trumpCard.suit
        }
        trumpCardLabel.text = text
    }
    
    private func updateCurrentPlayerLabel() {
        currentPlayerLabel.text = "Player \(game.currentPlayer())"
    }
    
    private func updateCurrentPlayerPointsLabel() {
        let points = game.playerOneTurn ? game.playerOnePoints : game.playerTwoPoints
        currentPlayerPointsLabel.text = "Trick Points: \(points)"
    }
    
    private func updatePassPhoneView() {
        let player = game.playerOneTurn ? "One" : "Two"
        playersTurnLabel.text = "Player \(player)'s Turn"
        passPhoneLabel.text = "(Pass the phone to player \(player.lowercased()))"
    }
    
    private func updateGameOverView() {
        let playerOneWon = game.playerOnePoints >= 66
        let winner: String
        let winnerPoints: Int
        let winnerTricks: Int
        let loser: String
        let loserPoints: Int
        let loserTricks: Int
        if playerOneWon {
            winner = "One"
            winnerPoints = game.playerOnePoints
            winnerTricks = game.playerOneTricks.count / 2
            loser = "Two"
            loserPoints = game.playerTwoPoints
            loserTricks = game.playerTwoTricks.count / 2
        } else {
            winner = "Two"
            winnerPoints = game.playerTwoPoints
            winnerTricks = game.playerTwoTricks.count / 2
            loser = "One"
            loserPoints = game.playerOnePoints
            loserTricks = game.playerOneTricks.count / 2
        }
        playersTurnLabel.text = "Player \(winner) Won with \(winnerPoints) points and \(winnerTricks) tricks!"
        passPhoneLabel.text = "(Player \(loser) had \(loserPoints) points and \(loserTricks) tricks)"
        
    }
    
    //  /////////////////////////////////////////////////////////////
    //  TOGGLE VIEWS
    //  /////////////////////////////////////////////////////////////
    
    private func toggleHidingCardView() {
        for cardButton in cardButtons {
            cardButton.isHidden.toggle()
        }
        currentTrickLabel.isHidden.toggle()
        trumpCardLabel.isHidden.toggle()
        trumpCardText.isHidden.toggle()
        currentPlayerLabel.isHidden.toggle()
        currentPlayerPointsLabel.isHidden.toggle()
        marriageButton.isHidden.toggle()
    }
    
    private func toggleHidingPassPhoneView() {
        playersTurnLabel.isHidden.toggle()
        passPhoneLabel.isHidden.toggle()
        continueButton.isHidden.toggle()
    }
    
    private func title(for card: Card) -> String {
        return card.suit + card.symbol
    }
}

