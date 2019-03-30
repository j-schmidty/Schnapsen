//
//  SMarriageButton.swift
//  Schnapsen
//
//  Created by Joseph Schmidt on 3/29/19.
//  Copyright © 2019 Joseph Schmidt. All rights reserved.
//

import UIKit

class SMarriageButton: UIButton {

    var isOn = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initButton()
    }
    
    func initButton() {
        layer.borderWidth = 2.0
        layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        layer.cornerRadius = frame.size.height / 2
        
        setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        addTarget(self, action: #selector(SMarriageButton.buttonPressed), for: .touchUpInside)
    }
    
    @objc func buttonPressed() {
        activateButton(bool: !isOn)
    }
    
    func activateButton(bool: Bool) {
        isOn = bool
        
        let color = bool ? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) : .clear
        let titleColor = bool ? #colorLiteral(red: 0.07865277009, green: 0.523933217, blue: 0.2461320825, alpha: 1) : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        setTitleColor(titleColor, for: .normal)
        backgroundColor = color
    }
}
