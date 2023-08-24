//
//  ChartPageVC.swift
//  Whale
//
//  Created by 刘思源 on 2023/8/23.
//

import UIKit
import JXSegmentedView
import DGCharts


class DateAxisValueFormatter:AxisValueFormatter{
    var date: Date!
    var durationType: DurationType!
    var totalCount = Int.max
    
    func stringForValue(_ value: Double,
                        axis: AxisBase?) -> String{
        let index = Int(value)
        switch durationType {
        case .week:
            let date = date.addingTimeInterval(index * 86400)
            return date.dateString(withFormat:"MM/dd")
        case .month:
            let date = date.addingTimeInterval(index * 86400)
            if index == 0 {
                return "01"
            }
            
            if index <= 24, index % 5 == 4{
                return date.dateString(withFormat: "dd")
            }
            if totalCount == 28, index == 27{
                return "28"
            }
            
            if totalCount == 29, index == 28{
                return "29"
            }
            
            if totalCount == 30, index == 29{
                return "30"
            }
            
            if totalCount == 31, index == 30{
                return "31"
            }
            return ""
        case .year:
            return "\(index + 1)月"
        case .none:
            return ""
        }
    }
}

class ChartPageVC: BaseVC, ChartViewDelegate {
    
    var totalIncomeLabel: UILabel!
    var avaIncomLabel: UILabel!
    var totalOutcomeLabel: UILabel!
    var avaOutcomeLabel: UILabel!
    
    var dates = [Date]() //JXSegmentedView数据源
    var currentStartDate: Date! //当前选中的 JXSegmentedView 的起始日期
    
    
    
    var dateAF = DateAxisValueFormatter()
    var chartView : LineChartView!
    var dataSource: JXSegmentedTitleDataSource!
    var segmentView: JXSegmentedView!
    var durationType = DurationType.week {
        didSet{
            updateDurationType()
            updateChart()
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        updateChart()
    }
    
    override func configSubViews() {
        self.edgesForExtendedLayout = []
        let segmentController = UISegmentedControl(items: ["周","月","年"])
        segmentController.selectedSegmentIndex = 0
        segmentController.frame = CGRect(x: 0, y: 0, width: kScreenWidth - 30, height: 30)
        segmentController.addBlock(for: .valueChanged) {[weak self] sender in
            if let sender = sender as? UISegmentedControl{
                self?.durationType = DurationType(rawValue: sender.selectedSegmentIndex)!
            }
        }
        self.navigationItem.titleView = segmentController
        
        segmentView = JXSegmentedView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 35))
        segmentView.delegate = self
        view.addSubview(segmentView)
        
        let sep = UIView()
        segmentView.addSubview(sep)
        sep.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(segmentView)
            make.height.equalTo(0.5)
        }
        sep.backgroundColor = .kSepLineColor
        
        
        //选中的下划线
        let lineView =  JXSegmentedIndicatorLineView()
        lineView.indicatorColor = .kTextBlack
        lineView.indicatorHeight = 2 //横线高度
        lineView.verticalOffset = 0 //垂直方向偏移
        lineView.indicatorCornerRadius = 0.5
        lineView.indicatorWidthIncrement = 10
        segmentView.indicators = [lineView]
        
        
        dataSource = JXSegmentedTitleDataSource()
        dataSource.titleNormalFont = UIFont.systemFont(ofSize: 14)
        dataSource.titleSelectedFont = UIFont.systemFont(ofSize: 14)
        dataSource.titleNormalColor = .kTextLightGray
        dataSource.titleSelectedColor = .kBlack
        //dataSource.itemWidth = 60
        dataSource.itemSpacing = 30
        dataSource.isItemSpacingAverageEnabled = false
        segmentView.dataSource = dataSource
        
        
        
        totalOutcomeLabel = UILabel()
        view.addSubview(totalOutcomeLabel)
        totalOutcomeLabel.snp.makeConstraints { make in
            make.top.equalTo(segmentView.snp.bottom).offset(14)
            make.left.equalTo(14)
        }
        
        avaOutcomeLabel = UILabel()
        view.addSubview(avaOutcomeLabel)
        avaOutcomeLabel.snp.makeConstraints { make in
            make.left.equalTo(totalOutcomeLabel)
            make.top.equalTo(totalOutcomeLabel.snp.bottom).offset(8)
        }
        
        totalIncomeLabel = UILabel()
        view.addSubview(totalIncomeLabel)
        totalIncomeLabel.snp.makeConstraints { make in
            make.left.equalTo(200)
            make.centerY.equalTo(totalOutcomeLabel)
        }
        
        avaIncomLabel = UILabel()
        view.addSubview(avaIncomLabel)
        avaIncomLabel.snp.makeConstraints { make in
            make.left.equalTo(totalIncomeLabel)
            make.top.equalTo(totalIncomeLabel.snp.bottom).offset(8)
        }
        
        
        chartView = LineChartView()
        view.addSubview(chartView)
        
        chartView.snp.makeConstraints { make in
            make.top.equalTo(avaOutcomeLabel.snp.bottom).offset(14)
            make.left.equalTo(14)
            make.right.equalTo(-14)
            make.height.equalTo(300)
        }
        chartView.delegate = self

        chartView.chartDescription.enabled = false
        chartView.dragEnabled = true
        chartView.setScaleEnabled(true)
        chartView.pinchZoomEnabled = true
        
        updateDurationType()
        
    }
    
    
    
    
    func updateDurationType(){
        dates = BudgetStore.getAllDurationsOfType(durationType)
        let now = Date()
        switch durationType {
        case .week:
            dataSource.titles = dates.map({ date in
                if date.year == now.year{
                    //今年
                    if date.weekOfYear == now.weekOfYear{
                        return "本周"
                    }
                    if date.weekOfYear == now.weekOfYear - 1{
                        return "上周"
                    }
                    return "\(date.weekOfYear)周"
                }
                return "\(date.year)-\(date.weekOfYear)周"
            })
            break
        case .month:
            dataSource.titles = dates.map({ date in
                if date.year == now.year{
                    //今年
                    if date.month == now.month{
                        return "本月"
                    }
                    if date.month == now.month - 1{
                        return "上月"
                    }
                    return "\(date.month)月"
                }
                return "\(date.year)-\(date.month)月"
                
            })
            break
        case .year:
            dataSource.titles = dates.map({ date in
                if date.year == now.year{
                    return "今年"
                }
                if date.year == now.year - 1{
                    return "去年"
                }
                return "\(date.year)年"
            })
            break
        }
        

        segmentView.reloadData()
        segmentView.selectItemAt(index: dataSource.titles.count - 1)
    }
    
    
    func updateChart(){
        
        guard let _ = self.currentStartDate else {return}
        //数据源中源
        var durationBudgets: DurationBudgets!
        
        var xAxisCount = 0
        var timeUnit = "/天"
        switch durationType {
        case .week:
            xAxisCount = 7
            durationBudgets = BudgetStore.getAllDayBudgetsOfWeek(self.currentStartDate, filterEmpty: false)
            break
        case .month:
            xAxisCount = self.currentStartDate.totalDayCountOfCurrentMonth
            durationBudgets = BudgetStore.getAllDayBudgetsOfMonth(self.currentStartDate, filterEmpty: false)
            break
        case .year:
            xAxisCount = 12
            durationBudgets = BudgetStore.getAllMonthBudgetOfYear(self.currentStartDate, filterEmpty: false)
            timeUnit = "/月"
            break
        }
        
    
        
        let toRaw = String(format: "总支出: %.2f", durationBudgets.totalOutcome)
        let to = NSMutableAttributedString(toRaw, color: .red, font: .semibold(16))
        to.setAttributes([
            .foregroundColor : UIColor.kTextBlack,
            .font : UIFont.systemFont(ofSize: 14)
        ], range: (toRaw as NSString).range(of: "总支出:"))
        
        
        totalOutcomeLabel.attributedText = to
        
        
        let aoRaw = String(format: "平均支出: %.2f%@", durationBudgets.averageOutcome,timeUnit)
        let ao = NSMutableAttributedString(aoRaw, color: .red, font: .semibold(16))
        ao.setAttributes([
            .foregroundColor : UIColor.kTextBlack,
            .font : UIFont.systemFont(ofSize: 14)
        ], range: (aoRaw as NSString).range(of: "平均支出:"))
        ao.setAttributes([
            .foregroundColor : UIColor.kTextBlack,
            .font : UIFont.systemFont(ofSize: 14)
        ], range: (aoRaw as NSString).range(of: timeUnit))
        
        avaOutcomeLabel.attributedText = ao
        
        
        if durationBudgets.totalIncome > 0{
            
            
            totalIncomeLabel.isHidden = false
            avaIncomLabel.isHidden = false
            // 显示收入
            let tiRow = String(format: "总收入: %.2f", durationBudgets.totalIncome)
            let ti = NSMutableAttributedString(tiRow, color: .green, font: .semibold(16))
            ti.setAttributes([
                .foregroundColor : UIColor.kTextBlack,
                .font : UIFont.systemFont(ofSize: 14)
            ], range: (tiRow as NSString).range(of: "总收入:"))
            
            totalIncomeLabel.attributedText = ti
            
            let aiRow = String(format: "平均收入: %.2f%@", durationBudgets.averageIncome, timeUnit)
            let ai = NSMutableAttributedString(aiRow, color: .green, font: .semibold(16))
            ai.setAttributes([
                .foregroundColor : UIColor.kTextBlack,
                .font : UIFont.systemFont(ofSize: 14)
            ], range: (aiRow as NSString).range(of: "平均收入:"))
            
            ai.setAttributes([
                .foregroundColor : UIColor.kTextBlack,
                .font : UIFont.systemFont(ofSize: 14)
            ], range: (aiRow as NSString).range(of: timeUnit))
            
            avaIncomLabel.attributedText = ai
        }else{
            totalIncomeLabel.isHidden = true
            avaIncomLabel.isHidden = true
        }
        
        

        //Y轴设置
        let leftAxis = chartView.leftAxis
        leftAxis.axisMaximum = max(durationBudgets.maxOutcome, durationBudgets.maxIncome) * 1.1
        leftAxis.axisMinimum = 0
        
        //隐藏坐标和刻度
        leftAxis.drawAxisLineEnabled = false
        leftAxis.drawLabelsEnabled = false
        leftAxis.drawGridLinesEnabled = false
        leftAxis.labelTextColor = .kBlack
        
        //隐藏坐标和刻度
        chartView.rightAxis.enabled = false
        
        
        
        //X轴设置
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 10)
        xAxis.labelTextColor = .kBlack
        xAxis.granularity = 1
        xAxis.labelCount = xAxisCount
        dateAF.date = self.currentStartDate
        dateAF.durationType = durationType
        dateAF.totalCount = xAxisCount
        xAxis.valueFormatter = dateAF
        
        //隐藏垂直于x轴的竖线
        xAxis.drawGridLinesEnabled = false
        
        //最大花费
        
        leftAxis.removeAllLimitLines()
        
        let maxline = ChartLimitLine(limit: durationBudgets.maxOutcome, label: String(format: "%.2f", durationBudgets.maxOutcome))
        maxline.lineWidth = 0.5
        maxline.lineColor = .red
        maxline.valueTextColor = .kTextBlack
        maxline.labelPosition = .rightTop
        maxline.valueFont = .systemFont(ofSize: 10)
        
        leftAxis.addLimitLine(maxline)
        
        //平均花费
        let avaline = ChartLimitLine(limit: durationBudgets.averageOutcome, label: String(format: "%.2f", durationBudgets.averageOutcome))
        avaline.lineWidth = 0.5
        avaline.lineDashLengths = [3,3]
        avaline.lineColor = .red
        avaline.labelPosition = .rightTop
        avaline.valueFont = .systemFont(ofSize: 10)
        avaline.valueTextColor = .kTextBlack
        leftAxis.addLimitLine(avaline)
        
        
        
            //点
         let outcomeValues: [ChartDataEntry] = durationBudgets.dayBudgetsList.enumerated().map { (i , item) in
             let normalImage = UIImage(color: .red, size: .init(width: 4, height: 4))!.byRoundCornerRadius(2)
             let nonImage = UIImage(color: .white, size: .init(width: 4, height: 4))!.byRoundCornerRadius(2)
             let totalOutCome = item.totalOutcome
             var icon : UIImage!
             if totalOutCome > 0{
                 icon = normalImage
             }else{
                 icon = nonImage
             }
             
             return ChartDataEntry(x: Double(i), y: totalOutCome, icon:icon, data:[
                "dayBudgets":item,
                "type": BudgetType.outcome
             ] as [String : Any])
        }
        
        
        printLog("~~\(outcomeValues.count)")
        
        //线
        let outcomeSet = LineChartDataSet(entries: outcomeValues, label: "支出")
        outcomeSet.setColor(.red)
        outcomeSet.setCircleColor(.red)
        outcomeSet.gradientPositions = nil
        outcomeSet.lineWidth = 1
        outcomeSet.circleRadius = 3
        outcomeSet.drawCircleHoleEnabled = true
        outcomeSet.valueFont = .systemFont(ofSize: 9)
        outcomeSet.drawValuesEnabled = false // 隐藏点上的数字
        outcomeSet.valueTextColor = .kTextBlack
//        set1.formLineDashLengths = [5, 2.5]
//        set1.formLineWidth = 1
//        set1.formSize = 15
        
        var incomeSet: LineChartDataSet = .init(entries: [], label: "收入")
        
        if durationBudgets.totalIncome > 0{
            //最大收入
            let maxIncomeline = ChartLimitLine(limit: durationBudgets.maxIncome, label: String(format: "%.2f", durationBudgets.maxIncome))
            maxIncomeline.lineWidth = 0.5
            maxIncomeline.lineColor = .green
            maxIncomeline.labelPosition = .rightTop
            maxIncomeline.valueFont = .systemFont(ofSize: 10)
            maxIncomeline.valueTextColor = .kTextBlack
            leftAxis.addLimitLine(maxIncomeline)
            
            //平均收入
            let avaIncomeline = ChartLimitLine(limit: durationBudgets.averageIncome, label: String(format: "%.2f", durationBudgets.averageIncome))
            avaIncomeline.lineWidth = 0.5
            avaIncomeline.lineDashLengths = [3,3]
            avaIncomeline.lineColor = .green
            avaIncomeline.labelPosition = .rightTop
            avaIncomeline.valueFont = .systemFont(ofSize: 10)
            avaIncomeline.valueTextColor = .kTextBlack
            leftAxis.addLimitLine(avaIncomeline)
            
            let inComeValues: [ChartDataEntry] = durationBudgets.dayBudgetsList.enumerated().map { (i , item) in
                let normalImage = UIImage(color: .green, size: .init(width: 4, height: 4))!.byRoundCornerRadius(2)
                let nonImage = UIImage(color: .white, size: .init(width: 4, height: 4))!.byRoundCornerRadius(2)
                let totalIncome = item.totalIncome
                var icon : UIImage!
                if totalIncome > 0{
                    icon = normalImage
                }else{
                    icon = nonImage
                }
                
                return ChartDataEntry(x: Double(i), y: totalIncome, icon:icon, data: [
                    "dayBudgets":item,
                    "type": BudgetType.income
                ] as [String : Any])
           }
            incomeSet = LineChartDataSet(entries: inComeValues, label: "收入")
        }
        incomeSet.setColor(.green)
        incomeSet.setCircleColor(.green)
        incomeSet.gradientPositions = nil
        incomeSet.lineWidth = 1
        incomeSet.circleRadius = 3
        incomeSet.drawCircleHoleEnabled = true
        incomeSet.valueFont = .systemFont(ofSize: 9)
        incomeSet.valueTextColor = .kTextBlack
        incomeSet.drawValuesEnabled = false // 隐藏点上的数字
        
        
        
        
        let marker = BalloonMarker(bgColor: .kBlack,
                                   insets: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
        marker.chartView = chartView
        chartView.marker = marker
        let data = LineChartData(dataSets: [incomeSet,outcomeSet])
        chartView.data = data
    }
}

extension ChartPageVC : JXSegmentedViewDelegate{
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        self.currentStartDate = self.dates[index]
        self.updateChart()
    }
    
    func segmentedView(_ segmentedView: JXSegmentedView, didClickSelectedItemAt index: Int) {
        
    }
    
    func segmentedView(_ segmentedView: JXSegmentedView, didScrollSelectedItemAt index: Int) {
        
    }
    
    func segmentedView(_ segmentedView: JXSegmentedView, scrollingFrom leftIndex: Int, to rightIndex: Int, percent: CGFloat) {
        
    }
    
    func segmentedView(_ segmentedView: JXSegmentedView, canClickItemAt index: Int) -> Bool {
        true
    }
    
}
