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
    
    private func toggleHidingCardView() {
        for cardButton in cardButtons {
            cardButton.isHidden.toggle()
        }
        currentTrickLabel.isHidden.toggle()
        trumpCardLabel.isHidden.toggle()
        trumpCardText.isHidden.toggle()
        currentPlayerLabel.isHidden.toggle()
        currentPlayerPointsLabel.isHidden.toggle()
    }
    
    private func toggleHidingPassPhoneView() {
        playersTurnLabel.isHidden.toggle()
        passPhoneLabel.isHidden.toggle()
        continueButton.isHidden.toggle()
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
    
    @IBAction func touchContinue() {
        toggleHidingPassPhoneView()
        toggleHidingCardView()
    }
    
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
    
    private func title(for card: Card) -> String {
        return card.suit + card.symbol
    }
}

