//
//  BudgetStore.swift
//  Whale
//
//  Created by 刘思源 on 2023/8/22.
//

import Foundation


class BudgetStore{
    static func addBudget(budget: BudgetTransaction){
        let json = budget.toJSON()!
        UserDefaults.standard.set(json, forKey: budget.id)
        if var list = UserDefaults.standard.object(forKey: "budgetIdList") as? [String]{
            list.append(budget.id)
            UserDefaults.standard.set(list, forKey: "budgetIdList")
        }else{
            let list = [budget.id]
            UserDefaults.standard.set(list, forKey: "budgetIdList")
        }
        UserDefaults.standard.synchronize()
    }
    
    static func getAllBudgets() -> [BudgetTransaction]{
        if let list = UserDefaults.standard.object(forKey: "budgetIdList") as? [String]{
            return list.map { id in
                let json = UserDefaults.standard.object(forKey: id) as! [String: Any]
                return BudgetTransaction.deserialize(from: json)!
            }
        }
        return .init()
    }
    
    
    static func getAllDayBudgetsOfMonth(monthDate: Date) -> [DayBudgets]{
        //根据月份获取当月每天的budgets.
        if var list = UserDefaults.standard.object(forKey: "budgetIdList") as? [String]{
            let days = [DayBudgets]()
            for id in list{
                let dateString = id.components(separatedBy: "_")[1]
                let date = Date(string: dateString, format: "YYYYMMdd")
                
            }
        }
        return .init()
        
    }
    
}
