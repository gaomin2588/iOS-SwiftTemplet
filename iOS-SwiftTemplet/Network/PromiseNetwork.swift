//
//  PromiseNetwork.swift
//  iOS-SwiftTemplet
//
//  Created by 高敏 on 2018/3/10.
//  Copyright © 2018年 高敏. All rights reserved.
//

import UIKit
import Alamofire
import PromiseKit



typealias interceptor = (Any?)-> [String:Any]



class PromiseNetwork: NSObject {
    
    
    static let sharedNormal = PromiseNetwork()

    // 是否打印log日志 默认为YES
    static var networkLog:Bool = true
    
    
    /// 请求头
    var _httpHeader:HTTPHeaders?
    
    /// 序列化方式
    var _parameterEnconding:ParameterEncoding = URLEncoding.default
    
    /// 网络请求任务
    var _task:Array = [Request]()
    
    
    /// 拦截器容器
    private var _interceptors:Dictionary = [String:interceptor]()
    
    /// 基础链接
    private var _baseURL:String = ""
    
    private var _kkk:Array = [interceptor]()
    

    override init() {
        super.init()
    }
    
    
    /// 设置基础网址
    ///
    /// - Parameter baseURL: 设置基础网址
    public func updateBaseUrl(baseURL:String){
        _baseURL = baseURL
    }
    

    
    
    /// 添加拦截器
    ///
    /// - Parameters:
    ///   - intercept: 拦截器
    ///   - key: 拦截器的值
    public func addInterceptor(intercept:@escaping interceptor, key:String){
        
        _interceptors[key] = intercept
        
       
    }
    
    
    /// 根据键 移除拦截器
    ///
    /// - Parameter key: 键
    public func removeInterceptor(key:String){
       
       
        
        
        _interceptors.removeValue(forKey: key)
    }
    
    
    /// 移除全部拦截器
    public func removeAllInterceptor(){
        _interceptors.removeAll()
    }
    
    
    
    /// 移除指定链接请求
    ///
    /// - Parameter url: 链接
    public func cancelRequest(url:String){
        
        for (index, request) in _task.enumerated() {
            
            
            let isFindUrl:Bool = (request.task?.currentRequest?.url?.absoluteString.hasSuffix(url))!

            if isFindUrl == true {
                request.task?.cancel()
                _task.remove(at: index)
            }
            
            
        }

    }
    
    
    /// 移除全部请求
    public func cancelAllRequest(){
        
        for (index, request) in _task.enumerated() {
            
            request.task?.cancel()
            
            _task.remove(at: index)
            
        }
        
        
    }
    
    
    
    
    /// post 请求
    ///
    /// - Parameters:
    ///   - url: url
    ///   - parameters: 参数
    ///   - Returns: Promise
    public func sendPOST(_ url:String, _ parameters:Parameters?) -> Promise<Any>{
        
        return sendRequest(.post, url, parameters)
    }
    
    

    
    
    /// get 请求
    ///
    /// - Parameters:
    ///   - url: url
    ///   - parameters: 请求参数
    /// - Returns: Promise
    public func sendGET(_ url:String, _ parameters:Parameters?) -> Promise<Any> {
        
        return sendRequest(.get, url, parameters)
    }
    
    
    
    
    /// 基础请求
    ///
    /// - Parameters:
    ///   - method: 请求方式
    ///   - url: url
    ///   - parameters: 请求参数
    /// - Returns: Promise
    public func sendRequest(_ method:HTTPMethod, _ url:String, _ parameters:Parameters?) -> Promise<Any>{
        
        let fullURL = _baseURL + url
        
        return Promise {seal in
            let dataRequest = request(fullURL, method: method, parameters: parameters, encoding: _parameterEnconding, headers: _httpHeader).validate().responseJSON(completionHandler: {[weak self] (response) in
                
                ///  从任务组移除
                for (index, request) in (self?._task.enumerated())! {
                    
                    let isFindUrl:Bool = (request.task?.currentRequest?.url?.absoluteString.hasSuffix(url))!
                    if isFindUrl == true {
                        self?._task.remove(at: index)
                    }
                    
                }
                
                ///  处理响应
                switch response.result.isSuccess{
                    
                case true:
                    
                    self?.successBusiness(response, fullURL ,parameters, method, seal)
                    
                case false:
                    
                    
                    self?.logFailure(response, fullURL, parameters, method, response.error!)
                    seal.reject(response.error!)
                    
                }
                
                
            })
            
            _task.append(dataRequest)
        }

        
        
    }

    
    
    
    
    
}

// MARK: 私有方法
extension PromiseNetwork{
    
    
    /// 请求成功 对信息过滤拦截
    ///
    /// - Parameters:
    ///   - rensonse: 数据响应
    ///   - url: 数据url
    ///   - seal: Promise -> Resolver
    private func successBusiness(_ rensonse:DataResponse<Any>, _ url:String, _ parameters:Parameters?, _ method:HTTPMethod, _ seal:Resolver<Any>) {
        
        // 没有设置拦截器的时候
        if _interceptors.values.count == 0 {
            self.logSuccess(rensonse, url, parameters, method)
            seal.fulfill(rensonse.result.value ?? "空数据")
            return
        }
        
        // 有拦截器
        for interc in _interceptors.values {
            
            
            let dict:Dictionary = interc(rensonse.result.value ?? "")
            
            
            if dict["error"] != nil {
                
                self.logFailure(rensonse, url, parameters, method, (dict["error"] as? Error)!)
                seal.reject(dict["error"] as! Error)
                
                return
            }
            
            
            seal.fulfill(dict["data"] ?? "")

            
        }
        
        self.logSuccess(rensonse, url, parameters, method)
        
    }
    
    
    /// 打印成功日志
    ///
    /// - Parameters:
    ///   - rensonse: 响应
    ///   - url: 链接
    ///   - parameters: 请求参数
    ///   - method: 请求方式
    private func logSuccess(_ rensonse:DataResponse<Any>, _ url:String, _ parameters:Parameters?, _ method:HTTPMethod) -> Void {
        
        if PromiseNetwork.networkLog == false {
            return
        }
        
        let fullURL = String(describing: rensonse.request?.url)
        
        
        if method == .post {
            
            log.debug("POST success, URL: \(fullURL) \n timeline: \(rensonse.timeline.totalDuration) \n response: \(String(describing: rensonse.result.value))")

            
            
            
        }else if method == .get{
            
            log.debug("GET success, URL: \(fullURL) \n timeline: \(rensonse.timeline.totalDuration) \n response: \(String(describing: rensonse.result.value))")
            
        }
        
        
   
        
    }
    
    /// 打印失败日志
    ///
    /// - Parameters:
    ///   - rensonse: 响应
    ///   - url: 链接
    ///   - parameters: 请求参数
    ///   - method: 请求方式
    ///   - error: Error
    private func logFailure(_ rensonse:DataResponse<Any>, _ url:String, _ parameters:Parameters?, _ method:HTTPMethod, _ error:Error) -> Void {
        
        if PromiseNetwork.networkLog == false {
            return
        }
        
        
        
        let fullURL = String(describing: rensonse.request?.url)
        
        
        if method == .post {
            
             log.debug("POST failured, URL: \(fullURL) \n timeline: \(rensonse.timeline.totalDuration) \n  error: \(error)")
            
            
        }else if method == .get{
            
             log.debug("GET failured, URL: \(fullURL) \n timeline: \(rensonse.timeline.totalDuration) \n error: \(error)")
            
        }
        
        
        
    }
    
}











