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

    var dataSource: [LPGroupModel]?
    let LPGroupCellId = "LPGroupCell"
    weak var tableView: UITableView!
    
    deinit {
        print("LPGroupVC")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }

    private func setupUI() {
        dataSource = LPGroupModel.getPhotoGroups()
        setupNavBar()
        pushMyPhotoStream()
        prepareTableView()
        
    }
    
    private func prepareTableView() {
        let tableV = UITableView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height - 64), style: .plain)
        tableView = tableV
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 60
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: LPGroupCellId, bundle: nil), forCellReuseIdentifier: LPGroupCellId)
        
        view.addSubview(tableV)
    }
    
    private func pushMyPhotoStream() {
        guard let firstGroup = dataSource?.first else {
            return
        }
    
        push(group: firstGroup, animate: false)
    }
    
    private func setupNavBar() {
        title = "Photos"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelItemClick))
    }
    
    @objc private func cancelItemClick() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func push(group: LPGroupModel, animate: Bool) {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let photoSelectVC = LPPhotoSelectVC()
        photoSelectVC.assets = PHAsset.fetchAssets(in: group.assetCollection, options: fetchOptions)
        photoSelectVC.title = group.name
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.pushViewController(photoSelectVC, animated: animate)
    }    
}

extension LPGroupVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LPGroupCellId) as! LPGroupCell
        cell.group = dataSource![indexPath.item]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let group = dataSource![indexPath.item]
        push(group: group, animate: true)
    }
}



