//
//  LPPhotoSelectCell.swift
//  01-微信相册选择
//
//  Created by 王俨 on 2017/8/29.
//  Copyright © 2017年 https://github.com/wangyansnow. All rights reserved.
//

import UIKit
import Photos

protocol LPPhotoSelectCellDelegate: class {
    func  photoSelectCellSelected(cell: LPPhotoSelectCell, index: Int, isAdd: Bool)
}

class LPPhotoSelectCell: UICollectionViewCell {

    weak var delegate: LPPhotoSelectCellDelegate?
    var index: Int = 0
    var model: LPPhotoSelectModel? {
        didSet {
            if model?.isCamera ?? false {
                rightView.isHidden = true
                iconView.image = UIImage(named: "image_camera")
                coverView.isHidden = true
                cameraView.isHidden = false
                return
            }
            
            cameraView.isHidden = true
            rightView.isHidden = false
            
            let scale = UIScreen.main.scale
            let w = iconView.bounds.width
            let size = CGSize(width: w * scale, height: w * scale)
            
            PHImageManager.default().requestImage(for: (model?.asset!)!, targetSize: size, contentMode: .aspectFit, options: nil) { (image, info) in
                print("info = \(String(describing: info))")
                self.iconView.image = image
            }
            
            if model?.isSelected ?? false {
                selectedBtn.isSelected = true
                coverView.isHidden = true
            } else {
                selectedBtn.isSelected = false
                coverView.isHidden = !(model?.isShowCover ?? false)
            }
        }
    }
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var selectedBtn: UIButton!
    @IBOutlet weak var coverView: UIView!
    @IBOutlet weak var cameraView: UIView!
    
    @IBAction func selectedBtnClick(_ sender: UIButton) {
        if !selectedBtn.isSelected {
            if let photoSelectVC = delegate as? LPPhotoSelectVC {
                if photoSelectVC.selectedIndexs.count > 4 {
                    
                    UIAlertView(title: "Select a maximum of 5 photos", message: nil, delegate: nil, cancelButtonTitle: "I Know it").show()
                    return;
                }
            }
        }
        
        selectedBtn.isSelected = !selectedBtn.isSelected
        delegate?.photoSelectCellSelected(cell: self, index: index, isAdd: selectedBtn.isSelected)
    }
}
