//
//  TransactionKeyboard.swift
//  Whale
//
//  Created by 刘思源 on 2023/8/21.
//

import UIKit



class TransactionKeyboard: UIView, CalculatorDelegate {
    
    var didCompletedEditing: ((Double,Date,String?) -> ())?
    
    var date = Date() {
        didSet{
            self.updateDate()
        }
    }
    
    func calculatorDidUpdateDisplay(_ display: String) {
        //这里不是纯数字, 可能有符号的
        if display.isPureNumber{
            amount = Double(display)!
        }
        amountLabel.text = display
    }
    
    func hasOperatorSymbol(_ hasSymbol: Bool) {
        self.doneBtn.isSelected = hasSymbol
    }
    
    lazy var calculator: Calculator = {
        var c = Calculator()
        c.delegate = self
        return c
    }()
    
    lazy var datePicker: DatePicker = {
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
            self.date = date
        }
        picker.setSelectedData(Date()) 
        picker.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: kScreenWidth, height: 290 + kBottomSafeInset))
        };

        return picker
    }()
    
    
    
    var amountLabel : UILabel!
    var tipsField : UITextField!
    var doneBtn : UIButton!
    var dateBtn : UIButton!
    
    var amount = 0.0

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configSubViews(){
        snp.makeConstraints { make in
            make.width.equalTo(kScreenWidth)
        }
        backgroundColor = .white
        amountLabel = UILabel()
        addSubview(amountLabel)
        amountLabel.snp.makeConstraints { make in
            make.top.equalTo(8)
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.height.equalTo(36)
        }
        amountLabel.chain.text(color: .kBlack).font(.semibold(20)).textAlignment(.right).text("0")
        
        
        tipsField = UITextField()
        addSubview(tipsField)
        tipsField.snp.makeConstraints { make in
            make.top.equalTo(amountLabel.snp.bottom).offset(8)
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.height.equalTo(30)
        }
        let leftView = UILabel()
        leftView.size = CGSizeMake(50, 36)
        leftView.chain.text(" 备注:  ").font(.systemFont(ofSize: 14)).text(color: .kTextBlack).textAlignment(.center)
        tipsField.chain.leftView(leftView).leftViewMode(.always).font(.systemFont(ofSize: 14)).text(color: .kBlack).attributedPlaceholder(.init("点击填写备注", color: .kTextLightGray, font: .systemFont(ofSize: 14))).backgroundColor(.kExLightGray).corner(radius: 4).clipsToBounds(true)
        
        let keyView = UIView()
        addSubview(keyView)
        keyView.snp.makeConstraints { make in
            make.top.equalTo(tipsField.snp.bottom).offset(8)
            make.left.right.equalToSuperview()
            make.height.equalTo(200)
            make.bottom.equalTo(-kBottomSafeInset)
        }
        
        let items = ["7", "8", "9", "date", "4", "5", "6", "+", "1", "2", "3", "-", ".", "0", "x", "="]
        let itemW = kScreenWidth / 4
        let itemH = 50
        
        for (i, item) in items.enumerated(){
            let row = i / 4
            let line = i % 4
            let button = UIButton()
            keyView.addSubview(button)
            button.snp.makeConstraints { make in
                make.top.equalTo(itemH * row)
                make.left.equalTo(itemW * line)
                make.width.equalTo(itemW)
                make.height.equalTo(itemH)
            }
            button.chain.normalTitle(text: item).normalTitleColor(color: .kTextBlack).font(.semibold(20)).border(color: .kSepLineColor).border(width: 0.5)
            
            if item == "date"{
                dateBtn = button
                dateBtn.addBlock(for: .touchUpInside) {[weak self] _ in
                    guard let self = self else {return}
                    GEPopTool.popViewFormBottom(view: self.datePicker, tapToDismss: true)
                }
                
            }else if item == "=" {
                doneBtn = button
                button.chain.backgroundColor(.kThemeColor).normalTitle(text: "完成").selectedTitle(text: "=")
                button.addBlock(for: .touchUpInside) {[weak self] _ in
                    guard let self = self else {return}
                    if self.doneBtn.isSelected{
                        self.calculator.handleInput("=")
                    }else{
                        self.hide()
                        self.didCompletedEditing?(self.amount,self.date,self.tipsField.text)
                    }
                }
            }else{
                if item  == "x" {
                    button.chain.normalTitle(text: nil).normalImage(.init(named: "backspace")?.resizeImageToSize(size: CGSizeMake(24, 24)))
                }
                button.addBlock(for: .touchUpInside) {[weak self] _ in
                    self?.calculator.handleInput(item)
                }
            }
            
            
        }
        
        updateDate()
    }

    
    //MARK: updateUI
//    func updateAmount(){
//        amountLabel.text = String(format: "%.2f", amount)
//    }
    
    func updateDate(){
        if date.isSameDay(Date()){
            self.dateBtn.chain.normalTitle(text: "今天").font(.systemFont(ofSize: 14)).normalImage(.init(named: "calendar"))
            self.dateBtn.setImagePosition(.left, spacing: 4)
        }else{
            self.dateBtn.chain.normalTitle(text: date.dateString(withFormat: "YYYY/MM/dd")).normalImage(nil).font(.systemFont(ofSize: 14))
            self.dateBtn.setImagePosition(.reset, spacing: 0)
        }
    }
    

    
    func show(){
        GEPopTool.popViewFormBottom(view: self, tapToDismss: true)
    }
    
    func hide(){
        GEPopTool.dismissPopView()
    }

}
