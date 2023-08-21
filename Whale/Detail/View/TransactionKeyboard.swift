//
//  TransactionKeyboard.swift
//  Whale
//
//  Created by 刘思源 on 2023/8/21.
//

import UIKit



class TransactionKeyboard: UIView, CalculatorDelegate {
    func calculatorDidUpdateDisplay(_ display: String) {
        amountLabel.text = display
    }
    
    
    lazy var calculator: Calculator = {
        var c = Calculator()
        c.delegate = self
        return c
    }()
    
    var amountLabel : UILabel!
    var tipsField : UITextField!
    
    var amount = 0.0 {
        didSet{
            self.updateAmount()
        }
    }

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
        amountLabel.chain.text(color: .kBlack).font(.semibold(20)).textAlignment(.right)
        
        
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
        leftView.chain.text("备注:").font(.systemFont(ofSize: 16)).text(color: .kTextBlack).textAlignment(.center)
        tipsField.chain.leftView(leftView).leftViewMode(.always).font(.systemFont(ofSize: 16)).text(color: .kBlack).attributedPlaceholder(.init("点击填写备注", color: .kTextLightGray, font: .systemFont(ofSize: 10)))
        
        let keyView = UIView()
        addSubview(keyView)
        keyView.snp.makeConstraints { make in
            make.top.equalTo(tipsField.snp.bottom).offset(8)
            make.left.right.equalToSuperview()
            make.height.equalTo(200)
            make.bottom.equalTo(-kBottomSafeInset)
        }
        
        let items = ["7", "8", "9", "今天", "4", "5", "6", "+", "1", "2", "3", "-", ".", "0", "x", "="]
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
            
            button.addBlock(for: .touchUpInside) {[weak self] _ in
                try? self?.calculator.handleInput(item)
            }
            //amountLabel.text = calculator.getDisplay()
        }
        
        updateAmount()
    }
    
    func updateAmount(){
        amountLabel.text = String(format: "%.2f", amount)
    }
    
    func show(){
        
        GEPopTool.popViewFormBottom(view: self, tapToDismss: true)
    }
    
    func hide(){
        GEPopTool.dismissPopView()
    }

}
