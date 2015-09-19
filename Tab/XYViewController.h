//
//  XYViewController.h
//  Tab
//
//  Created by zouxue on 15/8/14.
//  Copyright (c) 2015年 xiyou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYViewController : UIViewController
@property(nonatomic,assign)NSInteger curPageId;
@property(nonatomic,assign)NSInteger naviId;
@property(nonatomic,strong)NSMutableDictionary* data;
-(void)setPageId:(NSInteger)pageId;
-(void)setViewData:(NSMutableDictionary*)data;
-(void)setNaviLeftItem:(UIBarButtonItem*)leftItem;
-(void)setNaviRightItem:(UIBarButtonItem*)leftItem;
-(void)setNaviTitleView:(UIView*)titleView;
-(void)setNaviTitle:(NSString*)title;
@end
