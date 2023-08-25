//
//  BudgetEditVC.swift
//  Whale
//
//  Created by 刘思源 on 2023/8/25.
//

import UIKit

class BudgetEditVC: BaseVC, UITextFieldDelegate{
    
    var budget : BudgetTransaction
    var amountField: UITextField!
    var dateBtn: UIButton!
    //原始的date
    var oDate: Date
    
    
    
    
    lazy var datePicker : DatePicker = {
        let title = NSMutableAttributedString(string:"选择日期")
        title.setAttributes([
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18),
            NSAttributedString.Key.foregroundColor: UIColor.kBlack,
        ], range: title.range)
        
        //
        
        let fromDate = Date(string: "2010/01/01", format: "YYYY/MM/dd")!
        let toDate = Date(string: "2030/12/31", format: "YYYY/MM/dd")!
        let picker = DatePicker(title: title, fromDate: fromDate, toDate: toDate) { [weak self] date in
            GEPopTool.dismissPopView()
            guard let self = self else {return}
            self.budget.date = date
            self.dateBtn.chain.normalTitle(text: date.dateString(withFormat: "YYYY/MM/dd"))
        }
        picker.setSelectedData(self.budget.date)
        picker.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: kScreenWidth, height: 290 + kBottomSafeInset))
        };
        return picker
        
    }()
    
    
    
    
    init(budget: BudgetTransaction) {
        self.budget = budget
        self.oDate = budget.date
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func configNavigationBar() {
        let saveItem = UIBarButtonItem(title: "保存", style: .plain, target: nil, action: nil)
        saveItem.actionBlock = { [weak self] _ in
            guard let self = self else {return}
            self.view.endEditing(true)
            self.updateBudget()
            "修改成功".hint()
            self.navigationController?.popViewController(animated: true)
        }
        self.navigationItem.rightBarButtonItem = saveItem
    }
    
    override func configSubViews() {
        self.title = "编辑账单"
        self.edgesForExtendedLayout = []
        let iconBtn = UIButton()
        self.view.addSubview(iconBtn)
        iconBtn.snp.makeConstraints { make in
            make.top.left.equalTo(14)
        }
        let icon = UIImage(named: budget.type!.iconName)?.drawInColor(color: .kThemeColor, size: CGSize(width: 40, height: 40), cornerRadius: 20, tintColor: .kTextBlack, insets: .init(top: 5, left: 5, bottom: 5, right: 5))
        iconBtn.chain.normalImage(icon).normalTitle(text: budget.type.description)
        iconBtn.setImagePosition(.left, spacing: 10)
        iconBtn.addBlock(for: .touchUpInside) {[weak self, weak iconBtn] _ in
            guard let self = self, let iconBtn = iconBtn else {return}
            let vc = CreateBudgetTypeVC(type: self.budget.type!.type)
            vc.didSelectedType = { type in
                self.budget.type = type
                //BudgetStore.updateBudget(budget: self.budget)
                let newIcon = UIImage(named: self.budget.type.iconName)?.drawInColor(color: .kThemeColor, size: CGSize(width: 40, height: 40), cornerRadius: 20, tintColor: .kTextBlack, insets: .init(top: 5, left: 5, bottom: 5, right: 5))
                iconBtn.chain.normalImage(newIcon).normalTitle(text: self.budget.type.description)
                iconBtn.setImagePosition(.left, spacing: 10)
            }
            let dismissItem = UIBarButtonItem(title: "取消", style: .plain, target: nil, action: nil)
            dismissItem.actionBlock = {[weak vc] _ in
                vc?.dismiss(animated: true)
            }
            vc.navigationItem.rightBarButtonItem = dismissItem
            self.present(NavVC(rootViewController: vc), animated: true)
        }
        
        
        amountField = UITextField()
        view.addSubview(amountField)
        amountField.snp.makeConstraints { make in
            make.top.equalTo(iconBtn.snp.bottom).offset(14)
            make.left.equalTo(14)
            make.height.equalTo(44)
            make.width.equalTo(200)
        }
        amountField.keyboardType = .decimalPad
        amountField.chain.text(color: .kTextBlack).font(.systemFont(ofSize: 14)).backgroundColor(.kExLightGray).corner(radius: 5).clipsToBounds(true)
        
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 44))
        let leftTitle = UILabel()
        leftView.addSubview(leftTitle)
        leftTitle.frame = CGRect(x: 8, y: 0, width: 42, height: 44)
        leftTitle.chain.font(.systemFont(ofSize: 14)).text(color: .kTextDrakGray)
        leftTitle.text = "金额: "
        amountField.delegate = self
        amountField.leftView = leftView
        amountField.leftViewMode = .always
        amountField.text = Double.toString(self.budget.amount)
        
        amountField.addBlock(for: .editingDidEnd) {[weak self] _ in
            guard let self = self else {return}
            self.budget.amount = Double(self.amountField.text!)!
            //BudgetStore.updateBudget(budget: self.budget)
        }
        
        
        let dateBtnContainer = UIButton()
        view.addSubview(dateBtnContainer)
        dateBtnContainer.snp.makeConstraints { make in
            make.top.equalTo(amountField.snp.bottom).offset(14)
            make.left.equalTo(14)
            make.height.equalTo(44)
            make.width.equalTo(200)
        }
        dateBtnContainer.chain.corner(radius: 5).clipsToBounds(true).backgroundColor(.kExLightGray)
        
        dateBtn = UIButton()
        dateBtn.isUserInteractionEnabled = false
        dateBtnContainer.addSubview(dateBtn)
        dateBtn.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.top.bottom.equalToSuperview()
        }
        
        let dateString = self.budget.date.dateString(withFormat: "YYYY/MM/dd")
        dateBtn.chain.normalImage(.init(named: "calendar")).normalTitle(text: dateString).normalTitleColor(color: .kTextBlack).font(.systemFont(ofSize: 14))
        dateBtn.setImagePosition(.left, spacing: 20)
        
        
        dateBtnContainer.addBlock(for: .touchUpInside) {[weak self] _ in
            guard let self = self else {return}
            
            GEPopTool.popViewFormBottom(view: self.datePicker)
        }
        
        let supField = UITextField()
        view.addSubview(supField)
        supField.snp.makeConstraints { make in
            make.top.equalTo(dateBtn.snp.bottom).offset(14)
            make.left.equalTo(14)
            make.height.equalTo(44)
            make.width.equalTo(200)
        }
        supField.chain.text(color: .kTextBlack).font(.systemFont(ofSize: 14)).backgroundColor(.kExLightGray).corner(radius: 5).clipsToBounds(true)
        
        let supLeftView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 44))
        let supLeftTitle = UILabel()
        supLeftView.addSubview(supLeftTitle)
        supLeftTitle.frame = CGRect(x: 8, y: 0, width: 42, height: 44)
        supLeftTitle.chain.font(.systemFont(ofSize: 14)).text(color: .kTextDrakGray)
        supLeftTitle.text = "描述: "
        
        supField.leftView = supLeftView
        supField.leftViewMode = .always
        supField.text = self.budget.sup
        
        supField.addBlock(for: .editingDidEnd) {[weak supField] _ in
            guard let supField = supField else {return}
            self.budget.sup = supField.text
            
        }
    }
    
    func updateBudget(){
        if self.oDate == self.budget.date{
            BudgetStore.updateBudget(budget: self.budget)
        }else{
            //因为id是根据date来生成的方便查找, 因此改date需要将原有的budget删除再创建一个新的对象
            let newBudget = BudgetTransaction(type: self.budget.type, amount: self.budget.amount, date: self.budget.date)
            BudgetStore.deleteBudget(id: self.budget.id)
            BudgetStore.addBudget(budget: newBudget)
        }
        
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField == amountField{
            guard let value = amountField.text, value.count > 0 else {
                "金额不能为空".hint()
                return false
            }
            return true
        }
        return true
    }

}
