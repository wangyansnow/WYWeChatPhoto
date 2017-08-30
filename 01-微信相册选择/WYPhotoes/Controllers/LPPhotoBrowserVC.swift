//
//  LPPhotoBrowserVC.swift
//  01-微信相册选择
//
//  Created by 王俨 on 2017/8/30.
//  Copyright © 2017年 https://github.com/wangyansnow. All rights reserved.
//

import UIKit

class LPPhotoBrowserVC: UIViewController {
    
    var backBtnClickBlock: ((_ selectedIndexs: [Int])->())?
    let LPBrowserCellId = "LPBrowserCell"
    var selectedIndexs = [Int]()
    var currentIndex = 0
    var dataSource = [LPPhotoSelectModel]()
    var models: [LPPhotoSelectModel]? {
        didSet {
            models?.remove(at: 0)
            guard let m = models else {
                return
            }
            dataSource = m
        }
    }
    
    @IBOutlet weak var rightIcon: UIButton!
    private weak var sendBtn: UIButton!
    weak var collectionView: UICollectionView!
    
    // MARK: - lifecycle
    override func viewWillAppear(_ animated: Bool) {
        navigationController? .setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController? .setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }

    // MARK: - setupUI
    private func setupUI() {
        
        prepareCollectionView()
        prepareNavigationBar()
        prepareBottomSelectView()
        prepareSendView()
        view.backgroundColor = .black
        collectionView.scrollToItem(at: IndexPath(item: currentIndex - 1, section: 0), at: .left, animated: false)
        let model = dataSource[currentIndex - 1]
        rightIcon.isSelected = model.isSelected
    }
    
    private func prepareCollectionView() {
        view.frame = CGRect(x: 0, y: 0, width: view.bounds.width + 20, height: view.bounds.height)
        print("view.bounds = \(view.bounds)")
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = view.bounds.size
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: LPBrowserCellId, bundle: nil), forCellWithReuseIdentifier: LPBrowserCellId)
        collectionView.isPagingEnabled = true
        self.collectionView = collectionView
        view.addSubview(collectionView)
    }
    
    private func prepareNavigationBar() {
        let navView = Bundle.main.loadNibNamed("LPPhotoNavView", owner: self, options: nil)?.first as! UIView
        navView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 64)
        view.addSubview(navView)
        
    }
    
    private func prepareBottomSelectView() {
        
    }
    
    private func prepareSendView() {
        let bottomView = UIView(frame: CGRect(x: 0, y: view.bounds.height - 46, width: view.bounds.width - 20, height: 46))
        
        let sendBtn = UIButton(frame: CGRect(x: view.bounds.width - 109, y: 8.5, width: 77, height: 28))
        sendBtn.backgroundColor = UIColor(hex:0x9256ff)
        sendBtn.addTarget(self, action: #selector(sendBtnClick), for: .touchUpInside)
        sendBtn.clipsToBounds = true
        sendBtn.layer.cornerRadius = 14
        sendBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        self.sendBtn = sendBtn
        handleSendBtn()
        
        bottomView.addSubview(sendBtn)
        view.addSubview(bottomView)
    }
    
    // MARK: - BtnClick
    @objc private func sendBtnClick() {
        let nav = navigationController as! LPImagePickerController
        nav.dismiss(animated: true, completion: nil)
        
        var images = [UIImage]()
        for i in selectedIndexs {
            let model = models?[i - 1]
            if let image = model?.originImage {
                images.append(image)
            }
        }
        
        nav.lpdelegate.imagePickerController(nav, didFinishPickingMediaWithInfo: images)
    }
    
    @IBAction func leftBtnClick() {
        navigationController?.popViewController(animated: true)
        backBtnClickBlock?(selectedIndexs)
    }
    
    @IBAction func rightBtnClick() {
        if rightIcon.isSelected { // 取消选择
            if let i = selectedIndexs.index(of: currentIndex) {
                selectedIndexs.remove(at: i)
            }
            
        } else { // 新增选择
            if selectedIndexs.count > 4 { // 大于最大选择数，给提示
                UIAlertView(title: "Select a maximum of 5 photos", message: nil, delegate: nil, cancelButtonTitle: "I Know it").show()
                return
            }
            
            selectedIndexs.append(currentIndex)
        }
        
        let currentModel = dataSource[currentIndex - 1]
        rightIcon.isSelected = !rightIcon.isSelected
        currentModel.isSelected = rightIcon.isSelected
        collectionView.reloadItems(at: [IndexPath(item: currentIndex - 1, section: 0)])
        handleSendBtn()
    }
    
    private func handleSendBtn() {
        var title = "Send"
        if selectedIndexs.count > 0 {
            title = String(format: "Send(%d)", selectedIndexs.count)
        }
        sendBtn.setTitle(title, for: .normal)
    }
}

extension LPPhotoBrowserVC: UICollectionViewDataSource, UICollectionViewDelegate {
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LPBrowserCellId, for: indexPath) as! LPBrowserCell
        cell.model = dataSource[indexPath.item]
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x / (UIScreen.main.bounds.width + 20)
        currentIndex = Int(x) + 1
        let currentModel = dataSource[currentIndex - 1]
        rightIcon.isSelected = currentModel.isSelected
    }
    
}
