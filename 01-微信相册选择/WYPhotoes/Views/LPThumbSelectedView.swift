//
//  LPThumbSelectedView.swift
//  01-微信相册选择
//
//  Created by 王俨 on 2017/8/30.
//  Copyright © 2017年 https://github.com/wangyansnow. All rights reserved.
//

import UIKit

class LPThumbSelectedView: UIView {
    
    var selectedIndexs = [Int]()
    var dataSource = [LPPhotoSelectModel]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    let LPThumbSelectedCellId = "LPThumbSelectedCell"
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 66, height: 66)
        layout.minimumLineSpacing = 3
        layout.minimumInteritemSpacing = 6
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: self.LPThumbSelectedCellId, bundle: nil), forCellWithReuseIdentifier: self.LPThumbSelectedCellId)
        
        self.addSubview(collectionView)
        return collectionView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension LPThumbSelectedView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LPThumbSelectedCellId, for: indexPath) as! LPThumbSelectedCell
        cell.model = dataSource[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
