//
//  MMHotRoomVC.swift
//  myApp
//
//  Created by wangzhi on 2017/6/28.
//  Copyright © 2017年 wangzhi. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class MMHotRoomVC: UIViewController {
    var homeResultModel:TTHomeResultModel<TTRoomModel>?
    let collectionview:UICollectionView = {
        let vt = UIGlobalKit.createRoomLayout(.kRoomNone)
        let cv = UICollectionView(frame:.zero, collectionViewLayout: vt)
        cv.backgroundColor = UIColor.white
        cv.register(NewMainCollectionViewCell.nib, forCellWithReuseIdentifier: NewMainCollectionViewCell.cellIdentifier)
        
        return cv
    }()

    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.requestAnchorHotRecommend()
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionview.delegate = self
        collectionview.dataSource = self
        self.view.addSubview(collectionview)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionview.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
    }
    
}


extension MMHotRoomVC : UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let roomList = self .dataSource(section);
        if (section == 0){
            return 0
        } else{
            return self.numberOfSection(roomList.count, 100)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let roomList = self.dataSource(indexPath.section)
        let numberOfRoomList = (roomList.count / 2) * 2
        var room = TTRoomModel.init()
        if (indexPath.item + 1 <= numberOfRoomList) {
            room = roomList[indexPath.item];
        }
        
        let cell:NewMainCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: NewMainCollectionViewCell.cellIdentifier, for: indexPath) as! NewMainCollectionViewCell
        cell.room = room
        return cell
    }
}









extension MMHotRoomVC{
    func requestAnchorHotRecommend(){
        userProvider.request(.anchorHotRecommend) { result in
            switch result {
            case .success(_):
                do {
                    let rp = try result.dematerialize()
                    let value = try rp.mapString()
                    let model = TTResultModel<TTHomeResultModel<TTRoomModel>>.deserialize(from: value)
                    if model?.code == successCode{
                        self.homeResultModel = model?.data
                        self.collectionview.reloadData()
                    } else{
                        //TODO:提示显示
                    }
                } catch{
                    
                }
                
                
                
                break
            // do something with the response data or statusCode
            case let .failure(error):
                
                break
                // this means there was a network failure - either the request
                // wasn't sent (connectivity), or no response was received (server
                // timed out).  If the server responds with a 4xx or 5xx error, that
                // will be sent as a ".success"-ful response.
            }
        }
    }
    
    func numberOfSection(_ count:Int,_ maxNumber:Int) -> Int {
        var number:Int = 0
        if (count >= maxNumber){
            number = maxNumber
        } else{
            let sum:Int = count / 2
            number = sum * 2
        }
        return number
    }
    
    func dataSource(_ section:Int) -> Array<TTRoomModel> { //?? 空合运算符
        if (section == 1){
            return ( homeResultModel?.top_rooms ?? Array.init() ) +  ( homeResultModel?.room_found_latest ?? Array.init() )
        } else if (section == 2){
            return homeResultModel?.app_room_list ?? Array.init()
        } else if (section == 3){
            return homeResultModel?.user_recomm_list ?? Array.init()
        } else if (section == 4){
            return homeResultModel?.new_recomm_list ?? Array.init()
        }
        return Array.init()
    }
    
    
}

