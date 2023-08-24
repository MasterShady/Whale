//
//  BudgetManager.swift
//  Whale
//
//  Created by 刘思源 on 2023/8/22.
//

import Foundation

class DayBudgets{
    var budgets: [BudgetTransaction] = .init()
    let day : Date
    
    init(day: Date) {
        //self.budgets = budgets
        self.day = day
    }
    
    func getBudget(type:BudgetType) -> [BudgetTransaction]{
        return budgets.filter { $0.type!.type == type}
    }
    
    var totalIncome: Double {
        budgets.reduce(0) { partialResult, budget in
            if budget.type?.type == .income{
                return partialResult + budget.amount
            }
            return partialResult
        }
    }
    
    var totalOutcome: Double {
        budgets.reduce(0) { partialResult, budget in
            if budget.type?.type == .outcome{
                return partialResult + budget.amount
            }
            return partialResult
        }
    }
    
    var maxIncomeBudget : BudgetTransaction{
        budgets.filter { $0.type!.type == .income}.max {
            return $0.amount > $1.amount
        }!
    }
    
    var maxOutcomeBudget : BudgetTransaction?{
        budgets.filter { $0.type!.type == .outcome}.max {
            return $0.amount > $1.amount
        }
    }
}

class BudgetManager{
    
    
    
}
