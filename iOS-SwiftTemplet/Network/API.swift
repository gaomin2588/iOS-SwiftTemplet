//
//  API.swift
//  iOS-SwiftTemplet
//
//  Created by 高敏 on 2018/3/12.
//  Copyright © 2018年 高敏. All rights reserved.
//

import UIKit

class API: NSObject {

    static let baseURL:String    = "http://zl.zooming-data.com"
    
    struct URL{
        
        static  let kMsgUnReadSum:String          = "/uc/shortMsg/tenantUnReadSum"
        
        static  let kMsgUnReadSumLandord:String   = "/uc/shortMsg/landlordUnReadSum"
        
        
        static  let kRegionGetRegionNext:String   =  "/ic/region/getRegionNext"

        
        
    }
    
    
}



