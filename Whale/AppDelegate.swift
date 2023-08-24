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
        //NavVC.navBarDefault
        
        let viewControllers = [NavVC(rootViewController: DetailVC()),NavVC(rootViewController: ChartPageVC())]
        
        let detailImage = UIImage(named: "bill")!.withRenderingMode(.alwaysOriginal)
        let selectedDetailImage = detailImage.colored(.kThemeColor)!.withRenderingMode(.alwaysOriginal)
        
        let items : [[String : Any]] = [
            [
                
                CYLTabBarItemImage: detailImage,
                CYLTabBarItemSelectedImage: selectedDetailImage,
            ] ,
            [
                
                CYLTabBarItemImage: UIImage(named: "bar-chart")!.withRenderingMode(.alwaysOriginal),
                CYLTabBarItemSelectedImage: UIImage(named: "bar-chart")!.colored(.kThemeColor)!.withRenderingMode(.alwaysOriginal)
            ],
        ]
        
        
        let tabbarController = WhaleTabbarVC(viewControllers: viewControllers, tabBarItemsAttributes: items)
        tabbarController.tabBar.backgroundColor = .kExLightGray
        
        
        if window == nil{
            window = UIWindow(frame: UIScreen.main.bounds)
        }
        window?.rootViewController = tabbarController
        window?.makeKeyAndVisible()
        
        
        
        return true
    }


}

