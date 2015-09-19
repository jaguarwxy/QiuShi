//
//  XYframe.h
//  Tab
//
//  Created by zouxue on 15/7/29.
//  Copyright (c) 2015年 xiyou. All rights reserved.
//
typedef enum : NSUInteger {
    XYNavigationStateNomal,
    XYNavigationStatePop,
} XYNavigationState;
@class UITabBarController;
@interface XYframe : NSObject
{
   // UITabBarController* _mTabBar;
    //NSMutableDictionary* _mPageManager;
}
-(UITabBarController*)getMainTabBar;
-(void)gotoPage:(NSString*)dest andData:(NSMutableDictionary*)data;
+(void)netWorkTest;
-(UIView*)viewWithNodeId:(NSString*)node;
-(void)setCurrentNaviLeftItem:(UIBarButtonItem*)leftItem;
-(void)setCurrentNaviRightItem:(UIBarButtonItem *)leftItem;
-(void)setDefultNaviLeftItem;
-(void)setNaviTitleView:(UIView*)titleView;
-(void)setNaviTitle:(NSString*)title;
-(void)closeOtherNavigation;
@end
