//
//  BudgetTransactionCell.swift
//  Whale
//
//  Created by 刘思源 on 2023/8/21.
//

import HandyJSON

enum BudgetType{
    case outcome
    case income
    
}

enum TransactionType : Int, HandyJSONEnum, CaseIterable{
    // 支出类型
    case shopping
    case dining
    case education
    case rent
    case utilities
    case transportation
    case entertainment
    case healthcare
    case insurance
    case charity
    case groceries
    case rentMortgage
    case loanRepayment
    case travel
    case subscriptions
    case homeMaintenance
    case clothing
    case gifts
    case electronics
    case makeup
    
    // 收入类型
    case salary
    case freelance
    case rentalIncome
    case investments
    case giftsIncome
    case refunds
    case allowance
    case royalties
    case lottery
    case otherIncome
    
    
    var iconName: String{
        switch self {
        case .shopping:
            return "029-bag.png"
        case .dining:
            return "001-restaurant.png"
        case .education:
            return "002-graduation-cap"
        case .rent:
            return "003-lease"
        case .utilities:
            return "004-utilities"
        case .transportation:
            return "005-delivery"
        case .entertainment:
            return "006-dancer"
        case .healthcare:
            return "007-healthcare"
        case .insurance:
            return "008-clipboard"
        case .charity:
            return "009-charity"
        case .groceries:
            return "010-donation"
        case .rentMortgage:
            return "011-signing"
        case .loanRepayment:
            return "012-contract"
        case .travel:
            return "013-travel-and-tourism"
        case .subscriptions:
            return "subscribe"
        case .homeMaintenance:
            return "014-maintenance"
        case .clothing:
            return "015-laundry"
        case .gifts:
            return "016-gift"
        case .electronics:
            return "017-responsive"
        case .makeup:
            return "018-cosmetics"
        case .salary:
            return "019-money"
        case .freelance:
            return "020-freelancer"
        case .rentalIncome:
            return "021-house-rental"
        case .investments:
            return "022-profits"
        case .giftsIncome:
            return "023-transfer"
        case .refunds:
            return "024-refund"
        case .allowance:
            return "025-give-money"
        case .royalties:
            return "026-monetization"
        case .lottery:
            return "027-lottery"
        case .otherIncome:
            return "028-incoming-mail"
        }
        
    }
    
    var description: String {
        switch self {
            // 支出类型的描述
        case .makeup: return "化妆"
        case .shopping: return "购物"
        case .dining: return "餐饮"
        case .education: return "教育"
        case .rent: return "租金"
        case .utilities: return "水电费"
        case .transportation: return "交通"
        case .entertainment: return "娱乐"
        case .healthcare: return "医疗"
        case .insurance: return "保险"
        case .charity: return "慈善"
        case .groceries: return "杂货"
        case .rentMortgage: return "房贷"
        case .loanRepayment: return "贷款还款"
        case .travel: return "旅行"
        case .subscriptions: return "订阅"
        case .homeMaintenance: return "家居维修"
        case .clothing: return "服饰"
        case .gifts: return "礼物"
        case .electronics: return "电子产品"
            
            
            // 收入类型的描述
        case .salary: return "工资"
        case .freelance: return "自由职业"
        case .rentalIncome: return "租金收入"
        case .investments: return "投资收益"
        case .giftsIncome: return "礼金收入"
        case .refunds: return "退款"
        case .allowance: return "零用钱"
        case .royalties: return "版税"
        case .lottery: return "彩票中奖"
        case .otherIncome: return "其他收入"
        }
    }
    
    var type : BudgetType{
        if self.rawValue >= TransactionType.salary.rawValue {
            return .income
        }
        return .outcome
    }
}


struct BudgetTransaction: HandyJSON{
    var type : TransactionType?
    var amount : Float?
    var date: Date?
}
