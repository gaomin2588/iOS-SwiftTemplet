//
//  User.swift
//  iOS-SwiftTemplet
//
//  Created by 高敏 on 2018/3/15.
//  Copyright © 2018年 高敏. All rights reserved.
//

import Foundation
import SwiftyJSON

struct User{

    var signCode:String?
    
    var token:String?
    
    var userDO:UserDO?
    
    init(_ json:JSON) {
        

        signCode = json["signCode"].stringValue
        token = json["token"].stringValue
        userDO = UserDO(json["userDO"])

    }
    
    
}


struct UserDO {
    
    var deviceToken:String?
    
    var gmtCreate:String?
    
    var gmtLastUpdate:String?
    
    var id:String?
    
    var mobile:String?
    
    var nickName:String?
    
    var password:String?
    
    var phoImgUrl:String?
    
    var platformDevice:String?
    
    var sources:String?
    
    var sourcesSign:String?
    
    var uId:String?
    
    var personDO:PersonDO?
    
    init(_ json:JSON) {
        
        deviceToken = json["deviceToken"].stringValue
        gmtCreate = json["gmtCreate"].stringValue
        gmtLastUpdate = json["gmtLastUpdate"].stringValue
        id = json["id"].stringValue
        mobile = json["mobile"].stringValue
        nickName = json["nickName"].stringValue
        password = json["password"].stringValue
        phoImgUrl = json["phoImgUrl"].stringValue
        platformDevice = json["platformDevice"].stringValue
        sources = json["sources"].stringValue
        sourcesSign = json["sourcesSign"].stringValue
        uId = json["uId"].stringValue
        personDO = PersonDO(json["personDO"])
        
        
    }
    
}


struct PersonDO {
    
    var certificateCode:String?
    
    var trueName:String?
    
    init(_ json:JSON) {
        certificateCode = json["certificateCode"].stringValue
        trueName = json["trueName"].stringValue
    }
}


