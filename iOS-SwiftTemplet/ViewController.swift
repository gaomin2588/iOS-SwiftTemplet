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

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        PromiseNetwork.networkLog = true
        
        ClientManager.shared().sendGET(API.URL.kRegionGetRegionNext, ["parentId":4]).done(on: DispatchQueue.main) { (obj) in
//            print("obj----\(obj)")
            }.catch { (error) in
//                print(error)
        }
        
        

        

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

