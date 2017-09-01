//
//  LPThumbSelectedView.swift
//  01-微信相册选择
//
//  Created by 王俨 on 2017/8/30.
//  Copyright © 2017年 https://github.com/wangyansnow. All rights reserved.
//

import UIKit

class LPThumbSelectedView: UIView {
    
    var itemClickBlock: ((_ clickIndex: Int) -> ())?
    var selectedIndexs = [Int]()
    var dataSource = [LPPhotoSelectModel]() {
        didSet {
            collectionView.reloadData()
        }
    }
    weak var selectedCell: LPThumbSelectedCell?
    
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
        collectionView.backgroundColor = .clear
        collectionView.register(UINib(nibName: self.LPThumbSelectedCellId, bundle: nil), forCellWithReuseIdentifier: self.LPThumbSelectedCellId)
        
        self.addSubview(collectionView)
        return collectionView
    }()
    
    deinit {
        print("LPThumbSelectedView")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changeToIndex(index: Int) {
        guard let i = selectedIndexs.index(of: index) else {
            selectedCell?.updateSelectUI(isSelected: false)
            selectedCell = nil
            return
        }
        
        guard let cell = collectionView.cellForItem(at: IndexPath(item: i, section: 0)) as? LPThumbSelectedCell else {
            return
        }
        selectedCell?.updateSelectUI(isSelected: false)
        cell.updateSelectUI(isSelected: true)
        selectedCell = cell
    }

    func addOrDelete(index: Int, isAdd: Bool, model: LPPhotoSelectModel) {
        if isAdd {
            if selectedIndexs.count == 0 { // 从无到有
                UIView.animate(withDuration: 0.25, animations: { 
                    self.alpha = 1.0
                })
            }
            
            selectedIndexs.append(index)
            dataSource.append(model)
            if collectionView.numberOfItems(inSection: 0) == dataSource.count {
                collectionView.reloadData()
            } else {
                collectionView.insertItems(at: [IndexPath(item: dataSource.count - 1, section: 0)])
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                self.changeToIndex(index: index)
            })
            return
        }
        
        guard let i = selectedIndexs.index(of: index) else {
            return
        }
        selectedIndexs.remove(at: i)
        dataSource.remove(at: i)
        selectedCell?.updateSelectUI(isSelected: false)
        selectedCell = nil

        if collectionView.numberOfItems(inSection: 0) == dataSource.count {
            collectionView.reloadData()
        } else {
            collectionView.deleteItems(at: [IndexPath(item: i, section: 0)])
        }
        
        if selectedIndexs.count == 0 {
            UIView.animate(withDuration: 0.25, animations: {
                self.alpha = 0
            })
        }
    }
}

extension LPThumbSelectedView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LPThumbSelectedCellId, for: indexPath) as! LPThumbSelectedCell
        cell.model = dataSource[indexPath.item]
        cell.backgroundColor = .clear
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        itemClickBlock?(selectedIndexs[indexPath.item])
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? LPThumbSelectedCell else {
            return
        }
        cell.updateSelectUI(isSelected: true)
        selectedCell?.updateSelectUI(isSelected: false)
        selectedCell = cell
    }
}
