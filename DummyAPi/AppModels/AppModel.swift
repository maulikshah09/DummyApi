//
//  Model.swift
//  Created by Maulik on 22/05/20.
//  Copyright © 2021 Lets Explore. All rights reserved.
//

import ObjectiveC
import UIKit



//MARK:-  ----------- Common Things -------------

struct BlankData: Codable {}

struct BlankUserAuth: Codable {
    
    private var message: UncertainValue<String,[String:String]>

    var messageInfo : String? {
        get {
            if let msg = message.uValue{
                return msg.values.joined(separator: ",\n")
            }else{
                return  self.message.tValue ?? ""
            }
        }
    }
}

struct BlankResponseData : Decodable {
}
  

//--------- Default Model FOR  EVERY API--------------
struct FaceDateModel <T:Decodable>: Decodable {
    private var message: UncertainValue<String,[String:String]>
   
    var messageInfo : String? {
        get {
            if let msg = message.uValue{
                return msg.values.joined(separator: ",\n")
            }else{
                return  self.message.tValue ?? ""
            }
        }
    }
    
    let status : Bool?
    var data:T?
    var isPlanExpired : Bool?
    let pagination: Pagination?
}


 
