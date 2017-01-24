//
//  HomeNewsCell.swift
//  MyQDaily
//
//  Created by 石冬冬 on 17/1/18.
//  Copyright © 2017年 sdd. All rights reserved.
//

import UIKit
import SDWebImage


class HomeNewsCell: UITableViewCell {

    // MARK: -内部属性和方法
    // 分割线
    private var cellSepator:UIView?
    // 新闻图片
    private var newsImageView:UIImageView?
    // 标题
    private var newsTitleLabel:UILabel?
    // 子标题
    private var subheadLabel:UILabel?
    // 评论图片
    private var commentImageView:UIImageView?
    // 点赞图片
    private var praiseImageView:UIImageView?
    
    // 新闻类型
    private var newsTypeLabel:UILabel?
    // 评论数
    private var commentLabel:UILabel?
    // 点赞数
    private var praiseLabel:UILabel?
    // 新闻发布时间
    private var timeLabel:UILabel?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        newsImageView = UIImageView()
        contentView.addSubview(newsImageView!)
        
        newsTitleLabel = UILabel()
        newsTitleLabel?.textColor = UIColor.init(red: 42/255, green: 42/255, blue: 42/255, alpha: 1)
        newsTitleLabel?.font = UIFont(name: "Helvetica-Bold", size: 17.0)
        newsTitleLabel?.numberOfLines = 5
        contentView.addSubview(newsTitleLabel!)
        
        subheadLabel = UILabel()
        subheadLabel?.font = UIFont(name: "Helvetica", size: 15.0)
        subheadLabel?.textColor = UIColor.grayColor()
        subheadLabel?.numberOfLines = 3
        contentView.addSubview(subheadLabel!)
        
        newsTypeLabel = UILabel()
        newsTypeLabel?.font = UIFont.systemFontOfSize(12.0)
        newsTypeLabel?.textColor = UIColor.grayColor()
        contentView .addSubview(newsTypeLabel!)
        
        commentLabel = UILabel()
        commentLabel?.textAlignment = NSTextAlignment.Center
        commentLabel?.font = UIFont.systemFontOfSize(13.0)
        commentLabel?.textColor = UIColor.grayColor()
        contentView .addSubview(commentLabel!)
        
        praiseLabel = UILabel()
        praiseLabel?.textAlignment = NSTextAlignment.Center
        praiseLabel?.font = UIFont.systemFontOfSize(13.0)
        praiseLabel?.textColor = UIColor.grayColor()
        contentView .addSubview(praiseLabel!)
        
        timeLabel = UILabel()
        timeLabel?.textAlignment = NSTextAlignment.Center
        timeLabel?.font = UIFont.systemFontOfSize(13.0)
        timeLabel?.textColor = UIColor.grayColor()
        contentView .addSubview(timeLabel!)
        
        cellSepator = UIView()
        cellSepator?.backgroundColor = UIColor.init(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
        contentView .addSubview(cellSepator!)
        
        commentImageView = UIImageView()
        commentImageView?.image = UIImage(named: "feedComment")
        contentView.addSubview(commentImageView!)
        
        praiseImageView = UIImageView()
        praiseImageView?.image = UIImage(named: "feedPraise")
        contentView.addSubview(praiseImageView!)

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutUI()
    }
    
    private func layoutUI() {
        let  CELL_SCREEN_WIDTH  = UIScreen.mainScreen().bounds.size.width//屏幕宽度
        cellSepator?.frame = CGRectMake(0, 0, CELL_SCREEN_WIDTH, 5)
        
        if cellType != "0" {
            newsTypeLabel?.frame = CGRectMake(15, contentView.frame.size.height - 24, 30, 21)
            commentImageView?.frame = CGRectMake(CGRectGetMaxX((newsTypeLabel?.frame)!), CGRectGetMinY((newsTypeLabel?.frame)!), 12.5, 11.5)
            
            commentLabel?.frame = CGRectMake(CGRectGetMaxX((commentImageView?.frame)!), CGRectGetMinY((newsTypeLabel?.frame)!), 30, 21)
            
            praiseImageView?.frame = CGRectMake(CGRectGetMaxX((commentLabel?.frame)!) + 3, CGRectGetMinY((newsTypeLabel?.frame)!), 13, 11.5)
            
            praiseLabel?.frame = CGRectMake(CGRectGetMaxX((praiseImageView?.frame)!), CGRectGetMinY((newsTypeLabel?.frame)!), 30, 21)
           
        }
        if cellType == "1" {
            newsTitleLabel?.frame = CGRectMake(15, 20, CELL_SCREEN_WIDTH / 2 - 40, 80)
            newsImageView?.frame = CGRectMake(CGRectGetMaxX((newsTitleLabel?.frame)!) + 25, 5, CELL_SCREEN_WIDTH / 2, 125)
        }
        if cellType != "1" {
            newsImageView?.frame = CGRectMake(0, 5, SCREEN_WIDTH, 220)
            newsTitleLabel?.frame = CGRectMake(20, 230, SCREEN_WIDTH - 40, 60)
            subheadLabel?.frame = CGRectMake(20, 290, SCREEN_WIDTH - 40, 40)
            
            newsTypeLabel?.frame = CGRectMake(15, CGRectGetMaxY((subheadLabel?.frame)!) + 5, 30, 21)
            commentImageView?.frame = CGRectMake(CGRectGetMaxX((newsTypeLabel?.frame)!), CGRectGetMinY((newsTypeLabel?.frame)!), 12.5, 11.5)
            
            commentLabel?.frame = CGRectMake(CGRectGetMaxX((commentImageView?.frame)!), CGRectGetMinY((newsTypeLabel?.frame)!), 30, 21)
            
            praiseImageView?.frame = CGRectMake(CGRectGetMaxX((commentLabel?.frame)!) + 3, CGRectGetMinY((newsTypeLabel?.frame)!), 13, 11.5)
            
            praiseLabel?.frame = CGRectMake(CGRectGetMaxX((praiseImageView?.frame)!), CGRectGetMinY((newsTypeLabel?.frame)!), 30, 21)
        }
    }
    
    // MARK: -外部属性和方法
    var cellType:String?
    
    var feedModel:FeedsModel? {
        didSet {
            print("type == \(feedModel?.type)")
            cellType = feedModel?.type
            
            newsTypeLabel?.text = feedModel?.post?.category?.title
            commentLabel?.text = feedModel?.post?.comment_count
            praiseLabel?.text = feedModel?.post?.praise_count
            newsTitleLabel?.text = feedModel?.post?.title
            subheadLabel?.text = feedModel?.post?.subhead
            if let nameStr = feedModel?.post?.image {
                let url = NSURL(string: nameStr)
                let manager = SDWebImageManager.sharedManager()
                newsImageView?.sd_setImageWithURL(url, placeholderImage: UIImage(named: "feedback_placeholder"), options: SDWebImageOptions.RefreshCached, completed: { (image, error, cachType, url) -> Void in
                    if manager.diskImageExistsForURL(url)  {// 缓存中有 不再加载
                        return
                    } else {
                        self.newsImageView?.alpha = 0.0
                        UIView.transitionWithView(self.newsImageView!, duration: 0.5, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () -> Void in
                            self.newsImageView?.alpha = 1.0
                            }, completion: nil)
                    }
                })
            }

        }
    }
    
    func caculateCellHeight() -> CGFloat {
        
        return 10.0
    }
}
