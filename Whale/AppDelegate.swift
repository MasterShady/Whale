//
//  AppDelegate.swift
//  Whale
//
//  Created by 刘思源 on 2023/8/21.
//

import UIKit
import CYLTabBarController
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    var window: UIWindow?



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        WhaleButton.register()
        
        let viewControllers = [CYLBaseNavigationController(rootViewController: DetailVC()),CYLBaseNavigationController(rootViewController: DetailVC())]
        
        let detailImage = UIImage(named: "tabbar_detail")!.withRenderingMode(.alwaysOriginal)
        let selectedDetailImage = detailImage.colored(.kThemeColor)!.withRenderingMode(.alwaysOriginal)
        
        let items : [[String : Any]] = [
            [
                CYLTabBarItemTitle: "明细",
                CYLTabBarItemImage: detailImage,
                CYLTabBarItemSelectedImage: selectedDetailImage,
            ] ,
            [
                CYLTabBarItemTitle: "趋势",
                CYLTabBarItemImage: "001-restaurant",
                CYLTabBarItemSelectedImage: "001-restaurant"
            ],
        ]
        
        
        let tabbarController = WhaleTabbarVC(viewControllers: viewControllers, tabBarItemsAttributes: items)
        
        
        if window == nil{
            window = UIWindow(frame: UIScreen.main.bounds)
        }
        window?.rootViewController = tabbarController
        window?.makeKeyAndVisible()
        
        
        
        return true
    }


}

