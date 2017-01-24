//
//  HomeLabsCell.swift
//  MyQDaily
//
//  Created by 石冬冬 on 17/1/23.
//  Copyright © 2017年 sdd. All rights reserved.
//

import UIKit
import SDWebImage 
class HomeLabsCell: UITableViewCell {

    @IBOutlet weak var newsImageView: UIImageView!
    
    @IBOutlet weak var subHeadTitleLabel: UILabel!
    @IBOutlet weak var newsTitleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


    // MARK: -外部方法
    
    var feedModel:FeedsModel? {
        didSet {
            newsTitleLabel?.text = feedModel?.post?.title
            subHeadTitleLabel?.text = feedModel?.post?.subhead
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
}
