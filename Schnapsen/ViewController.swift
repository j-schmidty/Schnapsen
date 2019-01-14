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
    }
    
    private var game = Schnapsen()
    
    @IBAction func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.firstIndex(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
            updateCurrentTrickLabel()
            updateCurrentPlayerLabel()
            print(game)
        } else {
            print("chosen card was not in cardButtons")
        }
    }
    
    @IBOutlet var cardButtons: [UIButton]!
    
    @IBOutlet weak var currentTrickLabel: UILabel!
    
    @IBOutlet weak var trumpCardLabel: UILabel!
    
    @IBOutlet weak var currentPlayerLabel: UILabel!
    
    private func updateViewFromModel() {
        print("Updating view from model...")
        var cards = game.turn == 0 ? game.playerOneCards : game.playerTwoCards
        for index in cardButtons.indices {
            print("grabbing card \(index) from player \(game.turn % 2)")
            print(cards.count)
            let button = cardButtons[index]
            let card = cards[index]
            button.setTitle(title(for: card), for: UIControl.State.normal)
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
        trumpCardLabel.text = title(for: game.trumpCard)
    }
    
    private func updateCurrentPlayerLabel() {
        currentPlayerLabel.text = "Player \(game.currentPlayer())"
    }
    
    private func title(for card: Card) -> String {
        return card.suit + card.symbol
    }
}

