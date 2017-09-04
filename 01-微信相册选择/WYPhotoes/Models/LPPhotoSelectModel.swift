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
            options.deliveryMode = .fastFormat
            
            var img: UIImage?
            PHImageManager.default().requestImage(for: asset!, targetSize: thumbSize, contentMode: .aspectFit, options: options) { (image, _) in
                img = image
            }
            return img
        }
    }
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
    var thumbSelectedImage: UIImage? {
        get {
            let options = PHImageRequestOptions()
            options.isSynchronous = true
            options.deliveryMode = .fastFormat
            
            var img: UIImage?
            PHImageManager.default().requestImage(for: asset!, targetSize: CGSize(width: 66, height: 66), contentMode: .default, options: options) { (image, _) in
                img = image
            }
            return img
        }
    }
    
    func getBrowserImage(finishedBlock: @escaping ((_ image: UIImage?) -> ())) {
        guard let wyAsset = asset else {
            return
        }
        let w = UIScreen.main.bounds.width
        let h = CGFloat(wyAsset.pixelHeight) * w / CGFloat(wyAsset.pixelWidth)
        let scale = UIScreen.main.scale
        
        let options = PHImageRequestOptions()
        options.deliveryMode = .fastFormat
        PHImageManager.default().requestImage(for: asset!, targetSize: CGSize(width: w * scale, height: h * scale), contentMode: .default, options: nil) { (image, _) in
            finishedBlock(image)
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
    
    class func getOriginImages(models: [LPPhotoSelectModel], finishedBlock: @escaping ((_ images: [UIImage]) -> ())) {
        
        var imgs = [UIImage]()
        for model in models {
            guard let asset = model.asset else {return}
            
            let options = PHImageRequestOptions()
            options.isSynchronous = true
            options.isNetworkAccessAllowed = true
            
            let originW = CGFloat(asset.pixelWidth)
            let originH = CGFloat(asset.pixelHeight)
            let h = 414 * originH / originW

            PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: 414, height: h), contentMode: .default, options: options) { (image, _) in
                
                guard let img = image else {
                    if let thumbImage = model.thumbImage {
                        imgs.append(thumbImage)
                    }
                    return
                }
                imgs.append(img)
            }
        }
        
        finishedBlock(imgs)
    }
    
}
