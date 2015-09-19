//
//  XYPublicInterface.m
//  Tab
//
//  Created by zouxue on 15/8/16.
//  Copyright (c) 2015年 xiyou. All rights reserved.
//

#import "XYPublicInterface.h"
#import "XYframe.h"

extern  entry* myApp;
@implementation XYPublicInterface
+(XYframe*)getFrame
{
    return myApp.mframe;
}
+(UIWindow*)getRootWindow
{
    return myApp.mWindow;
}
@end
void setDefultNaviLeftItem()
{
    [myApp.mframe setDefultNaviLeftItem];
}
void setCurrentNaviLeftItem(UIBarButtonItem* leftItem)
{
    [myApp.mframe setCurrentNaviLeftItem:leftItem];
}
void setCurrentNaviRightItem(UIBarButtonItem* rightItem)
{
    [myApp.mframe setCurrentNaviRightItem:rightItem];
}

void setCurrentNaviTitleView(UIView* titleView)
{
    [myApp.mframe setNaviTitleView:titleView];
}
void setCurrentNaviTitle(NSString* title)
{
    [myApp.mframe setNaviTitle:title];
}
void gotoPage(NSInteger dest,NSMutableDictionary* data)
{
    XYframe* myframe=myApp.mframe;
    NSString* destPage=[NSString stringWithFormat:@"%lu",(long)dest];
    [myframe gotoPage:destPage andData:data];
}
void gotoPageWithId(NSInteger dest)
{
    gotoPage(dest, nil);
}
void setCurBackItem(UIBarButtonItem* leftItem)
{
    
}
void closeOtherNavigation()
{
    XYframe* myframe=myApp.mframe;
    [myframe closeOtherNavigation];
}