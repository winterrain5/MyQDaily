//
//  FeedsModel.swift
//  MyQDaily
//
//  Created by 石冬冬 on 17/1/18.
//  Copyright © 2017年 sdd. All rights reserved.
//

import Foundation

class FeedsModel: NSObject {
    
    /**文章类型 （以此来判断cell的样式*/
    var type:String?
    /**文章配图*/
    var image:String?
    
    var post:PostModel?
}
