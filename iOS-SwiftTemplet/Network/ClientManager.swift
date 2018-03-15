//
//  ClientManager.swift
//  iOS-SwiftTemplet
//
//  Created by 高敏 on 2018/3/9.
//  Copyright © 2018年 高敏. All rights reserved.
//

import UIKit
import Alamofire
import CryptoSwift

class ClientManager: NSObject {

    class func shared()->PromiseNetwork{
        
        let network = PromiseNetwork.shared
        
        
        network._parameterEnconding = URLEncoding.default
        
        network.updateBaseUrl(baseURL: API.baseURL)
        
        
        let time:String = String(Date().timeIntervalSince1970 * 1000)
        let token:String = "511b266f-9d20-4a66-b983-7db93d522b23"
        let salt:String = "bd33e00cb003b58472e4995ad147e2d8"
        let userId:String = "1159"
        
        let valueCode:String = time+token+salt+userId
        let valueCodeMD5:String = valueCode.md5()
        
        let httpHeader:HTTPHeaders = ["token":token, "time":time, "valueCode":valueCodeMD5]
        
        network._httpHeader = httpHeader
        
        
        
        
        network.addInterceptor(intercept: { (res) -> Dictionary<String, Any> in
        
            var error:NSError?

            // 判断是否为空
            guard res != nil else{

                error = NSError.init(domain: "CodeFilter", code: 1000, userInfo: [NSLocalizedDescriptionKey:"网络异常"])
                return ["error":error ?? ""]
            }

            if ((res as? [String:Any]) != nil){

                let data:Dictionary = res as! Dictionary<String, Any>

                if data.keys.count < 0 {
                    error = NSError.init(domain: "CodeFilter", code: 1001, userInfo: [NSLocalizedDescriptionKey:"网络繁忙"])
                    return ["error":error ?? ""]

                }

                if data.keys.contains("success") && data.keys.contains("models"){

                    let isSuccess:Bool =  data["success"] as! Bool

                    if isSuccess == false{

                        error = NSError.init(domain: "CodeFilter", code: 1002, userInfo: [NSLocalizedDescriptionKey:"errorMap"])
                        return ["error":error ?? ""]

                    }

                    return ["data":data["models"] ?? "models数据为空"]

                }



                return ["data":res ?? "数据为空"]
            }





            return ["data":res ?? ""]

            
            
        }, key: "0")
        
        // 移除拦截器
//        network.removeInterceptor(key: "0")
        
        

        
        
        
        return network
    }
    
    
}
