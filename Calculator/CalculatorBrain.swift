//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Kamile Medzeviciute on 13/11/2017.
//  Copyright © 2017 Kamile Medzeviciute. All rights reserved.
//

import Foundation

struct CalculatorBrain {
    
    private var accumulator: Double?
    var description = ""
    
    private enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double, Double) -> Double)
        case equals
    }
    
    private var operations: Dictionary<String, Operation> = [
        "𝛑": Operation.constant(Double.pi),
        "e": Operation.constant(M_E),
        "C" : Operation.constant(0),
        "√": Operation.unaryOperation(sqrt),
        "cos": Operation.unaryOperation(cos),
        "%" : Operation.unaryOperation({$0 / 100}),
        "±" : Operation.unaryOperation({ -$0 }),
        "+" : Operation.binaryOperation({ $0 + $1 }),
        "-" : Operation.binaryOperation({ $0 - $1 }),
        "×" : Operation.binaryOperation({ $0 * $1 }),
        "÷" : Operation.binaryOperation({ $0 / $1 }),
        "=" : Operation.equals
    ]
    
    mutating func performOperation(_ symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let value):
                if value != 0 {
                    accumulator = value
                    if !resultIsPending {
                        description = symbol
                    } else {
                        description += String(symbol)
                    }
                } else {
                    accumulator = 0
                    description = ""
                    pendingBinaryOperation = nil
                }
                
            case .unaryOperation(let function):
                if accumulator != nil {
                    if !resultIsPending {
                        description = symbol + "(" + description + ")"
                    } else {
                        description += symbol + "(\(accumulator!))"
                    }
                   
                    accumulator = function(accumulator!)
                }
                
            case .binaryOperation(let function):
                if accumulator != nil {
                    performPendingBinaryOperation()
                    if !resultIsPending {
                        description = description + symbol
                    } else {
                        description += "\(accumulator!)"
                    }
                    
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                    
                    accumulator = nil
                }
              
            case .equals:
                performPendingBinaryOperation()
            }
        }
    }
    
    private mutating func performPendingBinaryOperation() {
        if pendingBinaryOperation != nil && accumulator != nil {
            description += "\(accumulator!)"
            accumulator = pendingBinaryOperation?.perform(with: accumulator!)
            pendingBinaryOperation = nil
        }
    }
    
    var resultIsPending: Bool {
        get {
            return pendingBinaryOperation != nil
        }
    }
    
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    private struct PendingBinaryOperation {
        let function: (Double, Double) -> Double
        let firstOperand: Double
        
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    
    mutating func setOperand(_ operand: Double) {
        accumulator = operand
        if (!resultIsPending) {
            description = String(accumulator!)
        }
    }
    
    var result: Double? {
        get {
            return accumulator
        }
    }
}
