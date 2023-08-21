//
//  TabbarVC.swift
//  gerental
//
//  Created by 刘思源 on 2022/12/8.
//

import Foundation
import UIKit


@objcMembers class TabbarVC : UITabBarController{
    
    
//    private let initializer: Void = {
//        let selectedAttributes: [NSAttributedString.Key: Any] = [
//            .font: UIFont.boldSystemFont(ofSize: 10),
//            .foregroundColor: UIColor.init(hexColor: "#333333")
//        ]
//        UITabBarItem.appearance().setTitleTextAttributes(selectedAttributes, for: .selected)
//
//        let normalAttributes: [NSAttributedString.Key: Any] = [
//            .font: UIFont.boldSystemFont(ofSize: 10),
//            .foregroundColor: UIColor.red
//        ]
//        UITabBarItem.appearance().setTitleTextAttributes(normalAttributes, for: .normal)
//
//
//    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.isTranslucent = false
        //tabBar.backgroundImage = UIImage(color: .white)
        tabBar.backgroundColor = .white
        tabBar.tintColor = .init(hexColor: "#333333")
        self.addChilds()
        

    }
    
        func addChilds(){
            let childs : [(String,String,BaseVC)] = [
                ("home","首页",DetailVC()),
                ("order","订单",DetailVC()),
                ("mine", "我的",DetailVC()),
            ]
    
            for child in childs {
                let imageName = "tabbar_" + child.0
                let normalImageName = imageName
                let selectedImageName = imageName + "_selected"
                let vc = NavVC(rootViewController: child.2)
                vc.tabBarItem.image = UIImage(named: normalImageName)?.withRenderingMode(.alwaysOriginal)
                vc.tabBarItem.selectedImage = UIImage(named: selectedImageName)?.withRenderingMode(.alwaysOriginal)
                vc.tabBarItem.title = child.1
                vc.tabBarItem.setTitleTextAttributes([
                    .font: UIFont.boldSystemFont(ofSize: 10),
                    .foregroundColor: UIColor.kTextBlack
                ], for: .selected)
                
                vc.tabBarItem.setTitleTextAttributes([
                    .font: UIFont.boldSystemFont(ofSize: 10),
                    .foregroundColor: UIColor.kTextDrakGray
                ], for: .disabled)
                
                
                self.addChild(vc)
    
            }
    
        }
    
    
    
}
