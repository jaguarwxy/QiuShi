//
//  entry.h
//  Tab
//
//  Created by zouxue on 15/7/29.
//  Copyright (c) 2015年 xiyou. All rights reserved.
//
//
@class XYframe;
@class XYNodeManager;
@interface entry : NSObject
@property(nonatomic,strong)UIWindow* mWindow;
@property(nonatomic,strong)XYNodeManager* mManager;
@property(nonatomic,strong)XYframe*  mframe;
-(void)begin;
@end


