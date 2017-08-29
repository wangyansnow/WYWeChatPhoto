//
//  ViewController.swift
//  01-微信相册选择
//
//  Created by 王俨 on 2017/8/29.
//  Copyright © 2017年 https://github.com/wangyansnow. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .orange
//        UIImagePickerController
    }

    @IBAction func selectPhotoBtnClick(_ sender: UIButton) {
        present(LPImagePickerController(), animated: true, completion: nil)
    }

}

