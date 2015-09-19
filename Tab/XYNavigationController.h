//
//  XYNavigationController.h
//  Tab
//
//  Created by zouxue on 15/8/14.
//  Copyright (c) 2015年 xiyou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYNavigationController : UINavigationController
-(void)jumpPageTo:(NSString*)destPage andData:(NSMutableDictionary*)data;
-(void)setCurrentNaviLeftItem:(UIBarButtonItem*)leftItem;
-(void)setCurrentNaviRightItem:(UIBarButtonItem*)rightItem;
-(void)setDefultNaviLeftItem;
-(void)setNaviTitleView:(UIView*)titleView;
-(void)setNaviTitle:(NSString*)title;
@property(nonatomic,assign)NSInteger naviId;
@end
