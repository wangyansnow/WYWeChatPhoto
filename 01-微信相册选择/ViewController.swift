//
//  ViewController.swift
//  01-微信相册选择
//
//  Created by 王俨 on 2017/8/29.
//  Copyright © 2017年 https://github.com/wangyansnow. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .orange
        
        
    }

    @IBAction func selectPhotoBtnClick(_ sender: UIButton) {
        present(LPImagePickerController(delegate: self), animated: true, completion: nil)
    }

}

extension ViewController: LPImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: LPImagePickerController) {
//        print("imagePickerControllerDidCancel")
    }
    
    func imagePickerController(_ picker: LPImagePickerController, didFinishPickingMediaWithInfo info: [UIImage]) {
        self.imageView.image = info.last
    }
}

