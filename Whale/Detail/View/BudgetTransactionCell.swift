//
//  BudgetTransactionCell.swift
//  Whale
//
//  Created by 刘思源 on 2023/8/21.
//

import UIKit


class DayBudgetsHeader : BaseView{
    var dateLabel: UILabel!
    var outcomeLabel: UILabel!
    var incomeLabel: UILabel!
    
    var dayBudgets: DayBudgets?{
        didSet{
            guard let dayBudgets = dayBudgets else {return}
            dateLabel.text = String(format: "%02zd月%02zd日  %@",dayBudgets.day.month,dayBudgets.day.day, dayBudgets.day.weekdayString)
            
            outcomeLabel.text = "支出: \(Double.toString(dayBudgets.totalOutcome))"
            outcomeLabel.isHidden = dayBudgets.totalOutcome == 0
            
            incomeLabel.text = "收入: \(Double.toString(dayBudgets.totalIncome))"
            incomeLabel.isHidden = dayBudgets.totalIncome == 0
        }
    }
    
    override func configSubviews() {
        self.backgroundColor = .white
        dateLabel = UILabel()
        addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(14)
        }
        dateLabel.chain.font(.systemFont(ofSize: 10)).text(color: .kTextLightGray)
        
        let stackView = UIStackView()
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.right.equalTo(-14)
            make.centerY.equalToSuperview()
        }
        stackView.spacing = 14
        stackView.axis = .horizontal
        
        incomeLabel = UILabel()
        stackView.addArrangedSubview(incomeLabel)
        incomeLabel.chain.font(.systemFont(ofSize: 14)).text(color: .kTextDrakGray)
        
        outcomeLabel = UILabel()
        stackView.addArrangedSubview(outcomeLabel)
        outcomeLabel.chain.font(.systemFont(ofSize: 14)).text(color: .kTextDrakGray)
        
        

        
    }
    
}

class BudgetTransactionCell: UITableViewCell {
    
    var icon: UIImageView!
    var supLabel: UILabel!
    var amoutLabel: UILabel!
    
    var budget: BudgetTransaction? {
        didSet{
            guard let budget = budget else {return}
            let image = UIImage.init(named: budget.type!.iconName)!.resizeImageToSize(size: CGSize(width: 40, height: 40))
            icon.image = image
            if let sup = budget.sup , sup.count > 0{
                supLabel.text = sup
            }else{
                supLabel.text = budget.type?.description
            }
            if budget.type!.type == .income {
                amoutLabel.text = "+" + Double.toString(budget.amount)
            }else{
                amoutLabel.text = "-" + Double.toString(budget.amount)
            }
            
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configSubViews(){
        contentView.backgroundColor = .white
        
        //为了给icon加inset
        let iconBg = UIView()
        contentView.addSubview(iconBg)
        iconBg.snp.makeConstraints { make in
            make.top.equalTo(8)
            make.left.equalTo(16)
            make.bottom.equalTo(-8)
            make.size.equalTo(CGSize(width: 40, height: 40))
        }
        iconBg.chain.corner(radius: 20).clipsToBounds(true).backgroundColor(.kThemeColor)

        
        icon = UIImageView()
        iconBg.addSubview(icon)
        icon.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(30)
        }
        
        supLabel = UILabel()
        contentView.addSubview(supLabel)
        supLabel.snp.makeConstraints { make in
            make.centerY.equalTo(icon)
            make.left.equalTo(icon.snp.right).offset(20)
        }
        supLabel.chain.font(.systemFont(ofSize: 14)).text(color:.kTextBlack)
        
        amoutLabel = UILabel()
        contentView.addSubview(amoutLabel)
        amoutLabel.snp.makeConstraints { make in
            make.right.equalTo(-16)
            make.centerY.equalToSuperview()
        }
        amoutLabel.chain.font(.systemFont(ofSize: 16)).text(color: .red)
        
        
    }
    
    

}
