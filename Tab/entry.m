//
//  entry.m
//  Tab
//
//  Created by zouxue on 15/7/29.
//  Copyright (c) 2015年 xiyou. All rights reserved.
//
#import "firstRootController.h"
#import "entry.h"
#import "XYframe.h"
#import "XYNodeManager.h"

@implementation entry
-(instancetype)init
{
    if (self=[super init]) {
        [self initNodeManager];
        
    }
    return self;
}
-(void)begin
{
    self.mframe=[[XYframe alloc]init];
    self.mWindow=[[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    self.mWindow.backgroundColor=[UIColor whiteColor];
    self.mWindow.rootViewController=[self.mframe getMainTabBar];
    [self.mWindow makeKeyAndVisible];
    
}

-(void)initNodeManager
{
    _mManager=[XYNodeManager shareNodeManager];
  
}

@end
