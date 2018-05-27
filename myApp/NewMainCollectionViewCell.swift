//
//  NewMainCollectionViewCell.swift
//  myApp
//
//  Created by wangzhi on 2017/6/29.
//  Copyright © 2017年 wangzhi. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class NewMainCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var roomPic: UIImageView!
    @IBOutlet weak var anchorName: UILabel!
    @IBOutlet weak var anchorDescribe: UILabel!
    @IBOutlet weak var anchorIdentity: UILabel!
    @IBOutlet weak var labelBgView: UIImageView!
    @IBOutlet weak var topRecommendIdentity: UIImageView!
    @IBOutlet weak var audienceNumber: UILabel!
    @IBOutlet weak var hintView: UIView!
    
    
    
    var room:TTRoomModel?{
        didSet{
            self.anchorIdentity.isHidden = false
            self.topRecommendIdentity.isHidden = true
            
            self.anchorDescribe.text = room!.title ?? "正在直播"
            self.anchorName.text = room!.nick_name //TODO:Html解析转换
            
            let picUrl = room!.roomPicUrl ?? "" //如果确定的话
            
            if (picUrl.isEmpty){
                print(room)
            }
            
            self.roomPic.kf.setImage(with: URL(string:picUrl)) //url中文编码
            
            if (room!.filterType != MMRoomFilterType.kRoomNone){
                var desc = "";
                
                if(room!.filterType == MMRoomFilterType.kFifteenDays){
                    /*
                     NSDate *playDate = [NSDate dateWithTimeIntervalSince1970:room.found_time/1000];
                     NSDate *date = [NSDate date];
                     NSTimeInterval timeInterval = [date timeIntervalSinceDate:playDate];
                     NSInteger day = timeInterval/3600/24;
                     desc  =[NSString stringWithFormat:@"%tu天前入驻",day];*/
                    
                }
                    
                else if (room!.filterType == MMRoomFilterType.kHour){
                    /*
                     NSDate *playDate = [NSDate dateWithTimeIntervalSince1970:room.timestamp/1000];
                     NSDate *date = [NSDate date];
                     NSTimeInterval timeInterval = [date timeIntervalSinceDate:playDate];
                     NSInteger minute = timeInterval/60;
                     if(minute>0){
                     desc  =[NSString stringWithFormat:@"%d分钟前开播",(int)timeInterval/60 >= 60 ? 60 : (int)timeInterval/60];
                     }else{
                     desc  =[NSString stringWithFormat:@"%d秒前开播",(int)timeInterval];
                     }*/
                }
                
                self.anchorDescribe.text = desc;
            }
        }
    }
    
    class var nib:UINib{
        get {
            return UINib.init(nibName:"NewMainCollectionViewCell" , bundle: nil)
        }
    }
    
    class var cellIdentifier:String{
        get {
            return "NewMainCollectionViewCell"
        }
    }
    
}

/*
 -(void)setRoom:(TTShowRoom *)room{
 
 
 
 
 
 
 if (room.live)
 {
 long long ningmeng = [DataGlobalKit shamVistorCount:room.visiter_count];
 NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
 formatter.numberStyle = NSNumberFormatterDecimalStyle;
 
 self.audienceNumber.text=[NSString stringWithFormat:@"%@人在看",[formatter stringFromNumber:[NSNumber numberWithLongLong:ningmeng]]];
 if (ningmeng > 9999) {
 self.audienceNumber.text = [NSString stringWithFormat:@"%.2f万人在看",(CGFloat)ningmeng/10000];
 }
 }else
 {
 self.audienceNumber.text = @"休息中...";
 }
 
 long long int timeStamp1 = [DataGlobalKit filterTimeStampWithInteger:room.found_time];
 NSDate *pastDate1 = [NSDate dateWithTimeIntervalSince1970:timeStamp1];
 NSTimeInterval diff1 = [[NSDate date] timeIntervalSinceDate:pastDate1];
 
 NSDictionary *tagConfig = [ [TTShowUIManager sharedInstance] getShowTag:room.tags];
 if (tagConfig!=nil)
 {
 self.anchorIdentity.hidden = NO;
 self.anchorIdentity.text = [tagConfig objectForKey:@"tagName"];
 self.anchorIdentity.backgroundColor = [UIColor colorWithHexString:[tagConfig objectForKey:@"color"]];
 self.anchorIdentity.textColor = kWhiteColor;
 } else if(ABS(diff1) >= kOneWeekSeconds)
 {
 if(room.gift_week != nil)
 {
 self.anchorIdentity.hidden = NO;
 self.anchorIdentity.text = @"周星";
 self.anchorIdentity.backgroundColor = kRGBA(245, 193, 27, 1);
 self.anchorIdentity.textColor = kWhiteColor;
 }
 else
 {
 self.anchorIdentity.hidden = YES;
 }
 }
 else
 {
 self.anchorIdentity.hidden = NO;
 self.anchorIdentity.text = @"新秀";
 self.anchorIdentity.backgroundColor = kRGBA(78, 213, 14, 1);
 self.anchorIdentity.textColor = kWhiteColor;
 }
 
 NSString *levelStr = @"";
 UIColor *color = [GlobalColor recommentColorWithLevel:MMWangYe isMysteryMan:false];
 if (room.recommendUserModel){
 NSInteger level = [[TTShowDataManager sharedInstance] wealthLevel:room.recommendUserModel.coin_spend_total];
 NSString *levelName = [TTShowUIManager userLevelName:level];
 color = [GlobalColor recommentColorWithLevel:level isMysteryMan:(room.sys_recommend == 1)];
 levelStr = [NSString stringWithFormat:@"%@推荐 | ",levelName];
 }
 if (room.is_hidden) {
 levelStr = @"神秘人推荐 | ";
 }
 if (room.sys_recommend == 1){
 levelStr = @"王爷推荐 | ";
 }
 if (!strIsEmpty(levelStr)){
 NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",levelStr, [room.nick_name gtm_stringByUnescapingFromHTML]]];
 [str addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, levelStr.length)];
 [str addAttribute:NSForegroundColorAttributeName value:kRGBA(38, 38, 38, 0.8) range:NSMakeRange(levelStr.length, str.length-levelStr.length)];
 self.anchorName.attributedText = str;
 }
 }*/
