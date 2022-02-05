//
//  Enums.swift
//
//  Created by Maulik on 15/06/20.
//  Copyright © 2021 Lets Explore. All rights reserved.
//
 

//MARK:- All image name
public enum AppImages : String{
    case ic_MyHealth          = "ic_MyHealth"
    case ic_RedButton         = "red_button_backgroud"
    case ic_BlueButton        = "blue_button_backgroud"
}

//All Navigation name
enum AppNavigationTitle : String {
    
    case ListUser = "User List"
    
    var localized: String {
        return self.rawValue //.localized
    }
}

 
 

//All Alert name
enum AlertTitle : String {
    case ok                    = "Ok"
    case cancel                = "Cancel"
    case yes                   = "Yes"
    case no                    = "No"
 
    var localized: String {
        return self.rawValue //.localized
    }
}


 
enum AppMessage: String{
    
    case cameraPermission        = "Camera permission is not allowed. Please go to settings and allow permission"
    case cameraSourceType        = "Camera is not available. Please go to settings and allow camera"
    case microPhonePermission    = "MicroPhone permission is not allowed. Please go to settings and allow permission"
    case noInternet              = "No Internet Connection. Please Try Again"
    case somthingWantWrng        = "Something Wrong.Please try again"
    
    var localized: String {
        return self.rawValue ///.localized
    }
}


enum AppInfo : String {
    case CreateAccount          = "Create account"
     
    
    var localized: String {
        return self.rawValue  ///.localized
    }
}

 
