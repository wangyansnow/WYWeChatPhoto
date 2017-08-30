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
    var asset: PHAsset?
    var isSelected = false
    var thumbSize = CGSize.zero
    var thumbImage: UIImage? {
        get {
            let options = PHImageRequestOptions()
            options.isSynchronous = true
            var img: UIImage?
            PHImageManager.default().requestImage(for: asset!, targetSize: thumbSize, contentMode: .aspectFill, options: options) { (image, _) in
                img = image
            }
            return img
        }
    }
    var browserSize = CGSize.zero
    var isCamera = false
    var isShowCover = false
    var originImage: UIImage? {
        get {
            let options = PHImageRequestOptions()
            options.isSynchronous = true
            
            var img: UIImage?
            PHImageManager.default().requestImage(for: asset!, targetSize: PHImageManagerMaximumSize, contentMode: .default, options: options) { (image, _) in
                img = image
            }
            return img
        }
    }
    var browserImage: UIImage? {
        get {
            let options = PHImageRequestOptions()
            options.isSynchronous = true
            
            var img: UIImage?
            var size = browserSize
            if size.width == 0 {
                size = PHImageManagerMaximumSize
            }
            PHImageManager.default().requestImage(for: asset!, targetSize: size, contentMode: .default, options: options) { (image, _) in
                img = image
            }
            return img
        }
    }
    
    var thumbSelectedImage: UIImage? {
        get {
            let options = PHImageRequestOptions()
            options.isSynchronous = true
            
            var img: UIImage?
            PHImageManager.default().requestImage(for: asset!, targetSize: CGSize(width: 66, height: 66), contentMode: .default, options: options) { (image, _) in
                img = image
            }
            return img
        }
    }
    
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
