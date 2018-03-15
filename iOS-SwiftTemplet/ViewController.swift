//
//  ViewController.swift
//  iOS-SwiftTemplet
//
//  Created by 高敏 on 2018/3/9.
//  Copyright © 2018年 高敏. All rights reserved.
//

import UIKit
import Alamofire
import PromiseKit
import SwiftyJSON


class ViewController: UIViewController {

    var allRegions = [Region]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        

        userGetRegionNext()

        userLogin()
    }
    
    
    func userGetRegionNext() {
        
        
        ClientManager.shared().sendGET(API.IC.kRegionGetRegionNext, ["parentId":4]).done(on: DispatchQueue.main) {[weak self] (obj) in

            let json = JSON(obj)
            
            let regions = json.array
            
            for region in regions!{
                
                let reg = Region(region)
                
                self?.allRegions.append(reg)
                
            }
            
            
            
            log.debug(self?.allRegions[0].name)
            
            }.catch { (error) in

        }

        
    }
    
    func userLogin() {
        
        var params:Dictionary = [String:Any]()
        params["qmobile"] = "18570040966"
        params["qpassword"] = "gm123456"
        
        ClientManager.shared().sendRequest(.post, API.UC.kLogin, params).done(on: DispatchQueue.global()) { (obj) in
            
            
            let json = JSON(obj)
            
            
            let  user = User(json);
            
            log.debug(user.userDO?.personDO?.trueName ?? "")
            
            
            
            }.catch { (error) in
                
        }

        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

