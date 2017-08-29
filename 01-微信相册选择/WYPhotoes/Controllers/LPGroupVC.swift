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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }

    private func setupUI() {
        setupNavBar()
        getPhotoGroup()
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
            print("name = \(assetCollection.localizedLocationNames), count = \(assets.count), title = \(assetCollection.localizedTitle ?? "没有名称")")
        })
        
        // 2.其他所有相簿
        let screenshots = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: nil)
        screenshots.enumerateObjects({ (assetCollection, _, _) in
            print("name = \(assetCollection.localizedLocationNames), count = \(assetCollection.estimatedAssetCount), title = \(assetCollection.localizedTitle ?? "没有名称")")
        })
        
        // 3.我的照片流
        let myPhotoStream = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumMyPhotoStream, options: nil)
        myPhotoStream.enumerateObjects({ (assetCollection, _, _) in
            print("name = \(assetCollection.localizedLocationNames), count = \(assetCollection.estimatedAssetCount), title = \(assetCollection.localizedTitle ?? "没有名称")")
        })
    }
    
    fileprivate func learnAlumb() {
        
        // 3.获取所有资源集合，并按资源的创建时间排序
        //        let allPhotoOptions = PHFetchOptions()
        //        allPhotoOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        //        let allPhotoes = PHAsset.fetchAssets(with: allPhotoOptions)
    }
}


