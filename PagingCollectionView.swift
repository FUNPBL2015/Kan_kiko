//
//  PagingCollectionView.swift
//  DB
//
//  Created by 岩見建汰 on 2015/11/21.
//  Copyright © 2015年 project03A. All rights reserved.
//

import UIKit

class PagingCollectionView: UIView {
    
    let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var label = UILabel()
    
    // MARK: - Properties
    internal let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
    internal var contentSize: CGSize {
        return CGSizeMake(CGRectGetWidth(UIScreen.mainScreen().bounds) - 0, CGRectGetHeight(UIScreen.mainScreen().bounds) - 0)
    }
    
    // MARK: - Init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initView()
    }
    
    private func initView() {
        
        self.collectionView.backgroundColor = UIColor(patternImage: UIImage(named: "haikei.png")!)
        self.collectionView.frame = CGRectMake(0.0, 0.0, self.contentSize.width, self.contentSize.height)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.clipsToBounds = false
        self.collectionView.pagingEnabled = true
        self.collectionView.alwaysBounceHorizontal = true
        //        self.collectionView.scrollEnabled = false
        // For Cell
        self.collectionView.registerNib(UINib(nibName: "PagingCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PagingCollectionViewCell")
        
        // Change layout
        let layout = PagingCollectionViewLayout()
        layout.scrollDirection = .Horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        self.collectionView.setCollectionViewLayout(layout, animated: false)
        
        self.addSubview(self.collectionView)
    }
    
    // MARK: - Override Methods
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        if !CGRectContainsPoint(self.collectionView.frame, point) {
            return self.collectionView
        }
        return super.hitTest(point, withEvent: event)
    }
}

// MARK: - UICollectionView DataSource
extension PagingCollectionView: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if(appDelegate.pic_segmented == 0){ //撮影写真を選択している場合
            if(DB().getUpdatedCardIDArray().count == 0){    //撮影写真が0枚の場合
                return 1
            }else{
                return DB().getUpdatedCardIDArray().count   //0枚以外は普通に枚数分
            }
        }else{                              //サンプル写真を選択している場合
            return DB().cardListSize()
        }
        
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if(appDelegate.pic_segmented == 0){   //撮影写真の場合
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PagingCollectionViewCell", forIndexPath: indexPath) as! PagingCollectionViewCell
            
            if(DB().getUpdatedCardIDArray().count == 0){   //撮影写真が0枚の場合
                collectionView.scrollEnabled = false
                let kikoimage = UIImage(named: "kiko.png")
                cell.photo.image = kikoimage
                cell.TitleLabel.text = ""
                cell.introLabel.text = ""
                cell.NoPhotoLabel.text = "撮影写真がありません。\n写真を撮ると表示されます。"
                label.frame = CGRectMake(60, 310, 300, 120)
                label.font = UIFont(name: "HiraginoSans-W3", size: 12.0)
                label.text = "木古内町観光マスコットキャラクターキーコ"
                label.numberOfLines = 1
                
                self.addSubview(label)

                return cell
            }else{
                var UpdateCardIDArray1 = DB().getUpdatedCardIDArray()        //updateがtrueになっているID配列をDBからコピー
                let NSphotodata1 = DB().getCard(UpdateCardIDArray1[indexPath.row]).photo?.photoData   //ID配列でDBからレコード内の写真データ(NSdata)を取得
                cell.photo.image = PhotoController().NSSImage(NSphotodata1!)  //写真データ(NSdata)をimageに変換
                
                let titletext1 = DB().getCard(UpdateCardIDArray1[indexPath.row]).cardText?.title
                let introtext1 = (DB().getCard(UpdateCardIDArray1[indexPath.row]).cardText?.text)!
                
                cell.TitleLabel.text = titletext1
                cell.introLabel.text = introtext1
                cell.NoPhotoLabel.text = ""
                
                return cell
                
            }
        }else{  //サンプル写真の場合
            self.collectionView.scrollEnabled = true
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PagingCollectionViewCell", forIndexPath: indexPath) as! PagingCollectionViewCell
            let cardcounts = DB().cardListSize()
            var IDArray2:[Int] = []
            
            for(var i = 1; i <= cardcounts; i++){
                IDArray2.append(i)
            }
            
            let NSphotodata2 = DB().getDefaultPhoto(IDArray2[indexPath.row]).photoData
            
            cell.photo.image = PhotoController().NSSImage(NSphotodata2!)  //写真データ(NSdata)をimageに変換
            
            let titletext2 = DB().getCard(IDArray2[indexPath.row]).cardText?.title
            let introtext2 = (DB().getCard(IDArray2[indexPath.row]).cardText?.text)!
            
            cell.TitleLabel.text = titletext2
            cell.introLabel.text = introtext2
            cell.NoPhotoLabel.text = ""
            
            return cell
        }
    }
}


// MARK: - UICollectionView Delegate
extension PagingCollectionView: UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return self.contentSize
    }
    
}
