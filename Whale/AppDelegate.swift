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

    
    func setup() {
        let navigationBar = UINavigationBar.appearance()
        navigationBar.isTranslucent = false
        Configure.shared.setup()
        
        _ = Configure.shared.theme.asObservable().subscribe(onNext: { (theme) in
            ColorCenter.shared.theme = theme
            self.window?.tintColor = ColorCenter.shared.tint.value
            if theme == .black {
                if Configure.shared.markdownStyle.value == "GitHub" {
                    Configure.shared.markdownStyle.value = "GitHub Dark"
                }
                if Configure.shared.highlightStyle.value == "tomorrow" {
                    Configure.shared.highlightStyle.value = "tomorrow-night"
                }
            } else {
                if Configure.shared.markdownStyle.value == "GitHub Dark" {
                    Configure.shared.markdownStyle.value = "GitHub"
                }
                if Configure.shared.highlightStyle.value == "tomorrow-night" {
                    Configure.shared.highlightStyle.value = "tomorrow"
                }
            }
        })
        
        _ = Configure.shared.darkOption.asObservable().subscribe(onNext: { (darkOption) in
            var value = Configure.shared.theme.value
            switch darkOption {
                case .dark:
                    value = .black
                case .light:
                    if value == .black {
                        value = .white
                    }
                case .system:
                    if #available(iOS 13.0, *) {
                        if UITraitCollection.current.userInterfaceStyle == .dark {
                            value = .black
                        } else if Configure.shared.theme.value == .black {
                            value = .white
                        }
                    } else {
                        ActivityIndicator.showError(withStatus: "Only Work on iPad OS / iOS 13")
                    }
            }
            if Configure.shared.theme.value != value {
                Configure.shared.theme.value = value
            }
        })

}

