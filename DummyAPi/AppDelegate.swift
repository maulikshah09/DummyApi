//
//  AppDelegate.swift
//  DummyAPi
//
//  Created by Maulik Shah on 05/02/22.
//

import UIKit
import SVProgressHUD

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        setupUi()
        return true
    }
 
}


extension AppDelegate {
    func setupUi(){
        SVProgressHUD.setBackgroundColor(UIColor.themeOrange())
        SVProgressHUD.setForegroundColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
    }
}

// Api id 
//61fe250a611ffea87335281b
