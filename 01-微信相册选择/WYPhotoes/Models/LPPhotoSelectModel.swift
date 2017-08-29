//
//  LPPhotoSelectModel.swift
//  01-微信相册选择
//
//  Created by 王俨 on 2017/8/29.
//  Copyright © 2017年 https://github.com/wangyansnow. All rights reserved.
//

import UIKit
import Photos

class LPPhotoSelectModel: NSObject {
    var asset: PHAsset? {
        didSet {
            let options = PHImageRequestOptions()
            options.isSynchronous = true
            PHImageManager.default().requestImage(for: asset!, targetSize: thumbSize, contentMode: .aspectFit, options: options) { (image, _) in
                self.thumbImage = image
            }
        }
    }
    var isSelected = false
    var thumbImage: UIImage?
    var thumbSize = CGSize.zero
    var isCamera = false
    var isShowCover = false
    
    class func handleAssets(assets: PHFetchResult<PHAsset>, size: CGSize) -> [LPPhotoSelectModel] {
        var models = [LPPhotoSelectModel]()
        let cameraModel = LPPhotoSelectModel()
        cameraModel.isCamera = true
        models.append(cameraModel)
        
        assets.enumerateObjects({ (asset, _, _) in
            let model = LPPhotoSelectModel()
            model.thumbSize = size
            model.asset = asset
            
            models.append(model)
        })
        
        return models
    }
    
}
