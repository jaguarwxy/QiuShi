//
//  XYViewController.m
//  Tab
//
//  Created by zouxue on 15/8/14.
//  Copyright (c) 2015年 xiyou. All rights reserved.
//

#import "XYViewController.h"
#import "XYframe.h"
#import "XYPublicInterface.h"
#import "XYView.h"
#import "XYPlayer.h"
@interface XYViewController()
@property(nonatomic,strong)XYView* xyView;
//
@end
@implementation XYViewController
-(void)viewDidLoad
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
}
-(void)viewWillAppear:(BOOL)animated
{
    if (_xyView==nil) {
       XYframe* frame=[XYPublicInterface getFrame];
        NSString* node= [NSString stringWithFormat:@"%ld",(long)_curPageId];
      _xyView=(XYView*)[frame viewWithNodeId:node];
    }
    _xyView.frame=self.view.frame;
    self.view=_xyView;
    _xyView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    if (_data) {
        _xyView.data=_data;
    }
    setDefultNaviLeftItem();
    [self.view prepareDispaly];
}
-(void)setNaviLeftItem:(UIBarButtonItem*)leftItem
{
    if (iOS7) {
        UIBarButtonItem* fixSpaceBtn=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        fixSpaceBtn.width=-20;
        self.navigationItem.leftBarButtonItems=@[fixSpaceBtn,leftItem];
    }
    else
    {
        self.navigationItem.leftBarButtonItem=leftItem;
    }
}
-(void)setNaviRightItem:(UIBarButtonItem*)rightItem
{
    if (iOS7) {
        UIBarButtonItem* fixSpaceBtn=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        fixSpaceBtn.width=-20;
        self.navigationItem.rightBarButtonItems=@[fixSpaceBtn,rightItem];
    }
    else
    {
        self.navigationItem.rightBarButtonItem=rightItem;
    }

}
-(void)setNaviTitleView:(UIView*)titleView
{
    self.navigationItem.titleView=titleView;
}
-(void)setNaviTitle:(NSString*)title
{
    self.navigationItem.title=title;
}
-(void)viewDidAppear:(BOOL)animated
{
    [self.view didDispaly];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self.view prepareDismiss];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [self.view didDismiss];
}
-(void)setViewData:(NSMutableDictionary *)data
{
    _data=data;
}
-(void)setPageId:(NSInteger)pageId
{
    _xyView=nil;
    _curPageId=pageId;
}
@end
