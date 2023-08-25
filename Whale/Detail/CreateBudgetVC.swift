//
//  CreateBudgetVC.swift
//  Whale
//
//  Created by 刘思源 on 2023/8/21.
//

import UIKit
import JXSegmentedView

class CreateBudgetVC: BaseVC {

    override func configNavigationBar() {
        let dismissItem = UIBarButtonItem(title: "取消", style: .plain, target: nil, action: nil)
        dismissItem.actionBlock = { [weak self] _ in
            self?.dismiss(animated: true)
        }
        self.navigationItem.rightBarButtonItem = dismissItem
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = segmentedV
        view.addSubview(listContainerView)
        segmentedDS.titles = ["支出","收入"]
        segmentedV.dataSource = segmentedDS
        segmentedV.listContainer = listContainerView
        segmentedV.reloadData()
     
    }
    
    
    lazy var listContainerView: JXSegmentedListContainerView = {
        let lv = JXSegmentedListContainerView(dataSource: self)
        lv.frame = CGRect(x: 0, y: kNavBarMaxY, width: kScreenWidth, height: kScreenHeight - kNavBarMaxY)
        return lv
    }()
    private lazy var segmentedV: JXSegmentedView = {
        let segment = JXSegmentedView(frame:CGRect(x: 0, y: 0, width: 150, height: 35))
        segment.backgroundColor = .clear
        segment.indicators = [sliderView]
        return segment
    }()
    private lazy var segmentedDS: JXSegmentedTitleDataSource = {
        let source = JXSegmentedTitleDataSource()
        source.titleNormalFont = .systemFont(ofSize: 15)
        source.titleNormalColor = .kTextBlack
        source.titleSelectedFont = .semibold(18)
        source.titleSelectedColor = .kTextBlack
        return source
    }()
    
    lazy var sliderView: JXSegmentedIndicatorLineView = {
        let view = JXSegmentedIndicatorLineView()
        view.indicatorColor = .kBlack
        view.indicatorWidth = 14 //横线宽度
        view.indicatorHeight = 3 //横线高度
        view.verticalOffset = 0 //垂直方向偏移
        view.indicatorCornerRadius = 2
        return view
    }()

}


extension CreateBudgetVC: JXSegmentedListContainerViewDataSource {
    //MARK: JXSegmentedViewDelegate
    //点击标题 或者左右滑动都会走这个代理方法
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        //这里处理左右滑动或者点击标题的事件
        
    }
    //MARK:JXSegmentedListContainerViewDataSource
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        2
    }
    
    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        if index == 0 {
            let vc = CreateBudgetTypeVC(type: .outcome)
            return vc
        }
        else {
            let vc = CreateBudgetTypeVC(type: .income)
            return vc
        }
        
    }
    
}
