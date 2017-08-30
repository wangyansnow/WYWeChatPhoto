//
//  LPThumbSelectedCell.swift
//  01-微信相册选择
//
//  Created by 王俨 on 2017/8/30.
//  Copyright © 2017年 https://github.com/wangyansnow. All rights reserved.
//

import UIKit

class LPThumbSelectedCell: UICollectionViewCell {
    
    var model: LPPhotoSelectModel! {
        didSet {
            handleModel()
        }
    }
    @IBOutlet weak var iconView: UIImageView!
    
    private func handleModel() {
        iconView.image = model.thumbSelectedImage
    }
    
    func updateSelectUI(isSelected: Bool) {
        if isSelected {
            layer.borderWidth = 2
            layer.borderColor = UIColor(hex: 0x9652ff).cgColor
            return
        }
        
        layer.borderWidth = 0
    }
}
