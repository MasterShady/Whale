//
//  DetailVC.swift
//  Whale
//
//  Created by 刘思源 on 2023/8/21.
//

import UIKit
import ETNavBarTransparent

class DetailVC: BaseVC {
    
    var yearLabel: UILabel!
    var mothLabel: UILabel!
    var incomeLabel: UILabel!
    var outcomeLabel: UILabel!
    var tableView: UITableView!
    
    var budgets = [BudgetTransaction]() {
        didSet{
            self.tableView.reloadData()
        }
    }
    
    override func configNavigationBar(){
        self.navigationItem.title = "鲸鱼记账"
        self.navBarBgAlpha = 1
        self.navBarTintColor = .kThemeColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.budgets = BudgetStore.getAllBudgets()
    }
    
    override func configSubViews() {
        self.edgesForExtendedLayout = []
        
        let gradientColor = UIColor.gradient(colors: [UIColor.kThemeColor, UIColor.kThemeColor.withAlphaComponent(0)], from: CGPoint(x: kScreenWidth/2, y: 0), to: CGPoint(x: kScreenWidth/2, y: 160),size: CGSize(width: kScreenWidth, height: 160))
        let gradientBgView = UIView()
        view.addSubview(gradientBgView)
        gradientBgView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 160)
        gradientBgView.backgroundColor = gradientColor
        
        let sumView = UIView()
        view.addSubview(sumView)
        sumView.snp.makeConstraints { make in
            make.top.left.right.equalTo(0)
            make.height.equalTo(60)
        }
        
        let dateBtn = UIButton()
        sumView.addSubview(dateBtn)
        dateBtn.snp.makeConstraints { make in
            make.left.equalTo(14)
            make.width.equalTo(60)
            make.top.bottom.equalTo(0)
        }
        
        yearLabel = UILabel()
        dateBtn.addSubview(yearLabel)
        yearLabel.snp.makeConstraints { make in
            make.top.equalTo(8)
            make.centerX.equalToSuperview()
        }
        yearLabel.chain.font(.systemFont(ofSize: 10)).text(color: .kTextBlack).text("2023年")
        
        mothLabel = UILabel()
        dateBtn.addSubview(mothLabel)
        mothLabel.snp.makeConstraints { make in
            make.bottom.equalTo(-8)
            make.centerX.equalToSuperview()
        }
        mothLabel.chain.font(.semibold(16)).text(color: .kTextBlack).text("8月")
        
        let dropdownIcon = UIImage(named: "drop_down")!.colored(.kBlack)
        let dropdown = UIImageView(image: dropdownIcon)
        sumView.addSubview(dropdown)
        dropdown.snp.makeConstraints { make in
            make.left.equalTo(mothLabel.snp.right).offset(4)
            make.centerY.equalTo(mothLabel)
        }
        
        let sep = UIView()
        sumView.addSubview(sep)
        sep.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(dateBtn.snp.right).offset(30)
            make.width.equalTo(1)
        }
        sep.backgroundColor = .kTextDrakGray
        
        let incomeTitle = UILabel()
        sumView.addSubview(incomeTitle)
        incomeTitle.snp.makeConstraints { make in
            make.top.equalTo(8)
            make.left.equalTo(sep.snp.right).offset(30)
        }
        incomeTitle.chain.text(color: .kTextBlack).font(.systemFont(ofSize: 10)).text("收入")
        
        incomeLabel = UILabel()
        sumView.addSubview(incomeLabel)
        incomeLabel.snp.makeConstraints { make in
            make.bottom.equalTo(-8)
            make.left.equalTo(incomeTitle)
        }
        
        let outcomeTitle = UILabel()
        sumView.addSubview(outcomeTitle)
        outcomeTitle.snp.makeConstraints { make in
            make.top.equalTo(8)
            make.left.equalTo(incomeTitle.snp.right).offset(120)
        }
        outcomeTitle.chain.text(color: .kTextBlack).font(.systemFont(ofSize: 10)).text("支出")
        
        outcomeLabel = UILabel()
        sumView.addSubview(outcomeLabel)
        outcomeLabel.snp.makeConstraints { make in
            make.bottom.equalTo(-8)
            make.left.equalTo(outcomeTitle)
        }
        
        tableView = UITableView()
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(sumView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.register(BudgetTransactionCell.self)
        
        reloadData()
    }
    
    func reloadData(){
        let date = Date()
        yearLabel.text = "\(date.year)年"
        mothLabel.text = "\(date.month)月"
        
        
        let totalIncome = 199.01
        let incomeRaw = String(format: "%.2f", totalIncome)
        let incomeValue = NSMutableAttributedString(incomeRaw, color: .kTextBlack, font: .semibold(16))
        let range = NSRange(location: (incomeRaw as NSString).length - 2, length: 2)
        incomeValue.setAttributes([
            .foregroundColor : UIColor.kTextBlack,
            .font: UIFont.systemFont(ofSize: 10)
        ], range: range)
        
        
        incomeLabel.attributedText = incomeValue
        
        
        let totalOutcome = 1564.3
        let outcomeRaw = String(format: "%.2f", totalOutcome)
        let outcomeValue = NSMutableAttributedString(outcomeRaw, color: .kTextBlack, font: .semibold(16))
        let range1 = NSRange(location: (outcomeRaw as NSString).length - 2, length: 2)
        outcomeValue.setAttributes([
            .foregroundColor : UIColor.kTextBlack,
            .font: UIFont.systemFont(ofSize: 10)
        ], range: range1)

        outcomeLabel.attributedText = outcomeValue
        
        
        
    }
    
}

extension DetailVC : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return budgets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(BudgetTransactionCell.self, indexPath: indexPath)
        cell.budget = self.budgets[indexPath.row]
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
