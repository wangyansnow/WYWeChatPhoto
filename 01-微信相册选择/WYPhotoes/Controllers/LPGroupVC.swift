//
//  LPGroupVC.swift
//  01-微信相册选择
//
//  Created by 王俨 on 2017/8/29.
//  Copyright © 2017年 https://github.com/wangyansnow. All rights reserved.
//

import UIKit
import Photos

class LPGroupVC: UIViewController {

    var groups = [PHAssetCollection]()
    fileprivate lazy var fetchOption: PHFetchOptions = {
        let fetchOption = PHFetchOptions()
        fetchOption.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        return fetchOption
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }

    private func setupUI() {
        setupNavBar()
        getPhotoGroup()
        pushMyPhotoStream()
    }
    
    private func pushMyPhotoStream() {
        let photoSelectVC = LPPhotoSelectVC()
        photoSelectVC.assets = PHAsset.fetchAssets(in: groups.last!, options: nil)
        photoSelectVC.title = groups.last?.localizedTitle
        navigationController?.pushViewController(photoSelectVC, animated: false)
    }
    
    private func setupNavBar() {
        title = "Photos"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancelItemClick))
    }
    
    @objc private func cancelItemClick() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
}

extension LPGroupVC {
    
    fileprivate func getPhotoGroup() {
        
        // 1.相机胶卷
        let cameraRoll = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)
        cameraRoll.enumerateObjects({ (assetCollection, _, _) in
             let assets = PHAsset.fetchAssets(in: assetCollection, options: nil)
            self.groups.append(assetCollection)
            print("name = \(assetCollection.localizedLocationNames), count = \(assets.count), title = \(assetCollection.localizedTitle ?? "没有名称"), type = \(assetCollection.assetCollectionSubtype)")
        })
        
        // 2.其他所有相簿
        let screenshots = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: nil)
        screenshots.enumerateObjects({ (assetCollection, _, _) in
            
            if assetCollection.localizedTitle == "VideoShow" || assetCollection.estimatedAssetCount == 0 {
                print("视频不要")
                return
            }
            self.groups.append(assetCollection)
            print("name = \(assetCollection.localizedLocationNames), count = \(assetCollection.estimatedAssetCount), title = \(assetCollection.localizedTitle ?? "没有名称"), type = \(assetCollection.assetCollectionSubtype)")
        })
        
        // 3.我的照片流
        let myPhotoStream = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumMyPhotoStream, options: nil)
        myPhotoStream.enumerateObjects({ (assetCollection, _, _) in
            
            self.groups.append(assetCollection)
            print("name = \(assetCollection.localizedLocationNames), count = \(assetCollection.estimatedAssetCount), title = \(assetCollection.localizedTitle ?? "没有名称"), type = \(assetCollection.assetCollectionSubtype)")
        })
    }
}


