//
//  BudgetTransactionCell.swift
//  Whale
//
//  Created by 刘思源 on 2023/8/21.
//

import UIKit

class BudgetTransactionCell: UITableViewCell {
    
    var icon: UIImageView!
    var supLabel: UILabel!
    var amoutLabel: UILabel!
    
    var budget: BudgetTransaction? {
        didSet{
            guard let budget = budget else {return}
            let image = UIImage.init(named: budget.type!.iconName)!.resizeImageToSize(size: CGSize(width: 40, height: 40))
            icon.image = .init(named: budget.type!.iconName)
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
        contentView.backgroundColor = .clear
        icon = UIImageView()
        contentView.addSubview(icon)
        icon.snp.makeConstraints { make in
            make.top.equalTo(8)
            make.left.equalTo(16)
            make.bottom.equalTo(-8)
            make.size.equalTo(CGSize(width: 40, height: 40))
        }
        icon.chain.corner(radius: 20).clipsToBounds(true).backgroundColor(.kThemeColor)
        
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
