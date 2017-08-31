//
//  LPBrowserCell.swift
//  01-微信相册选择
//
//  Created by 王俨 on 2017/8/30.
//  Copyright © 2017年 https://github.com/wangyansnow. All rights reserved.
//

import UIKit

class LPBrowserCell: UICollectionViewCell {
    
    @IBOutlet private weak var iconView: UIImageView!
    var model: LPPhotoSelectModel! {
        didSet {
            model.getBrowserImage { [unowned self]  (image) in
                self.setIcon(img: image)
            }
        }
    }
    
    private func setIcon(img: UIImage?) {
        let width = UIScreen.main.bounds.width
        guard let image = img else {
            return
        }
        let h = width / image.size.width * image.size.height
        
        let y = (UIScreen.main.bounds.height - h) * 0.5
        iconView.image = image
        
        iconView.frame = CGRect(x: 0, y: y, width: width, height: h)
    }
}
