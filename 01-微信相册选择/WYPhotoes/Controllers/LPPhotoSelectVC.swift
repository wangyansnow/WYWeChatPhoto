//
//  LPPhotoSelectVC.swift
//  01-微信相册选择
//
//  Created by 王俨 on 2017/8/29.
//  Copyright © 2017年 https://github.com/wangyansnow. All rights reserved.
//

import UIKit
import Photos

class LPPhotoSelectVC: UIViewController {

    var assets: PHFetchResult<PHAsset>! {
        didSet {
            handleAssets()
        }
    }
    
    func handleAssets() {
        DispatchQueue.global().async {
            var models = [LPPhotoSelectModel]()
            let cameraModel = LPPhotoSelectModel()
            cameraModel.isCamera = true
            models.append(cameraModel)
            
            self.assets.enumerateObjects({ (asset, _, _) in
                let model = LPPhotoSelectModel()
                model.thumbSize = self.thumbSize
                model.asset = asset
                models.append(model)
                
                DispatchQueue.main.async {
                    self.dataSource = models
                    self.collectionView.reloadData()
                }
                Thread.sleep(forTimeInterval: 0.01)
            })
        }
    }
    
    var dataSource: [LPPhotoSelectModel]!
    
    private lazy var thumbSize: CGSize = {
        let width = (self.view.bounds.width - 3) * 0.25
        return CGSize(width: width, height: width)
    }()
    var sendBtn: UIButton!
    var selectedIndexs = [Int]()
    let LPPhotoSelectCellId = "LPPhotoSelectCell"
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = self.thumbSize
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height - 46), collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.register(UINib(nibName: self.LPPhotoSelectCellId, bundle: nil), forCellWithReuseIdentifier: self.LPPhotoSelectCellId)
        self.view.addSubview(collectionView)
        
        return collectionView
    }()
    
    deinit {
        print("LPPhotoSelectVC")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        automaticallyAdjustsScrollViewInsets = false
    }
    
    private func setupUI() {
        
        prepareBottomView()
        prepareNavigationBar()
        view.backgroundColor = .white
    }
    
    private func prepareNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelItemClick))
    }
    
    private func prepareBottomView() {
        let bottomView = UIView(frame: CGRect(x: 0, y: view.bounds.height - 46 - 64, width: view.bounds.width, height: 46))
        
        sendBtn = UIButton(frame: CGRect(x: view.bounds.width - 89, y: 8.5, width: 77, height: 28))
        sendBtn.backgroundColor = UIColor(hex: 0xc7c7cc)
        sendBtn.addTarget(self, action: #selector(sendBtnClick), for: .touchUpInside)
        sendBtn.setTitle("Send", for: .normal)
        sendBtn.clipsToBounds = true
        sendBtn.layer.cornerRadius = 14
        sendBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        sendBtn.isEnabled = false
        
        bottomView.addSubview(sendBtn)
        view.addSubview(bottomView)
    }
    
    @objc private func cancelItemClick() {
        navigationController?.dismiss(animated: true, completion: nil)
        
        let nav = navigationController as! LPImagePickerController
        nav.lpdelegate?.imagePickerControllerDidCancel?(nav)
    }
    
    @objc private func sendBtnClick() {
        let nav = navigationController as! LPImagePickerController
        nav.dismiss(animated: true, completion: nil)
        
        var images = [UIImage]()
        for i in selectedIndexs {
            let model = dataSource[i]
            if let image = model.originImage {
                images.append(image)
            }
        }
        
        nav.lpdelegate?.imagePickerController(nav, didFinishPickingMediaWithInfo: images)
    }
    
    func updateUIAfterSelected() {

        var title = "Send"
        if selectedIndexs.count > 0 {
            title = String(format: "Send(%d)", selectedIndexs.count)
            sendBtn.backgroundColor = UIColor(hex:0x9256ff)
        } else {
            sendBtn.backgroundColor = UIColor(hex: 0xc7c7cc)
        }
        sendBtn.setTitle(title, for: .normal)
        
        if selectedIndexs.count == 5 { // 全部置灰
            for model in dataSource {
                model.isShowCover = true
            }
        } else if selectedIndexs.count == 4 && dataSource.last?.isShowCover ?? false { // 取消置灰
            for model in dataSource {
                model.isShowCover = false
            }
        }
        
        sendBtn.isEnabled = selectedIndexs.count > 0
        collectionView.reloadData()
    }
}

extension LPPhotoSelectVC: UICollectionViewDataSource, UICollectionViewDelegate {
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LPPhotoSelectCellId, for: indexPath) as! LPPhotoSelectCell
        let index = indexPath.item
        cell.model = dataSource[index]
        cell.index = index
        cell.delegate = self
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.item != 0 else { // 选择了相机
            openSystemCamera()
            return
        }
        
        let model = dataSource[indexPath.item]
        if model.isShowCover && !model.isSelected {
            return
        }
        
        let browserVC = LPPhotoBrowserVC()
        browserVC.models = dataSource
        browserVC.selectedIndexs = selectedIndexs
        browserVC.currentIndex = indexPath.item
        
        browserVC.backBtnClickBlock = { [unowned self] selectedIndexs in
            self.selectedIndexs = selectedIndexs
            self.updateUIAfterSelected()
        }
        
        navigationController?.pushViewController(browserVC, animated: true)
    }
    
    private func openSystemCamera() {
        let pickerVC = UIImagePickerController()
        pickerVC.delegate = self
        pickerVC.sourceType = .camera
        
        present(pickerVC, animated: true, completion: nil)
    }
}

extension LPPhotoSelectVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        picker.dismiss(animated: false, completion: nil)
        dismiss(animated: true, completion: nil)
        let nav = navigationController as! LPImagePickerController
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            nav.lpdelegate?.imagePickerControllerDidCancel?(nav)
            return
        }
        nav.lpdelegate?.imagePickerController(nav, didFinishPickingMediaWithInfo: [image])
    }
}

extension LPPhotoSelectVC: LPPhotoSelectCellDelegate {
    func photoSelectCellSelected(cell: LPPhotoSelectCell, index: Int, isAdd: Bool) {
        if isAdd {
            selectedIndexs.append(index)
        } else {
            guard let i =  selectedIndexs.index(of: index) else {
                return
            }
            selectedIndexs.remove(at: i)
        }
        
        let model = dataSource[index]
        model.isSelected = isAdd
        
        var title = "Send"
        if selectedIndexs.count > 0 {
            sendBtn.backgroundColor = UIColor(hex:0x9256ff)
            title = String(format: "Send(%d)", selectedIndexs.count)
        } else {
            sendBtn.backgroundColor = UIColor(hex: 0xc7c7cc)
        }
        sendBtn.setTitle(title, for: .normal)
        sendBtn.isEnabled = selectedIndexs.count > 0
        
        if selectedIndexs.count == 5 { // 全部置灰
            for model in dataSource {
                model.isShowCover = true
            }
            collectionView.reloadData()
        } else if selectedIndexs.count == 4 && !isAdd { // 取消置灰
            for model in dataSource {
                model.isShowCover = false
            }
            collectionView.reloadData()
        } else {
            collectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
        }
    }
}
