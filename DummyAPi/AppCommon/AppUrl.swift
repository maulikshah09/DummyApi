//
//  AppUrl.swift
//  MyHealthTracker
//
//  Created by Maulik on 22/05/20.
//  Copyright © 2021 Lets Explore. All rights reserved.
//

 
let MAIN_URL                        =  "https://dummyapi.io/"
let BASE_URL                        =  MAIN_URL + "data/v1/"


let appstore_Url                    = "itms://itunes.apple.com/app/id1549390099?action=write-review"
let soketURl                        = "https://sheltered-woodland-24280.herokuapp.com/"



//let baseURL = MAIN_URL + "api/" + apiVersion
let apiVersion = "v1/"
let apiVersion2 = "v2/"
 

// MARK:- API URl
enum URLS : String {
    
    case logIn                    = "login"
    
    var raw: String {
        return  BASE_URL + self.rawValue
    }
}

 
