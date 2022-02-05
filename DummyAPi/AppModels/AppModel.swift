//
//  Model.swift
//  Created by Maulik on 22/05/20.
//  Copyright © 2021 Lets Explore. All rights reserved.
//

import ObjectiveC
import UIKit



//MARK:-  ----------- Common Things -------------

struct BlankData: Codable {}


struct BlankResponseData : Decodable {
}
  

////--------- Default Model FOR  EVERY API--------------
//struct FaceDateModel <T:Decodable>: Decodable {
//    private var message: UncertainValue<String,[String:String]>
//
//    var messageInfo : String? {
//        get {
//            if let msg = message.uValue{
//                return msg.values.joined(separator: ",\n")
//            }else{
//                return  self.message.tValue ?? ""
//            }
//        }
//    }
//
//    let status : Bool?
//    var data:T?
//    var isPlanExpired : Bool?
//    let pagination: Pagination?
//}


struct UserModel : Decodable {
    var total,page,limit: Int?
    var data :[UserListModel]?
}

struct UserListModel : Decodable{
    var firstName,id,lastName,picture,title,dateOfBirth,email,gender,phone : String?
    var location :LocationModel?
}

struct LocationModel: Decodable {
    var city,country,state,street,timezone : String?
}
 
struct PostModel : Decodable {
    var total,page,limit: Int?
    var data :[PostListModel]?
}

struct PostListModel : Decodable {
    var id,image,text : String?
    var likes : Double?
    var owner :OwnerModel?
    var tags : [String]?
}

struct OwnerModel : Decodable {
    var firstName,
        id,
        lastName,
        picture,
        title : String?
}



