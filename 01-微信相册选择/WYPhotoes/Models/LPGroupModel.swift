//
//  LPGroupModel.swift
//  01-微信相册选择
//
//  Created by 王俨 on 2017/8/30.
//  Copyright © 2017年 https://github.com/wangyansnow. All rights reserved.
//

import UIKit
import Photos

class LPGroupModel: NSObject {
    
    var assetCollection: PHAssetCollection!
    var name = ""
    var countStr = ""
    var thumbImage: UIImage?

    class func getPhotoGroups() -> [LPGroupModel] {
        
        var collections = [PHAssetCollection]()
        
        // 1.相机胶卷
        let cameraRoll = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)
        cameraRoll.enumerateObjects({ (assetCollection, _, _) in
            
            if assetCollection.estimatedAssetCount != 0 {
                collections.append(assetCollection)
            }
        })
        
        // 2.其他所有相簿
        let screenshots = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: nil)
        screenshots.enumerateObjects({ (assetCollection, _, _) in
            
            if assetCollection.localizedTitle == "VideoShow" || assetCollection.estimatedAssetCount == 0 {
                print("视频不要")
                return
            }
            collections.append(assetCollection)
        })
        
        // 3.我的照片流
        let myPhotoStream = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumMyPhotoStream, options: nil)
        myPhotoStream.enumerateObjects({ (assetCollection, _, _) in
            
            if assetCollection.estimatedAssetCount != 0 {
                collections.append(assetCollection)
            }
        })
        
        var groups = [LPGroupModel]()
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        for assetCollection in collections {
            let group = LPGroupModel()
            let assets = PHAsset.fetchAssets(in: assetCollection, options: fetchOptions)
            group.countStr = String(format: "(%d)", assets.count)
            group.name = assetCollection.localizedTitle ?? ""
            group.assetCollection = assetCollection
            groups.append(group)
            
            guard let asset = assets.firstObject else {
                continue
            }
            
            let scale = UIScreen.main.scale
            PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: 60 * scale, height: 60 * scale), contentMode: .aspectFill, options: nil, resultHandler: { (img, _) in
                group.thumbImage = img
            })
        }
        
        return groups
    }
}
