//
//  LPImagePickerController.swift
//  01-微信相册选择
//
//  Created by 王俨 on 2017/8/29.
//  Copyright © 2017年 https://github.com/wangyansnow. All rights reserved.
//

import UIKit

class LPImagePickerController: UINavigationController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupUI() {
        view.backgroundColor = .white
        navigationBar.barTintColor = UIColor(white: 0, alpha: 0.7)
        navigationBar.tintColor = .white
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        setViewControllers([LPGroupVC()], animated: false)
        navigationBar.isTranslucent = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    

}
