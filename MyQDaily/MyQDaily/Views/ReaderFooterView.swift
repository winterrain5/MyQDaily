//
//  ReaderFooterView.swift
//  MyQDaily
//
//  Created by 石冬冬 on 17/1/19.
//  Copyright © 2017年 sdd. All rights reserved.
//

import UIKit
import Social

protocol ReaderFooterViewDelegate:NSObjectProtocol
{
    func backbtnClick(_ view:ReaderFooterView)
    
    func shareBtnClick(_ view:ReaderFooterView)
}


class ReaderFooterView: UIView {

    // MARK: -内部属性
    fileprivate var backBtn:UIButton?
    fileprivate var commentBtn:UIButton?
    fileprivate var likeBtn:UIButton?
    fileprivate var shareBtn:UIButton?
    
    
    fileprivate var likeLabel:UILabel?
    fileprivate var commentLabel:UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        let height:CGFloat = 50.0
        let width = SCREEN_WIDTH
        
        backBtn = UIButton()
        backBtn?.frame = CGRect(x: 15, y: 0, width: 40, height: height)
        backBtn?.addTarget(self, action: #selector(ReaderFooterView.backBtnClick), for: UIControlEvents.touchUpInside)
        addSubview(backBtn!)
        
        shareBtn = UIButton()
        shareBtn?.frame = CGRect(x: width - 20 - 40, y: 5, width: 40, height: 40)
        shareBtn?.addTarget(self, action: #selector(ReaderFooterView.shareBtnClick), for: UIControlEvents.touchUpInside)
        addSubview(shareBtn!)
        
    
        likeBtn = UIButton()
        likeBtn?.frame = CGRect(x: (shareBtn?.frame)!.minX - 55, y: 8, width: 35, height: 35)
        addSubview(likeBtn!)
        
        likeLabel = UILabel()
        likeLabel?.frame = CGRect(x: (likeBtn?.frame)!.maxX - 5, y: 8, width: 20, height: 12)
        likeLabel?.font = UIFont.systemFont(ofSize: 10)
        likeLabel?.text = "21"
        addSubview(likeLabel!)
        
        commentBtn = UIButton()
        commentBtn?.frame = CGRect(x: (likeBtn?.frame)!.minX - 55, y: 8, width: 35, height: 35)
        addSubview(commentBtn!)
        
        commentLabel = UILabel()
        commentLabel?.frame = CGRect(x: (commentBtn?.frame)!.maxX - 5, y: 8, width: 20, height: 12)
        commentLabel?.font = UIFont.systemFont(ofSize: 10)
        commentLabel?.text = "21"
        addSubview(commentLabel!)
        
        
    }
    
    // 返回事件
    @objc fileprivate func backBtnClick() {
        if delegate?.responds(to: Selector("backbtnClick:")) != nil {
            delegate?.backbtnClick(self)
        }
    }
    // 分享事件
    @objc fileprivate func shareBtnClick() {
        if delegate?.responds(to: Selector("shareBtnClick:")) != nil {
            delegate?.shareBtnClick(self)
        }
    }
    
    // MARK: -外部方法和属性
    var footerType:NSInteger? {
        didSet {
            if footerType == 1 { // 白色图片
                
                backBtn?.setImage(UIImage(named: "toolbarBack"), for: UIControlState())
                shareBtn?.setImage(UIImage(named: "toolbarShare_night"), for: UIControlState())
                likeBtn?.setImage(UIImage(named: "toolbarLike"), for: UIControlState())
                commentBtn?.setImage(UIImage(named: "toolbarComment"), for: UIControlState())
                likeLabel?.textColor = UIColor.white
                commentLabel?.textColor = UIColor.white
                
            } else { // 黑色图片
                
                backBtn?.setImage(UIImage(named: "toolbarBackBlack"), for: UIControlState())
                shareBtn?.setImage(UIImage(named: "toolbarShareBlack"), for: UIControlState())
                likeBtn?.setImage(UIImage(named: "toolbarLikeBlack"), for: UIControlState())
                commentBtn?.setImage(UIImage(named: "toolbarCommentBlack"), for: UIControlState())
                likeLabel?.textColor = UIColor.black
                commentLabel?.textColor = UIColor.black

            }
        }
    }
    
    weak var delegate:ReaderFooterViewDelegate?
    
}
