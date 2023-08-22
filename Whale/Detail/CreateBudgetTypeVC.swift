//
//  CreateBudgetTypeVC.swift
//  Whale
//
//  Created by 刘思源 on 2023/8/21.
//

import UIKit
import JXSegmentedView



class CreateBudgetTypeVC: BaseVC {
    
    var scrollView: UIScrollView!
    var itemViews = [UIButton]()
    var transactionType : TransactionType?
    

    
    lazy var keyboard : TransactionKeyboard = {
        let keyboard = TransactionKeyboard()
        keyboard.didCompletedEditing = {[weak self] amount, date, sup in
            guard let self = self else {return}
            let budget = BudgetTransaction(type: self.transactionType, amount: amount, date: date, sup: sup)
            BudgetStore.addBudget(budget: budget)
            self.dismiss(animated: true)
        }
        return keyboard
    }()
    
    let type : BudgetType
    init(type: BudgetType) {
        self.type = type
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let datasource = TransactionType.allCases.filter { $0.type == type}
        scrollView = UIScrollView()
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        let contentView = UIView()
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(0)
            make.width.equalTo(kScreenWidth)
        }
        
        let itemW: CGFloat = 50
        let itemH: CGFloat = 70
        let insets: CGFloat = 35
        let VSpacing: CGFloat = 16
        let HSpacing = (kScreenWidth  - itemW * 4 - insets * 2) / 3
        for (i,item) in datasource.enumerated() {
            let row = i / 4
            let line = i % 4
            let itemView = UIView()
            contentView.addSubview(itemView)
            itemView.snp.makeConstraints { make in
                make.top.equalTo(insets + row * (VSpacing + itemH))
                make.left.equalTo(insets + line * (HSpacing + itemW))
                make.width.equalTo(itemW)
                make.height.equalTo(itemH)
                if i == datasource.count - 1{
                    make.bottom.equalTo(-insets)
                }
            }
            
            let button = UIButton()
            itemView.addSubview(button)
            button.snp.makeConstraints { make in
                make.top.left.right.equalTo(0)
                make.height.equalTo(50)
            }
            self.itemViews.append(button)
            
            let normalImage =  UIImage(named: item.iconName)
            let normalBgImage = UIImage(color: .kExLightGray)
            let selectedBgImage = UIImage(color: .kThemeColor)
            button.chain.normalImage(normalImage).normalBackgroundImage(normalBgImage).selectedBackgroundImage(selectedBgImage).corner(radius: 25).clipsToBounds(true)
            
            let titleLabel = UILabel()
            itemView.addSubview(titleLabel)
            titleLabel.snp.makeConstraints { make in
                make.top.equalTo(button.snp.bottom).offset(5)
                make.centerX.equalToSuperview()
            }
            titleLabel.chain.text(item.description).font(.systemFont(ofSize: 10)).text(color: .kTextBlack)
            button.tag = 1000 + item.rawValue
            
            button.addBlock(for: .touchUpInside) {[weak self] _ in
                guard let self = self else {return}
                for view in self.itemViews{
                    if view.tag == 1000 + item.rawValue{
                        view.isSelected = true
                    }else{
                        view.isSelected = false
                    }
                }
                self.transactionType = item
                self.keyboard.show()
            }
        }
        
        
        
    }

}

extension CreateBudgetTypeVC :JXSegmentedListContainerViewListDelegate{
    func listView() -> UIView {
        return self.view
    }
}

