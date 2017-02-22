//
//  HomeNewsDataManager.swift
//  MyQDaily
//
//  Created by 石冬冬 on 17/1/18.
//  Copyright © 2017年 sdd. All rights reserved.
//

import Foundation
import AFNetworking
class HomeNewsDataManager:AFHTTPSessionManager {
    
    static let shareInstance:HomeNewsDataManager = {
        let baseUrl = URL(string: "http://app3.qdaily.com/app3/")
        let instance = HomeNewsDataManager(baseURL: baseUrl, sessionConfiguration: URLSessionConfiguration.default)
        return instance
    }()

    func requestHomeNewDataWihtLastKey(_ lastkey:String,finished: @escaping (_ responseObject :[String: AnyObject]?, _ error :NSError?)->()) {
        let path = "homes/index/\(lastkey).json"
        get(path, parameters:nil, success: { (task, objc) -> Void in
            
           
            guard let arr = (objc as! [String: AnyObject])["response"] as? [String: AnyObject] else {
                
                finished(nil
                    , NSError(domain: "com.520it.lnj", code: 1000, userInfo: ["messages":"没有获取到数据"]))
                return
            }
            finished(arr, nil)
            
            }) { (task, error) -> Void in
                print(error)
                finished(nil, error as NSError?)
        }

    }
    
    func requestHomeLabsDataWithLastKey(_ lastkey:String,finished: @escaping (_ responseObject :[String: AnyObject]?, _ error :NSError?)->()) {
        let path = "papers/index/\(lastkey).json"
        get(path, parameters:nil, success: { (task, objc) -> Void in
            
            
            guard let arr = (objc as! [String: AnyObject])["response"] as? [String: AnyObject] else {
                
                finished(nil
                    , NSError(domain: "com.520it.lnj", code: 1000, userInfo: ["messages":"没有获取到数据"]))
                return
            }
            finished(arr, nil)
            
            }) { (task, error) -> Void in
                print(error)
                finished(nil, error as NSError?)
        }
    }
    
}

