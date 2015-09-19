//
//  XYframe.m
//  Tab
//
//  Created by zouxue on 15/7/29.
//  Copyright (c) 2015年 xiyou. All rights reserved.
//
#import "firstRootController.h"
#import "XYViewController.h"
#import "XYframe.h"
#import "XYNodeManager.h"
#import "XYNavigationController.h"
#import "AFNetworkReachabilityManager.h"
#import "XYView.h"
@interface XYframe()
{
    XYNavigationState naviState;
}
@property(nonatomic,strong)UITabBarController* mTabBar;
@property(nonatomic,strong)NSMutableDictionary* mPageManager;
@property(nonatomic,strong)XYNavigationController* popNavigation;
@end
@implementation XYframe
-(instancetype)init
{
    if (self=[super init]) {
        _mPageManager=[[NSMutableDictionary alloc]init];
        _mTabBar=[[UITabBarController alloc]init];
        naviState=XYNavigationStateNomal;
        [self createUI];
    }
    return self;
}
-(XYNavigationController*)currentNavigationController
{
    switch (naviState) {
        case XYNavigationStateNomal:
           return  (XYNavigationController*)[_mTabBar selectedViewController];
            break;
        case XYNavigationStatePop:
            return _popNavigation;
            break;
    }
}
-(void)setCurrentNaviLeftItem:(UIBarButtonItem *)leftItem
{
    XYNavigationController* curNavi=[self currentNavigationController];
    [curNavi setCurrentNaviLeftItem:leftItem];
    
}
-(void)setDefultNaviLeftItem
{
//    UITabBarController  * tabBar=[self getMainTabBar];
//    XYNavigationController* curNavi=(XYNavigationController*)[tabBar selectedViewController];
    XYNavigationController* curNavi=[self currentNavigationController];
    [curNavi setDefultNaviLeftItem];
    
}
-(void)setCurrentNaviRightItem:(UIBarButtonItem *)rightItem
{
    XYNavigationController* curNavi=[self currentNavigationController];
    [curNavi setCurrentNaviRightItem: rightItem];
    
}
-(void)setNaviTitleView:(UIView*)titleView
{
    XYNavigationController* curNavi=[self currentNavigationController];
    [curNavi setNaviTitleView:titleView];

}
-(void)setNaviTitle:(NSString*)title
{
    XYNavigationController* curNavi=[self currentNavigationController];
    [curNavi setNaviTitle:title];

}
-(void)createUI
{
    [XYframe netWorkTest];
    NSMutableArray*  items=[[NSMutableArray alloc]init];
    XYNodeManager*  manager=[XYNodeManager shareNodeManager];
    NSArray*  naviAry=[manager theNaviNodesAry];
    for (int i=0; i<[naviAry count]; i++) {
        naviNode* navNode=naviAry[i];
        XYViewController* viewController=[[XYViewController alloc]init];
        viewController.naviId=navNode.naviID;
        viewController.edgesForExtendedLayout = UIRectEdgeNone;//这个选项能让view的初始点从导航栏下方开始计算，不然会从屏幕最顶端开始计算，
        [viewController setPageId:[navNode.nodesAry[0] integerValue]];
        viewController.tabBarItem.image=[[UIImage imageNamed:[NSString stringWithFormat:@"tab_%d",i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        viewController.tabBarItem.selectedImage=[[UIImage imageNamed:[NSString stringWithFormat:@"tab_%dselected",i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        XYNavigationController* navigation=[[XYNavigationController alloc]initWithRootViewController:viewController];
        navigation.naviId=navNode.naviID;
        [items addObject:navigation];
    }
    _mTabBar.viewControllers=items;
}
-(UIView*)viewWithNodeId:(NSString*)node
{
    id v=[_mPageManager objectForKey:node];
    
    if (v!=nil&& [v isKindOfClass:[XYView class]]) {
        return v;
    }
  id nibV=[self viewWirhNibName:node];
    if ([nibV isKindOfClass:[UIView class]]) {
        [_mPageManager setObject:nibV forKey:node];
        return nibV;
    }
    return nil;
}
-(XYView*)viewWirhNibName:(NSString*)node
{
   NSArray* ary=[[NSBundle mainBundle] loadNibNamed:node owner:nil options:nil];
    id v=ary[0];
    if ([v isKindOfClass:[UIView class]]) {
        if ([v respondsToSelector:@selector(loadXibFinish)]) {
              [v loadXibFinish];
        }
      
        return v;
    }
    return nil;
}
-(void)gotoPage:(NSString*)destPage andData:(NSMutableDictionary*)data
{
    if (destPage) {
        XYNodeManager* manager=[XYNodeManager shareNodeManager];
        NSInteger destNaviID=[manager getNaviIndexWithPageID:destPage];
        if (destNaviID!=-1) {
            if ([self isGotoPopNavi:destPage]) {
                [_popNavigation jumpPageTo:destPage andData:data];
                [self adjustDisplayNaviTo:XYNavigationStatePop];
            }
            else
            {
                XYNavigationController* destNavi=(XYNavigationController*)_mTabBar.viewControllers[destNaviID];
                //navigation先跳转，再切换tabbar
                [destNavi jumpPageTo:destPage andData:data];
                [self adjustDisplayNaviTo:XYNavigationStateNomal];
                          if (destNaviID!=_mTabBar.selectedIndex) {
                    _mTabBar.selectedIndex=destNaviID;
                }
            }
        }
        else
        {
            NSLog(@"未找到相应的navigation");
            
        }
    }
    else
    {
        NSLog(@"fail:dest%@",destPage);
    }
}
-(BOOL)isGotoPopNavi:(NSString*)destPage
{
    if (_popNavigation==nil) {
        [self initPopNavigation];
    }
    XYNodeManager* manager=[XYNodeManager shareNodeManager];
    naviNode* popNavi=[manager.popNaviList firstObject];
    if ([popNavi isPageIdInArray:[destPage integerValue]]) {
        return YES;
    }
    return NO;
}
-(void)initPopNavigation
{
    XYNodeManager* manager=[XYNodeManager shareNodeManager];
    naviNode* popNaviNode=[manager.popNaviList firstObject];
    XYViewController* viewController=[[XYViewController alloc]init];
    viewController.naviId=popNaviNode.naviID;
    viewController.edgesForExtendedLayout = UIRectEdgeNone;//这个选项能让view的初始点从导航栏下方开始计算，不然会从屏幕最顶端开始计算，
    [viewController setPageId:[popNaviNode.nodesAry[0] integerValue]];
    _popNavigation=[[XYNavigationController alloc]initWithRootViewController:viewController];
    _popNavigation.naviId=popNaviNode.naviID;

}
-(void)adjustDisplayNaviTo:(XYNavigationState)state
{
    if (naviState!=state) {
        naviState=state;
        switch (state) {
            case XYNavigationStateNomal:
                [_popNavigation dismissViewControllerAnimated:YES completion:nil];
                break;
                
            case XYNavigationStatePop:
                [_mTabBar presentViewController:_popNavigation animated:YES completion:nil];
                break;
        }
    }
}
-(void)closeOtherNavigation
{
    [self adjustDisplayNaviTo:XYNavigationStateNomal];
}
-(UITabBarController*)getMainTabBar
{
    return _mTabBar;
}
+(void)netWorkTest
{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status){
        NSString* state;
        switch (status) {
            case -1:
                state=[NSString stringWithFormat:@"未知网络"];
                break;
            case 0:
                state=[NSString stringWithFormat:@"无连接"];
                break;
            case 1:
                state=[NSString stringWithFormat:@"3G网络"];
                break;
            case 2:
                state=[NSString stringWithFormat:@"WiFi网络"];
                break;

            default:
                break;
        }
        NSLog(@"%@",state);
    }];
}
@end
