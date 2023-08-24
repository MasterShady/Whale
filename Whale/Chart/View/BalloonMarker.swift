//
//  BalloonMarker.swift
//  ChartsDemo
//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/Charts
//

import Foundation
import DGCharts
#if canImport(UIKit)
    import UIKit
#endif

open class BalloonMarker: MarkerImage
{
    @objc open var color: UIColor
    @objc open var arrowSize = CGSize(width: 15, height: 11)
//    @objc open var font: UIFont
//    @objc open var textColor: UIColor
    @objc open var insets: UIEdgeInsets
    @objc open var minimumSize = CGSize()
    
    var totalCost: String?
    var maxCost: String?
    var maxCostImage: UIImage?
    
    var dayBudgets: DayBudgets!
    var type: BudgetType!
    
    fileprivate var label: String?
    fileprivate var _labelSize: CGSize = CGSize()
    fileprivate var _paragraphStyle: NSMutableParagraphStyle?
    fileprivate var _drawAttributes = [NSAttributedString.Key : Any]()
    
    @objc public init(bgColor:UIColor,insets: UIEdgeInsets)
    {
        self.color = bgColor
//        self.font = font
//        self.textColor = textColor
        self.insets = insets
        
        _paragraphStyle = NSParagraphStyle.default.mutableCopy() as? NSMutableParagraphStyle
        _paragraphStyle?.alignment = .center
        super.init()
    }
    
    open override func offsetForDrawing(atPoint point: CGPoint) -> CGPoint
    {
        var offset = self.offset
        var size = self.size

        if size.width == 0.0 && image != nil
        {
            size.width = image!.size.width
        }
        if size.height == 0.0 && image != nil
        {
            size.height = image!.size.height
        }

        let width = size.width
        let height = size.height
        let padding: CGFloat = 8.0

        var origin = point
        origin.x -= width / 2
        origin.y -= height

        if origin.x + offset.x < 0.0
        {
            offset.x = -origin.x + padding
        }
        else if let chart = chartView,
            origin.x + width + offset.x > chart.bounds.size.width
        {
            offset.x = chart.bounds.size.width - origin.x - width - padding
        }

        if origin.y + offset.y < 0
        {
            offset.y = height + padding;
        }
        else if let chart = chartView,
            origin.y + height + offset.y > chart.bounds.size.height
        {
            offset.y = chart.bounds.size.height - origin.y - height - padding
        }

        return offset
    }
    
    open override func draw(context: CGContext, point: CGPoint)
    {
        //guard let label = label else { return }
        
        let offset = self.offsetForDrawing(atPoint: point)
        let size = self.size
        
        var rect = CGRect(
            origin: CGPoint(
                x: point.x + offset.x,
                y: point.y + offset.y),
            size: size)
        rect.origin.x -= size.width / 2.0
        rect.origin.y -= size.height
        
        context.saveGState()

        context.setFillColor(color.cgColor)

        if offset.y > 0
        {
            context.beginPath()
            context.move(to: CGPoint(
                x: rect.origin.x,
                y: rect.origin.y + arrowSize.height))
            context.addLine(to: CGPoint(
                x: rect.origin.x + (rect.size.width - arrowSize.width) / 2.0,
                y: rect.origin.y + arrowSize.height))
            //arrow vertex
            context.addLine(to: CGPoint(
                x: point.x,
                y: point.y))
            context.addLine(to: CGPoint(
                x: rect.origin.x + (rect.size.width + arrowSize.width) / 2.0,
                y: rect.origin.y + arrowSize.height))
            context.addLine(to: CGPoint(
                x: rect.origin.x + rect.size.width,
                y: rect.origin.y + arrowSize.height))
            context.addLine(to: CGPoint(
                x: rect.origin.x + rect.size.width,
                y: rect.origin.y + rect.size.height))
            context.addLine(to: CGPoint(
                x: rect.origin.x,
                y: rect.origin.y + rect.size.height))
            context.addLine(to: CGPoint(
                x: rect.origin.x,
                y: rect.origin.y + arrowSize.height))
            context.fillPath()
        }
        else
        {
            context.beginPath()
            context.move(to: CGPoint(
                x: rect.origin.x,
                y: rect.origin.y))
            context.addLine(to: CGPoint(
                x: rect.origin.x + rect.size.width,
                y: rect.origin.y))
            context.addLine(to: CGPoint(
                x: rect.origin.x + rect.size.width,
                y: rect.origin.y + rect.size.height - arrowSize.height))
            context.addLine(to: CGPoint(
                x: rect.origin.x + (rect.size.width + arrowSize.width) / 2.0,
                y: rect.origin.y + rect.size.height - arrowSize.height))
            //arrow vertex
            context.addLine(to: CGPoint(
                x: point.x,
                y: point.y))
            context.addLine(to: CGPoint(
                x: rect.origin.x + (rect.size.width - arrowSize.width) / 2.0,
                y: rect.origin.y + rect.size.height - arrowSize.height))
            context.addLine(to: CGPoint(
                x: rect.origin.x,
                y: rect.origin.y + rect.size.height - arrowSize.height))
            context.addLine(to: CGPoint(
                x: rect.origin.x,
                y: rect.origin.y))
            context.fillPath()
        }
        
        if offset.y > 0 {
            rect.origin.y += self.insets.top + arrowSize.height
        } else {
            rect.origin.y += self.insets.top
        }

        rect.size.height -= self.insets.top + self.insets.bottom
        
        UIGraphicsPushContext(context)
        
        var budgets = dayBudgets.getBudget(type: type)
        
        if budgets.count == 0{
            let title = type == .income ? "没有收入" : "没有支出"
            title.draw(in: rect, withAttributes: [
                .font : UIFont.semibold(12),
                .foregroundColor: UIColor.white,
                .paragraphStyle : _paragraphStyle
            ])
        }else{
            
            var title = ""
            if budgets.count > 3{
                budgets = budgets.sorted(by: \.amount).reversed().suffix(3)
                title = String(format: "最大3比%@",type == .income ? "收入":"支出")
            }else{
                title = String(format: "共%zd比%@", budgets.count,type == .income ? "收入":"支出")
            }
            
            
            let titleFrame = CGRect(x: rect.minX, y: rect.minY + 8, width: rect.width, height: 20)
            title.draw(in: titleFrame, withAttributes: [
                .font : UIFont.semibold(12),
                .foregroundColor: UIColor.white,
                .paragraphStyle : _paragraphStyle
            ])
            
            var imageFrame = CGRect(x: titleFrame.minX + 8, y: titleFrame.maxY + 8, width: 24, height: 24)
            var dateFrame = CGRect(x: imageFrame.maxX + 6, y: imageFrame.minY + 5, width: 150, height: 20)
            
            for i in 0..<min(budgets.count, 3) {
                let budget = budgets[i]
                let image = UIImage(named: budget.type!.iconName)!.drawInColor(color: .kThemeColor, size: CGSize(width: 24, height: 24), cornerRadius: 10, tintColor: .white, insets: .init(top: 4, left: 4, bottom: 4, right: 4))
                image.draw(in: imageFrame)
                let date = budget.date.dateString(withFormat: "YYYY/MM/dd") + "  " + budget.type!.description + "  " + String(format: "%.2f",budget.amount)
                date.draw(in: dateFrame, withAttributes: [
                    .font : UIFont.systemFont(ofSize:10),
                    .foregroundColor: UIColor.white,
                ])
                if (i != budgets.count - 1){
                    imageFrame = imageFrame.offsetBy(dx: 0, dy: 32)
                    dateFrame = CGRect(x: imageFrame.maxX + 6, y: imageFrame.minY + 5, width: 150, height: 20)
                }
            }
            
            let total = String(format: "当日总%@:%.2f", type == .income ? "收入" : "支出", type == .income ? dayBudgets.totalIncome : dayBudgets.totalOutcome)
            let totalFrame = CGRect(x:rect.minX + 8, y: imageFrame.maxY + 8, width: rect.width, height: 20)
            total.draw(in: totalFrame, withAttributes:[
                .font : UIFont.systemFont(ofSize:10),
                .foregroundColor: UIColor.white,
            ])
            
        }
        
        UIGraphicsPopContext()
        
        context.restoreGState()
    }
    
    open override func refreshContent(entry: ChartDataEntry, highlight: Highlight)
    {
        
        let data = entry.data as! [String: Any]
        dayBudgets = data["dayBudgets"] as? DayBudgets
        type = data["type"] as? BudgetType
        let budgets = dayBudgets.getBudget(type: type)
        let maxCount = min(budgets.count, 3)
        if budgets.count == 0{
            self.size = CGSize(width: 150, height: 50)
        }else{
            self.size = CGSize(width: 200, height:8 + 20 + 8 + maxCount * 24 + (maxCount - 1) * 8 + 24 + 8 + insets.top + insets.bottom)
        }
        
        
        
        
//        _drawAttributes.removeAll()
//        _drawAttributes[.font] = self.font
//        _drawAttributes[.paragraphStyle] = _paragraphStyle
//        _drawAttributes[.foregroundColor] = self.textColor
//
//        _labelSize = totalCost?.size(withAttributes: _drawAttributes) ?? CGSize.zero
//
//        let imageSize = CGSize(width: 24, height: 24)
//
//        var size = CGSize()
//        size.width = _labelSize.width + self.insets.left + self.insets.right
//
//
//        size.height = _labelSize.height + 8 + imageSize.height + self.insets.top + self.insets.bottom
//        size.width = max(minimumSize.width, size.width)
//        size.height = max(minimumSize.height, size.height)
//
//        self.size =  size
        
        
        
        
        
        //setLabel(String(entry.y))
    }
    
//    @objc open func setLabel(_ newLabel: String)
//    {
//        label = newLabel
//
//        _drawAttributes.removeAll()
//        _drawAttributes[.font] = self.font
//        _drawAttributes[.paragraphStyle] = _paragraphStyle
//        _drawAttributes[.foregroundColor] = self.textColor
//
//        _labelSize = label?.size(withAttributes: _drawAttributes) ?? CGSize.zero
//
//        var size = CGSize()
//        size.width = _labelSize.width + self.insets.left + self.insets.right
//        size.height = _labelSize.height + self.insets.top + self.insets.bottom
//        size.width = max(minimumSize.width, size.width)
//        size.height = max(minimumSize.height, size.height)
//        self.size = size
//    }
}
