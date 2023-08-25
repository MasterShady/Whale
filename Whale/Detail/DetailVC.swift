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
    var currentMonth: Date = .init() {
        didSet{
            self.updateCurrentMonth()
        }
    }
    
    lazy var noDataView: UIView = {
        let noDataView = UIView()
        self.view.addSubview(noDataView)
        noDataView.snp.makeConstraints { make in
            make.edges.equalTo(self.tableView)
        }
        noDataView.backgroundColor = .white
        noDataView.isHidden = true
        let title = UILabel()
        noDataView.addSubview(title)
        title.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-15)
        }
        title.chain.font(.systemFont(ofSize: 12)).text(color: .kTextLightGray).text("没有任何账单哦~")
        
        let button = UIButton()
        noDataView.addSubview(button)
        button.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 64, height: 30))
        }
        button.chain.normalTitle(text: "去添加").normalTitleColor(color: .white).font(.systemFont(ofSize: 12)).backgroundColor(.kThemeColor).corner(radius: 15).clipsToBounds(true)
        button.addBlock(for: .touchUpInside) {[weak self] _ in
            self?.present(NavVC(rootViewController: CreateBudgetVC()), animated: true)
        }
        
        
        return noDataView
    }()
    
    lazy var monthPicker: MonthPicker = {
        let title = NSMutableAttributedString(string:"选择日期")
        title.setAttributes([
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18),
            NSAttributedString.Key.foregroundColor: UIColor.kBlack,
        ], range: title.range)
        
        //
        
        let fromDate = Date(string: "2010/01/01", format: "YYYY/MM/dd")!
        let toDate = Date(string: "2030/12/31", format: "YYYY/MM/dd")!
        let picker = MonthPicker(title: title, fromDate: fromDate, toDate: toDate) { [weak self] date in
            GEPopTool.dismissPopView()
            guard let self = self else {return}
            self.currentMonth = date
        }
        picker.setSelectedData(Date())
        picker.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: kScreenWidth, height: 290 + kBottomSafeInset))
        };

        return picker
    }()
    
    var monthBudgets : DurationBudgets = .init(monthDate: Date()) {
        didSet{
            self.updateBudgetsTable()
        }
    }
    

    
    override func configNavigationBar(){
        self.navigationItem.title = "鲸鱼记账"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        monthBudgets = BudgetStore.getAllDayBudgetsOfMonth(currentMonth, filterEmpty: true)
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
        dateBtn.addBlock(for: .touchUpInside) {[weak self] _ in
            guard let self = self else {return}
            GEPopTool.popViewFormBottom(view: self.monthPicker)
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
        
        tableView = UITableView(frame: .zero, style: .grouped)
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
        
        
    }
    
    
    
    func updateCurrentMonth(){
        yearLabel.text = "\(currentMonth.year)年"
        mothLabel.text = "\(currentMonth.month)月"
        monthBudgets = BudgetStore.getAllDayBudgetsOfMonth(currentMonth)
        
    }
    
    func updateBudgetsTable(){
        let totalIncome = monthBudgets.totalIncome
        let incomeRaw = String(format: "%.2f", totalIncome)
        let incomeValue = NSMutableAttributedString(incomeRaw, color: .kTextBlack, font: .semibold(16))
        let range = NSRange(location: (incomeRaw as NSString).length - 2, length: 2)
        incomeValue.setAttributes([
            .foregroundColor : UIColor.kTextBlack,
            .font: UIFont.systemFont(ofSize: 10)
        ], range: range)
        
        incomeLabel.attributedText = incomeValue
        
        let totalOutcome = monthBudgets.totalOutcome
        let outcomeRaw = String(format: "%.2f", totalOutcome)
        let outcomeValue = NSMutableAttributedString(outcomeRaw, color: .kTextBlack, font: .semibold(16))
        let range1 = NSRange(location: (outcomeRaw as NSString).length - 2, length: 2)
        outcomeValue.setAttributes([
            .foregroundColor : UIColor.kTextBlack,
            .font: UIFont.systemFont(ofSize: 10)
        ], range: range1)

        outcomeLabel.attributedText = outcomeValue
        tableView.reloadData()
    }
    
}

extension DetailVC : UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        noDataView.isHidden = monthBudgets.dayBudgetsList.count != 0
        return monthBudgets.dayBudgetsList.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = DayBudgetsHeader()
        header.dayBudgets = monthBudgets.dayBudgetsList[section]
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return monthBudgets.dayBudgetsList[section].budgets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(BudgetTransactionCell.self, indexPath: indexPath)
        cell.budget = monthBudgets.dayBudgetsList[indexPath.section].budgets[indexPath.row]
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dayBudgets = self.monthBudgets.dayBudgetsList[indexPath.section]
        let budget = dayBudgets.budgets[indexPath.row]
        let editVC = BudgetEditVC(budget: budget)
        self.navigationController?.pushViewController(editVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                // Perform your delete operation here
                let dayBudgets = self.monthBudgets.dayBudgetsList[indexPath.section]
                let budget = dayBudgets.budgets[indexPath.row]
                BudgetStore.deleteBudget(id: budget.id)
                monthBudgets = BudgetStore.getAllDayBudgetsOfMonth(currentMonth, filterEmpty: true)
            }
        }
    
}
