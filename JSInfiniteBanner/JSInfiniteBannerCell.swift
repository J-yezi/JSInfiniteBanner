//
//  JSInfiniteBannberCell.swift
//  JSInfiniteBannber
//
//  Created by jesse on 2017/6/14.
//  Copyright © 2017年 jesse. All rights reserved.
//

import UIKit
import YYWebImage

class JSInfiniteBannerCell: UICollectionViewCell {
    
    var url: String? {
        didSet {
            if url != nil {
                imageView.yy_setImage(with: URL(string: url!), options: .showNetworkActivity)
            }
        }
    }
    lazy var imageView: YYAnimatedImageView = {
        let imageView: YYAnimatedImageView = YYAnimatedImageView(frame: self.bounds)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        uiSet()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension JSInfiniteBannerCell {
    
    func uiSet() {
        addSubview(imageView)
    }
    
}
