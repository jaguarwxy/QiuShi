//
//  XYNavigationController.m
//  Tab
//
//  Created by zouxue on 15/8/14.
//  Copyright (c) 2015年 xiyou. All rights reserved.
//

#import "XYNavigationController.h"
#import "XYViewController.h"
#import "XYframe.h"
#import "XYNodeManager.h"
extern entry* myApp;
@implementation XYNavigationController
-(void)setCurrentNaviLeftItem:(UIBarButtonItem*)leftItem
{
     [( XYViewController*)self.topViewController  setNaviLeftItem:leftItem];
}
-(void)setDefultNaviLeftItem

{
    if ([self.viewControllers count]>1||self.naviId==4) {
    UIImage* image=[UIImage imageNamed:@"back"];
    UIBarButtonItem* defultNaviLeftItem=[[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(defultBack)];
    [( XYViewController*)self.topViewController  setNaviLeftItem:defultNaviLeftItem];
    }
    else
    {
        self.topViewController.navigationItem.leftBarButtonItem=nil;
    }
}
-(void)setCurrentNaviRightItem:(UIBarButtonItem *)rightItem
{
     [( XYViewController*)self.topViewController  setNaviRightItem:rightItem];
}
-(void)setNaviTitleView:(UIView*)titleView
{
     [( XYViewController*)self.topViewController setNaviTitleView:titleView];
}
-(void)setNaviTitle:(NSString*)title
{
    [( XYViewController*)self.topViewController setNaviTitle:title];
}
-(void)defultBack
{
    if ([self.viewControllers count]>1) {
        [self popViewControllerAnimated:YES];
    }
    else if(self.naviId==4)
    {
        closeOtherNavigation();
        
    }
    
}
-(void)jumpPageTo:(NSString *)destPage andData:(NSMutableDictionary *)data
{
    XYViewController* curViewController;
    XYNodeManager* manager=[XYNodeManager shareNodeManager];
    
    if (![manager isPage:[destPage integerValue] inStack:self.naviId]) {
        return ;
    }
    ;
    curViewController=(XYViewController*)self.topViewController;
    //NSInteger destId=[destPage integerValue];
    NSInteger curPageId=curViewController.curPageId;
    pageNode* destNode=[manager pageNodeWithPageIDString:destPage];
    pageNode* currentNode=[manager pageNodeWithPageID:curPageId];
    if (destNode.nodeID==currentNode.nodeID) {
        [curViewController setViewData:data];
        [curViewController viewWillAppear:YES];
        [curViewController viewDidAppear:YES];
    }
    else if (destNode.nodeLevel>currentNode.nodeLevel) {
        XYViewController* newViewController=[[XYViewController alloc]init];
        if ([destPage isEqualToString:@"1020"]) {
            newViewController.hidesBottomBarWhenPushed=YES;
        }
            
                newViewController.naviId=self.naviId;
                newViewController.curPageId=destNode.nodeID;
        [newViewController setViewData:data];
        [self pushViewController:newViewController animated:YES];
    }
   else if (destNode.nodeLevel==currentNode.nodeLevel) {
        [curViewController viewWillDisappear:NO];
        [curViewController viewDidDisappear:NO];
        [curViewController setPageId:destNode.nodeID];
        [curViewController setViewData:data];
        [curViewController viewWillAppear:NO];
        [curViewController viewDidAppear:NO];
    }
    else {
        NSArray*  viewControllerAry=self.viewControllers;
        if ([viewControllerAry count]==1) {
            curViewController=(XYViewController*)self.topViewController;
            [curViewController viewWillDisappear:NO];
            [curViewController viewDidDisappear:NO];
            [curViewController setPageId:destNode.nodeID];
            [curViewController setViewData:data];
            [curViewController viewWillAppear:NO];
            [curViewController viewDidAppear:NO];
            
        }
        else if([viewControllerAry count]>=2)
        {
            for (NSInteger i=[viewControllerAry count]-2; i>=0; i--) {
                XYViewController* viewController=viewControllerAry[i];
                NSInteger pageId=viewController.curPageId;
                pageNode* currentNode=[manager pageNodeWithPageID:pageId];
                pageId%=1000;
                if (currentNode.nodeLevel<destNode.nodeLevel) {
                    XYViewController* upUiewController=viewControllerAry[i+1];
                    if (upUiewController==self.topViewController) {
                        [upUiewController viewWillDisappear:NO];
                        [upUiewController viewDidDisappear:NO];
                        [upUiewController setPageId:destNode.nodeID];
                        [upUiewController setViewData:data];
                        [upUiewController viewWillAppear:NO];
                        [upUiewController viewDidAppear:NO];
                    }
                    else
                    {
                        [upUiewController setPageId:destNode.nodeID];
                        [upUiewController setViewData:data];
                        [self popToViewController:upUiewController animated:YES];
                    }
                    break;
                }
                if (currentNode.nodeLevel>destNode.nodeLevel&&i==0) {
                    XYViewController* viewController=viewControllerAry[0];
                    
                    [viewController setPageId:destNode.nodeID];
                    [viewController setViewData:data];
                    [self popToViewController:viewController animated:YES];

                }
                
            }
        }
        
    }
    
   }
@end
