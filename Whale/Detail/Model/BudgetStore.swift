//
//  BudgetStore.swift
//  Whale
//
//  Created by 刘思源 on 2023/8/22.
//

import Foundation

enum DurationType: Int{
    case week
    case month
    case year
}


class DurationBudgets{
    var dayBudgetsList: [DayBudgets] = .init()
    var fromDate: Date
    var toDate: Date
    var totalIncome: Double{
        dayBudgetsList.reduce(0) { partialResult, dayBudgets in
            return partialResult + dayBudgets.totalIncome
        }
    }
    
    var isEmpty : Bool{
        dayBudgetsList.count == 0
    }
    
    var totalOutcome: Double{
        dayBudgetsList.reduce(0) { partialResult, dayBudgets in
            return partialResult + dayBudgets.totalOutcome
        }
    }
    init(fromDate: Date, toDate: Date) {
        self.fromDate = fromDate
        self.toDate = toDate
        
        var currentDate = fromDate
        var allDates: [Date] = []
        let calendar = Calendar.current
        while currentDate <= toDate {
            allDates.append(currentDate)
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
        self.dayBudgetsList = allDates.map({ date in
                .init(day: date)
        })
        
    }
    
    var maxOutcome: Double{
        var maxOutcome = 0.0
        for budget in dayBudgetsList{
            maxOutcome = max(maxOutcome, budget.totalOutcome)
        }
        return maxOutcome
    }
    
    var averageOutcome: Double {
        let total = dayBudgetsList.reduce(0) { partialResult, day in
            return partialResult + day.totalOutcome
        }
        return total/self.dayBudgetsList.count
    }
    
    var averageIncome: Double {
        let total = dayBudgetsList.reduce(0) { partialResult, day in
            return partialResult + day.totalIncome
        }
        return total/self.dayBudgetsList.count
    }
    
    var maxIncome: Double{
        var maxIncome = 0.0
        for budget in dayBudgetsList{
            maxIncome = max(maxIncome, budget.totalIncome)
        }
        return maxIncome
    }
    
    convenience init(monthDate:Date){
        self.init(fromDate: monthDate.fisrtDayOfMonth, toDate: monthDate.lastDayOfMonth)
    }
    
    convenience init(weekDate:Date){
        self.init(fromDate: weekDate.firstDateOfWeek, toDate: weekDate.lastDateOfWeek)
    }
    
    convenience init (yearDate: Date){
        self.init(fromDate: yearDate, toDate: yearDate.lastDayOfYear)
        //这里要改造一下. dayBudgetsList 中的日期为每个月的第一天
        var firstDays: [Date] = []
        let calendar = Calendar.current
        for month in 1...12 {
            var components = DateComponents()
            components.year = yearDate.year
            components.month = month
            components.day = 1
            if let firstDayOfMonth = calendar.date(from: components) {
                firstDays.append(firstDayOfMonth)
            }
        }
        self.dayBudgetsList = firstDays.map { date in
            return DayBudgets(day: date)
        }
    }
}




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
    
    static func deleteBudget(id:String){
        if var list = UserDefaults.standard.object(forKey: "budgetIdList") as? [String]{
            list.remove(id)
            UserDefaults.standard.removeObject(forKey: id)
            UserDefaults.standard.set(list, forKey: "budgetIdList")
            UserDefaults.standard.synchronize()
        }
    }
    
    static func updateBudget(budget:BudgetTransaction){
        let json = budget.toJSON()!
        UserDefaults.standard.set(json, forKey: budget.id)
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
    
    
    //根据月份获取当月每天的budgets.
    static func getAllDayBudgetsOfMonth(_ monthDate: Date, filterEmpty: Bool = true) -> DurationBudgets{
        let durationBudgets = DurationBudgets(monthDate: monthDate)
        if let list = UserDefaults.standard.object(forKey: "budgetIdList") as? [String]{
            for id in list{
                let dateString = id.components(separatedBy: "_")[1]
                let date = Date(string: dateString, format: "YYYY-MM-dd")!
                if date.year == monthDate.year, date.month == monthDate.month{
                    //目标月份
                    let json = UserDefaults.standard.object(forKey: id) as! [String: Any]
                    let budget = BudgetTransaction.deserialize(from: json)!
                    if let dayBudgets = durationBudgets.dayBudgetsList.first(where: {$0.day.isSameDay(budget.date)}){
                        dayBudgets.budgets.append(budget)
                    }else{
                        let dayBudgets = DayBudgets(day: budget.date)
                        dayBudgets.budgets.append(budget)
                        durationBudgets.dayBudgetsList.append(dayBudgets)
                    }
                }
            }
            durationBudgets.dayBudgetsList = durationBudgets.dayBudgetsList.sorted(by: \.day).filter({ dayBudget in
                return !filterEmpty || dayBudget.totalIncome>0 || dayBudget.totalOutcome > 0
            })
            
            return durationBudgets
        }
        if filterEmpty{
            durationBudgets.dayBudgetsList = .init()
        }
        return durationBudgets
    }
    
    //获取日期星期范围内每天的budgets
    static func getAllDayBudgetsOfWeek(_ weekDate:Date, filterEmpty: Bool = true) -> DurationBudgets{
        let durationBudgets = DurationBudgets(weekDate: weekDate)
        if let list = UserDefaults.standard.object(forKey: "budgetIdList") as? [String]{
            for id in list{
                let dateString = id.components(separatedBy: "_")[1]
                let date = Date(string: dateString, format: "YYYY-MM-dd")!
                if date.year == weekDate.year, date.weekOfYear == weekDate.weekOfYear{
                    let json = UserDefaults.standard.object(forKey: id) as! [String: Any]
                    let budget = BudgetTransaction.deserialize(from: json)!
                    if let dayBudgets = durationBudgets.dayBudgetsList.first(where: {$0.day.isSameDay(budget.date)}){
                        dayBudgets.budgets.append(budget)
                    }else{
                        let dayBudgets = DayBudgets(day: budget.date)
                        dayBudgets.budgets.append(budget)
                        durationBudgets.dayBudgetsList.append(dayBudgets)
                    }
                }
            }
            durationBudgets.dayBudgetsList = durationBudgets.dayBudgetsList.sorted(by: \.day).filter({ dayBudget in
                return !filterEmpty || dayBudget.totalIncome>0 || dayBudget.totalOutcome > 0
            })
            return durationBudgets
        }
        if filterEmpty{
            durationBudgets.dayBudgetsList = .init()
        }
        return durationBudgets
    }
    
    //获取目标年份每月的budgets, 注意这个方法返回DurationBudgets.dayBudgetsList中的每个元素 并不是当天的 DayBudgets, 而是每个月的Budgets
    static func getAllMonthBudgetOfYear(_ yearDate:Date, filterEmpty: Bool = false) -> DurationBudgets{
        let durationBudgets = DurationBudgets(yearDate: yearDate)
        if let list = UserDefaults.standard.object(forKey: "budgetIdList") as? [String]{
            for id in list{
                let dateString = id.components(separatedBy: "_")[1]
                let date = Date(string: dateString, format: "YYYY-MM-dd")!
                if date.year == yearDate.year{
                    let json = UserDefaults.standard.object(forKey: id) as! [String: Any]
                    let budget = BudgetTransaction.deserialize(from: json)!
                    if let dayBudgets = durationBudgets.dayBudgetsList.first(where: {$0.day.isSameMonth(budget.date)}){
                        dayBudgets.budgets.append(budget)
                    }else{
                        let dayBudgets = DayBudgets(day: budget.date)
                        dayBudgets.budgets.append(budget)
                        durationBudgets.dayBudgetsList.append(dayBudgets)
                    }
                }
            }
            durationBudgets.dayBudgetsList = durationBudgets.dayBudgetsList.sorted(by: \.day).filter({ dayBudget in
                return !filterEmpty || dayBudget.totalIncome>0 || dayBudget.totalOutcome > 0
            })
            return durationBudgets
        }
        if filterEmpty{
            durationBudgets.dayBudgetsList = .init()
        }
        return durationBudgets
        
        
    }
    
    
    
    //获取从起始时间到当下的所有时间单位.
    static func getAllDurationsOfType(_ type:DurationType) -> [Date]{
        if let list = UserDefaults.standard.object(forKey: "budgetIdList") as? [String]{
            var minDate = Date.distantFuture
            list.forEach { id in
                let dateString = id.components(separatedBy: "_")[1]
                
                let date = Date(string: dateString, format: "YYYY-MM-dd")!
                if date.compare(minDate) == .orderedAscending{
                    minDate = date
                }
                
                
                
            }
            var currentDate = minDate
            var firstDays: [Date] = []
            
            let calendar = Calendar.current
            let today = Date()
            
            switch type {
            case .week:
                while currentDate <= today {
                    if let firstDayOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: currentDate)) {
                        firstDays.append(firstDayOfWeek)
                    }
                    
                    currentDate = calendar.date(byAdding: .weekOfYear, value: 1, to: currentDate)!
                }
                return firstDays
            case .month:
                while currentDate <= today {
                    if let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currentDate)) {
                        firstDays.append(firstDayOfMonth)
                    }
                    
                    currentDate = calendar.date(byAdding: .month, value: 1, to: currentDate)!
                }
                return firstDays
            case .year:
                while currentDate <= today {
                    if let firstDayOfYear = calendar.date(from: calendar.dateComponents([.year], from: currentDate)) {
                        firstDays.append(firstDayOfYear)
                    }
                    
                    currentDate = calendar.date(byAdding: .year, value: 1, to: currentDate)!
                }
                return firstDays
            }
        }
        //木有
        return [Date()]
        
    }
    
    
    
    
}
