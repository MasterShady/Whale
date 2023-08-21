//
//  WhaleButton.swift
//  Whale
//
//  Created by 刘思源 on 2023/8/21.
//

import UIKit
import CYLTabBarController

class WhaleButton: CYLPlusButton, CYLPlusButtonSubclassing {

    static func plusButton() -> Any {
        let button = WhaleButton()
        button.setImage(UIImage(named: "tabbar_plus"), for: .normal)
        button.size = CGSize(width: 48, height: 48)
        button.chain.backgroundColor(.kThemeColor).corner(radius: 24).clipsToBounds(true)
        button.addBlock(for: .touchUpInside) { _ in
            let vc = NavVC(rootViewController: CreateBudgetVC())
            UIViewController.getCurrent().present(vc, animated: true)
        }
        return button
    }


    static func indexOfPlusButtonInTabBar() -> UInt {
        return 1
    }

    static func multiplier(ofTabBarHeight _: CGFloat) -> CGFloat {
        return 0.3
    }

    static func constantOfPlusButtonCenterYOffset(forTabBarHeight _: CGFloat) -> CGFloat {
        return -10
    }

    static func plusChildViewController() -> UIViewController {
        let vc = CreateBudgetVC()
        let nav = UINavigationController(rootViewController: vc)
        return nav
    }

    static func shouldSelectPlusChildViewController() -> Bool {
        return false
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
}
