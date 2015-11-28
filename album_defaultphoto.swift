//
//  album_defaultphoto.swift
//  DB
//
//  Created by 岩見建汰 on 2015/11/28.
//  Copyright © 2015年 project03A. All rights reserved.
//

import UIKit

class album_defaultphoto: UIViewController {
    
    let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func segmentedchanged(sender: AnyObject) {
        switch sender.selectedSegmentIndex{
        case 0: //撮影写真
            appDelegate.pic_segmented = 0
            self.dismissViewControllerAnimated(false, completion: nil)
        case 1: //サンプル写真
            appDelegate.pic_segmented = 1
        default:
            break
        }
    }
}
