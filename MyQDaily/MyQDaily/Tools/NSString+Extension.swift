//
//  NSString+Extension.swift
//  MyQDaily
//
//  Created by 石冬冬 on 17/1/18.
//  Copyright © 2017年 sdd. All rights reserved.
//

import Foundation

extension String {
    
   
    static func getSecondWithTime(time:String) -> String {
         let longStr = time as NSString
        
        let timeDate = NSDate(timeIntervalSince1970:longStr.doubleValue/1000.0)
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        let timeStr:NSString = dateFormatter.stringFromDate(timeDate)
        let nowDateStr:NSString = dateFormatter.stringFromDate(NSDate())
        
        // 判断前四位是不是本年 不是本年直接返回完整时间
        let range1 = NSMakeRange(0, 4)
        let range2 = NSMakeRange(5, 5)
        timeStr.substringWithRange(range1).rangeOfString(nowDateStr.substringWithRange(range1))
        
        return ""
    }
}