//
//  MMMainTabBarController.swift
//  myApp
//
//  Created by wangzhi on 2017/6/29.
//  Copyright © 2017年 wangzhi. All rights reserved.
//

import Foundation
import UIKit



class MMMainTabBarController:UITabBarController{
    var homeVC:MMHotRoomVC?
    var anchorVC:MMAnchorViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTabContent()
    }
    
    func setupTabContent(){
        let tabBarItems = self.setupTabBarItems(["tab首页","tab关注","tab无消息未选中","tab我的"],
                                                ["tab首页－按下","tab关注按下","tab消息模块选中","tab我的－按下"])
        
        
        var viewcontrollers = Array<UIViewController>()
        homeVC = MMHotRoomVC()
        anchorVC = MMAnchorViewController()
        viewcontrollers.append(self.setNavController("首页",homeVC!,tabBarItems[0]))
        viewcontrollers.append(self.setNavController("关注", anchorVC!, tabBarItems[1]))
        self.viewControllers = viewcontrollers
       
    }
    
    
    func setupTabBarItems(_ normalImages:Array<String> , _ selectImages:Array<String>)->Array<UITabBarItem>{
        var arr = Array<UITabBarItem>()
        for index in 0..<normalImages.count {
            let norImage = UIImage.init(named:normalImages[index])
            let selImage = UIImage.init(named:selectImages[index])
            let barItem = UITabBarItem.init(title:"", image: norImage, selectedImage:selImage)
            arr.append(barItem)
        }
        return arr
    }
    
    func setNavController(_ title:String,_ vc:UIViewController, _ tabBarItem:UITabBarItem) -> UINavigationController {
        vc.tabBarItem!=tabBarItem
        vc.tabBarItem!.title = title
        return UINavigationController.init(rootViewController: vc)
    }
    
    /*
     - (void)setupTabContent
     {
     NSMutableArray *tabBarItems = [self setupTabBarItems:
     @[@"tab首页",@"tab关注",@"tab无消息未选中",@"tab我的"]
     selectImages:
     @[@"tab首页－按下",@"tab关注按下",@"tab消息模块选中",@"tab我的－按下"]];
     
     self.homeController = [[MMHomeViewController alloc] init];
     self.homeController.tabBarItem = tabBarItems[kTabHomeTag];
     self.homeController.tabBarItem.title = @"首页";
     NavigationController *showNavController = [[NavigationController alloc] initWithRootViewController:self.homeController];
     
     
     
     self.anchorVc = [[MMAnchorViewController alloc] init];
     self.anchorVc.tabBarItem = tabBarItems[kTabFriendTag];
     self.anchorVc.tabBarItem.title = @"关注";
     NavigationController *followedNacController = [[NavigationController alloc] initWithRootViewController:self.anchorVc];
     [followedNacController.navigationBar setBarTintColor:kWhiteColor];
     
     self.mm_newMessageVc = [[MM_NewMessageViewController alloc] init];
     self.mm_newMessageVc.tabBarItem = tabBarItems[kTabMessageTag];
     self.mm_newMessageVc.tabBarItem.title = @"消息";
     NavigationController *messageNavi = [[NavigationController alloc] initWithRootViewController:self.mm_newMessageVc];
     
     self.myinfo = [[MyInfoViewController alloc] init];
     self.myinfo.tabBarItem = tabBarItems[kTabMineTag];
     self.myinfo.tabBarItem.title = @"账号";
     
     NavigationController *myInfoNavController = [[NavigationController alloc] initWithRootViewController:self.myinfo];
     [self.myinfo.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -2)];
     [self.anchorVc.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -2)];
     [self.mm_newMessageVc.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -2)];
     [self.homeController.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -2)];
     
     [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:kRGB(154, 158, 168), NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
     [[UITabBarItem appearance] setTitleTextAttributes:                                                         [NSDictionary dictionaryWithObjectsAndKeys:kRGB(154, 158, 168),NSForegroundColorAttributeName, nil]forState:UIControlStateSelected];
     
     self.delegate = self;
     self.viewControllers = @[showNavController,followedNacController, messageNavi,myInfoNavController];
     }*/
    

    
}
