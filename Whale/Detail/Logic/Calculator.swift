//
//  Calculator.swift
//  Whale
//
//  Created by 刘思源 on 2023/8/21.
//

import Foundation

protocol CalculatorDelegate: AnyObject {
    func calculatorDidUpdateDisplay(_ display: String)
}

struct Calculator {
    private var display: String = "0"
    private var currentInput: String = ""
    private var operand1: Double?
    private var operatorSymbol: String?
    
    weak var delegate: CalculatorDelegate?
    
    mutating func handleInput(_ input: String) {
        switch input {
        case "0"..."9":
            currentInput += input
        case ".":
            if !currentInput.contains(".") {
                currentInput += input
            }
        case "+", "-":
            applyOperator(input)
        case "C":
            clear()
        case "=":
            calculateResult()
        case "x":
            handleDelete()
        default:
            break
        }
        
        updateDisplay()
    }
    
    private mutating func updateDisplay() {
        if let operatorSymbol = operatorSymbol {
            display = "\(operand1 ?? 0) \(operatorSymbol) \(currentInput)"
        } else {
            display = currentInput.isEmpty ? "0" : currentInput
        }
        delegate?.calculatorDidUpdateDisplay(display)
    }
    
    private mutating func applyOperator(_ operatorSymbol: String) {
        if !currentInput.isEmpty {
            if let operand = Double(currentInput) {
                if let existingOperand1 = operand1, let existingOperator = self.operatorSymbol {
                    calculatePartialResult(existingOperand1, existingOperator, operand)
                } else {
                    operand1 = operand
                }
            }
            currentInput = ""
            self.operatorSymbol = operatorSymbol
        }
    }
    
    private mutating func calculatePartialResult(_ operand1: Double, _ operatorSymbol: String, _ operand2: Double) {
        switch operatorSymbol {
        case "+":
            self.operand1 = operand1 + operand2
        case "-":
            self.operand1 = operand1 - operand2
        default:
            break
        }
    }
    
    private mutating func calculateResult() {
        if let existingOperand1 = operand1, let existingOperator = operatorSymbol, let operand2 = Double(currentInput) {
            calculatePartialResult(existingOperand1, existingOperator, operand2)
            currentInput = "\(existingOperand1 + operand2)"
            //operand1 = nil
            operatorSymbol = nil
        }
        
        updateDisplay()
    }
    
    private mutating func handleDelete() {
        if !currentInput.isEmpty {
            currentInput.removeLast()
        }
        
        updateDisplay()
    }
    
    private mutating func clear() {
        currentInput = ""
        operand1 = nil
        operatorSymbol = nil
        updateDisplay()
    }
    
    func getDisplay() -> String {
        return display
    }
}
