//
//  WhaleTabbarVC.swift
//  Whale
//
//  Created by 刘思源 on 2023/8/21.
//

import UIKit
import CYLTabBarController

class WhaleTabbarVC: CYLTabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.isTranslucent = false
        tabBar.backgroundImage = UIImage(color: .white)
        tabBar.backgroundColor = .white
        tabBar.tintColor = .kThemeColor
    }

}
