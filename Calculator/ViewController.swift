//
//  ViewController.swift
//  Calculator
//
//  Created by Kamile Medzeviciute on 06/11/2017.
//  Copyright © 2017 Kamile Medzeviciute. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    
    var userIsInTheMiddleOfTyping = false
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            if !textCurrentlyInDisplay.contains(".") || digit != "." {
                display.text = textCurrentlyInDisplay + digit
            }
        } else {
            if (digit != ".") {
                display.text = digit
            } else {
                display.text = "0."
            }
            userIsInTheMiddleOfTyping = true
        }
    }
    
    var displayValue: Double {
        get {
           return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    private var brain = CalculatorBrain()
    
    @IBAction func performOperation(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        if let result = brain.result {
            displayValue = result
        }
    }
}

