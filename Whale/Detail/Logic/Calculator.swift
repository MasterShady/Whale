//
//  Calculator.swift
//  Whale
//
//  Created by 刘思源 on 2023/8/21.
//

import Foundation


extension Double{
    var hasDecimalPart: Bool{
        let tolerance = 1e-10 // 设置一个很小的阈值
        let absoluteValue = abs(self)
        let fractionalPart = absoluteValue - floor(absoluteValue)
        return fractionalPart > tolerance
    }
    
    static func toString(_ double: Double?) ->String{
        let notNilDouble = double ?? 0
        if notNilDouble.hasDecimalPart{
            return String(notNilDouble)
        }else{
            return String(Int(notNilDouble))
        }
    }
}


protocol CalculatorDelegate: AnyObject {
    func calculatorDidUpdateDisplay(_ display: String)
    func hasOperatorSymbol(_ hasSymbol: Bool)
    
}

struct Calculator {
    private var display: String = "0"
    var currentInput: String = ""
    private var operand1: Double?
    private var operatorSymbol: String? {
        didSet{
            if let _ = operatorSymbol{
                self.delegate?.hasOperatorSymbol(true)
            }else{
                self.delegate?.hasOperatorSymbol(false)
            }
        }
    }
    
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
            let operand1Str = Double.toString(operand1)
            display = "\(operand1Str) \(operatorSymbol) \(currentInput)"
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
        if let existingOperand1 = operand1, let existingOperator = operatorSymbol {
            let operand2 = Double(currentInput) ?? 0
            calculatePartialResult(existingOperand1, existingOperator, operand2)
            if existingOperator == "+"{
                let value = existingOperand1 + operand2
                currentInput = Double.toString(value)
            }else{
                let value = existingOperand1 + operand2
                currentInput = Double.toString(value)
            }
            
            operand1 = nil
            operatorSymbol = nil
        }
        
        //updateDisplay()
    }
    
    private mutating func handleDelete() {
        if !currentInput.isEmpty {
            currentInput.removeLast()
        }
    }
    
    private mutating func clear() {
        currentInput = ""
        operand1 = nil
        operatorSymbol = nil
    }
}

