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
        let baseUrl = NSURL(string: "http://app3.qdaily.com/app3/homes/index/")
        let instance = HomeNewsDataManager(baseURL: baseUrl, sessionConfiguration: NSURLSessionConfiguration.defaultSessionConfiguration())
        return instance
    }()

    func requestHomeNewDataWihtLastKey(lastkey:String,finished: (responseObject :[String: AnyObject]?, error :NSError?)->()) {
        let path = "\(lastkey).json"
        GET(path, parameters:nil, success: { (task, objc) -> Void in
            
           
            guard let arr = (objc as! [String: AnyObject])["response"] as? [String: AnyObject] else {
                
                finished(responseObject: nil
                    , error: NSError(domain: "com.520it.lnj", code: 1000, userInfo: ["messages":"没有获取到数据"]))
                return
            }
            finished(responseObject: arr, error: nil)
            
            }) { (task, error) -> Void in
                print(error)
                finished(responseObject: nil, error: error)
        }

    }
    
   
    
}

