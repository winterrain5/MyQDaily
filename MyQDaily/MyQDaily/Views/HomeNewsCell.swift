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
    fileprivate var cellSepator:UIView?
    // 新闻图片
    fileprivate var newsImageView:UIImageView?
    // 标题
    fileprivate var newsTitleLabel:UILabel?
    // 子标题
    fileprivate var subheadLabel:UILabel?
    // 评论图片
    fileprivate var commentImageView:UIImageView?
    // 点赞图片
    fileprivate var praiseImageView:UIImageView?
    
    // 新闻类型
    fileprivate var newsTypeLabel:UILabel?
    // 评论数
    fileprivate var commentLabel:UILabel?
    // 点赞数
    fileprivate var praiseLabel:UILabel?
    // 新闻发布时间
    fileprivate var timeLabel:UILabel?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupUI() {
        newsImageView = UIImageView()
        contentView.addSubview(newsImageView!)
        
        newsTitleLabel = UILabel()
        newsTitleLabel?.textColor = UIColor.init(red: 42/255, green: 42/255, blue: 42/255, alpha: 1)
        newsTitleLabel?.font = UIFont(name: "Helvetica-Bold", size: 17.0)
        newsTitleLabel?.numberOfLines = 5
        contentView.addSubview(newsTitleLabel!)
        
        subheadLabel = UILabel()
        subheadLabel?.font = UIFont(name: "Helvetica", size: 15.0)
        subheadLabel?.textColor = UIColor.gray
        subheadLabel?.numberOfLines = 3
        contentView.addSubview(subheadLabel!)
        
        newsTypeLabel = UILabel()
        newsTypeLabel?.font = UIFont.systemFont(ofSize: 12.0)
        newsTypeLabel?.textColor = UIColor.gray
        contentView .addSubview(newsTypeLabel!)
        
        commentLabel = UILabel()
        commentLabel?.textAlignment = NSTextAlignment.center
        commentLabel?.font = UIFont.systemFont(ofSize: 13.0)
        commentLabel?.textColor = UIColor.gray
        contentView .addSubview(commentLabel!)
        
        praiseLabel = UILabel()
        praiseLabel?.textAlignment = NSTextAlignment.center
        praiseLabel?.font = UIFont.systemFont(ofSize: 13.0)
        praiseLabel?.textColor = UIColor.gray
        contentView .addSubview(praiseLabel!)
        
        timeLabel = UILabel()
        timeLabel?.textAlignment = NSTextAlignment.center
        timeLabel?.font = UIFont.systemFont(ofSize: 13.0)
        timeLabel?.textColor = UIColor.gray
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
    
    fileprivate func layoutUI() {
        let  CELL_SCREEN_WIDTH  = UIScreen.main.bounds.size.width//屏幕宽度
        cellSepator?.frame = CGRect(x: 0, y: 0, width: CELL_SCREEN_WIDTH, height: 5)
        
        if cellType != "0" {
            newsTypeLabel?.frame = CGRect(x: 15, y: contentView.frame.size.height - 24, width: 30, height: 21)
            commentImageView?.frame = CGRect(x: (newsTypeLabel?.frame)!.maxX, y: (newsTypeLabel?.frame)!.minY, width: 12.5, height: 11.5)
            
            commentLabel?.frame = CGRect(x: (commentImageView?.frame)!.maxX, y: (newsTypeLabel?.frame)!.minY, width: 30, height: 21)
            
            praiseImageView?.frame = CGRect(x: (commentLabel?.frame)!.maxX + 3, y: (newsTypeLabel?.frame)!.minY, width: 13, height: 11.5)
            
            praiseLabel?.frame = CGRect(x: (praiseImageView?.frame)!.maxX, y: (newsTypeLabel?.frame)!.minY, width: 30, height: 21)
           
        }
        if cellType == "1" {
            newsTitleLabel?.frame = CGRect(x: 15, y: 20, width: CELL_SCREEN_WIDTH / 2 - 40, height: 80)
            newsImageView?.frame = CGRect(x: (newsTitleLabel?.frame)!.maxX + 25, y: 5, width: CELL_SCREEN_WIDTH / 2, height: 125)
        }
        if cellType != "1" {
            newsImageView?.frame = CGRect(x: 0, y: 5, width: SCREEN_WIDTH, height: 220)
            newsTitleLabel?.frame = CGRect(x: 20, y: 230, width: SCREEN_WIDTH - 40, height: 60)
            subheadLabel?.frame = CGRect(x: 20, y: 290, width: SCREEN_WIDTH - 40, height: 40)
            
            newsTypeLabel?.frame = CGRect(x: 15, y: (subheadLabel?.frame)!.maxY + 5, width: 30, height: 21)
            commentImageView?.frame = CGRect(x: (newsTypeLabel?.frame)!.maxX, y: (newsTypeLabel?.frame)!.minY, width: 12.5, height: 11.5)
            
            commentLabel?.frame = CGRect(x: (commentImageView?.frame)!.maxX, y: (newsTypeLabel?.frame)!.minY, width: 30, height: 21)
            
            praiseImageView?.frame = CGRect(x: (commentLabel?.frame)!.maxX + 3, y: (newsTypeLabel?.frame)!.minY, width: 13, height: 11.5)
            
            praiseLabel?.frame = CGRect(x: (praiseImageView?.frame)!.maxX, y: (newsTypeLabel?.frame)!.minY, width: 30, height: 21)
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
                let url = URL(string: nameStr)
                let manager = SDWebImageManager.shared()
                newsImageView?.sd_setImage(with: url, placeholderImage: UIImage(named: "feedback_placeholder"), options: SDWebImageOptions.refreshCached, completed: { (image, error, cachType, url) -> Void in
                    if (manager?.diskImageExists(for: url))!  {// 缓存中有 不再加载
                        return
                    } else {
                        self.newsImageView?.alpha = 0.0
                        UIView.transition(with: self.newsImageView!, duration: 0.5, options: UIViewAnimationOptions.transitionCrossDissolve, animations: { () -> Void in
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
