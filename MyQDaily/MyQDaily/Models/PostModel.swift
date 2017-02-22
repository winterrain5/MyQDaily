//
//  PostModel.swift
//  MyQDaily
//
//  Created by 石冬冬 on 17/1/18.
//  Copyright © 2017年 sdd. All rights reserved.
//

import Foundation
import MJExtension

class PostModel: NSObject {
    /**新闻标题*/
    var title:String?
    /**副标题*/
    var subhead:String?
    /**出版时间*/
    var publish_time:String?
    /**配图*/
    var image:String?
    /**评论数*/
    var comment_count:String?
    /**点赞数*/
    var praise_count:String?
    /**新闻文章链接（html格式）*/
    var appview:String?
    
    var category:CategoryModel?
    
    override static func mj_replacedKeyFromPropertyName() -> [AnyHashable: Any]! {
        return ["subhead":"description"]
    }
}
