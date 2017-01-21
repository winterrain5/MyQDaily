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
    func backbtnClick(view:ReaderFooterView)
    
    func shareBtnClick(view:ReaderFooterView)
}


class ReaderFooterView: UIView {

    // MARK: -内部属性
    private var backBtn:UIButton?
    private var commentBtn:UIButton?
    private var likeBtn:UIButton?
    private var shareBtn:UIButton?
    
    
    private var likeLabel:UILabel?
    private var commentLabel:UILabel?
    
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
        backBtn?.frame = CGRectMake(15, 0, 40, height)
        backBtn?.addTarget(self, action: Selector("backBtnClick"), forControlEvents: UIControlEvents.TouchUpInside)
        addSubview(backBtn!)
        
        shareBtn = UIButton()
        shareBtn?.frame = CGRectMake(width - 20 - 40, 5, 40, 40)
        shareBtn?.addTarget(self, action: Selector("shareBtnClick"), forControlEvents: UIControlEvents.TouchUpInside)
        addSubview(shareBtn!)
        
    
        likeBtn = UIButton()
        likeBtn?.frame = CGRectMake(CGRectGetMinX((shareBtn?.frame)!) - 55, 8, 35, 35)
        addSubview(likeBtn!)
        
        likeLabel = UILabel()
        likeLabel?.frame = CGRectMake(CGRectGetMaxX((likeBtn?.frame)!) - 5, 8, 20, 12)
        likeLabel?.font = UIFont.systemFontOfSize(10)
        likeLabel?.text = "21"
        addSubview(likeLabel!)
        
        commentBtn = UIButton()
        commentBtn?.frame = CGRectMake(CGRectGetMinX((likeBtn?.frame)!) - 55, 8, 35, 35)
        addSubview(commentBtn!)
        
        commentLabel = UILabel()
        commentLabel?.frame = CGRectMake(CGRectGetMaxX((commentBtn?.frame)!) - 5, 8, 20, 12)
        commentLabel?.font = UIFont.systemFontOfSize(10)
        commentLabel?.text = "21"
        addSubview(commentLabel!)
        
        
    }
    
    // 返回事件
    @objc private func backBtnClick() {
        if delegate?.respondsToSelector(Selector("backbtnClick:")) != nil {
            delegate?.backbtnClick(self)
        }
    }
    // 分享事件
    @objc private func shareBtnClick() {
        if delegate?.respondsToSelector(Selector("shareBtnClick:")) != nil {
            delegate?.shareBtnClick(self)
        }
    }
    
    // MARK: -外部方法和属性
    var footerType:NSInteger? {
        didSet {
            if footerType == 1 { // 白色图片
                
                backBtn?.setImage(UIImage(named: "toolbarBack"), forState: UIControlState.Normal)
                shareBtn?.setImage(UIImage(named: "toolbarShare_night"), forState: UIControlState.Normal)
                likeBtn?.setImage(UIImage(named: "toolbarLike"), forState: UIControlState.Normal)
                commentBtn?.setImage(UIImage(named: "toolbarComment"), forState: UIControlState.Normal)
                likeLabel?.textColor = UIColor.whiteColor()
                commentLabel?.textColor = UIColor.whiteColor()
                
            } else { // 黑色图片
                
                backBtn?.setImage(UIImage(named: "toolbarBackBlack"), forState: UIControlState.Normal)
                shareBtn?.setImage(UIImage(named: "toolbarShareBlack"), forState: UIControlState.Normal)
                likeBtn?.setImage(UIImage(named: "toolbarLikeBlack"), forState: UIControlState.Normal)
                commentBtn?.setImage(UIImage(named: "toolbarCommentBlack"), forState: UIControlState.Normal)
                likeLabel?.textColor = UIColor.blackColor()
                commentLabel?.textColor = UIColor.blackColor()

            }
        }
    }
    
    weak var delegate:ReaderFooterViewDelegate?
}
