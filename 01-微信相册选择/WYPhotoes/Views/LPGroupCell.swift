//
//  LPGroupCell.swift
//  01-微信相册选择
//
//  Created by 王俨 on 2017/8/30.
//  Copyright © 2017年 https://github.com/wangyansnow. All rights reserved.
//

import UIKit

class LPGroupCell: UITableViewCell {

    var group: LPGroupModel! {
        didSet {
            iconView.image = group.thumbImage
            nameLabel.text = group.name
            countLabel.text = group.countStr
        }
    }
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
}
