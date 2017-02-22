//
//  NSString+Extension.swift
//  MyQDaily
//
//  Created by 石冬冬 on 17/1/18.
//  Copyright © 2017年 sdd. All rights reserved.
//

import Foundation

extension String {
    
   
    static func getSecondWithTime(_ time:String) -> String {
         let longStr = time as NSString
        
        let timeDate = Date(timeIntervalSince1970:longStr.doubleValue/1000.0)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        let timeStr:NSString = dateFormatter.string(from: timeDate) as NSString
        let nowDateStr:NSString = dateFormatter.string(from: Date()) as NSString
        
        // 判断前四位是不是本年 不是本年直接返回完整时间
        let range1 = NSMakeRange(0, 4)
        let range2 = NSMakeRange(5, 5)
        timeStr.substring(with: range1).range(of: nowDateStr.substring(with: range1))
        
        return ""
    }
}
