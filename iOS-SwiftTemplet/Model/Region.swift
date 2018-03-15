//
//  Region.swift
//  iOS-SwiftTemplet
//
//  Created by 高敏 on 2018/3/15.
//  Copyright © 2018年 高敏. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Region {
    
    var code:String?
    
    var createdBy:String?
    
    var gmtCreate:String?
    
    var gmtLastUpdate:String?
    
    var id:String?
    
    var lastUpdatedBy:String?
    
    var level:String?
    
    var mapAddress:String?
    
    var name:String?
    
    var parentId:String?
    
    var path:String?
    
    var sort:String?
    
    var uId:String?
    
    var uName:String?
    
    
    init(_ json:JSON) {
        
        code = json["code"].stringValue
        createdBy = json["createdBy"].stringValue
        gmtCreate = json["gmtCreate"].stringValue
        gmtLastUpdate = json["gmtLastUpdate"].stringValue
        id = json["id"].stringValue
        lastUpdatedBy = json["lastUpdatedBy"].stringValue
        level = json["level"].stringValue
        mapAddress = json["mapAddress"].stringValue
        name = json["name"].stringValue
        parentId = json["parentId"].stringValue
        path = json["path"].stringValue
        sort = json["sort"].stringValue
        uId = json["uId"].stringValue
        uName = json["uName"].stringValue
        
    }
    
}
