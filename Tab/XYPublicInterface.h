//
//  XYPublicInterface.h
//  Tab
//
//  Created by zouxue on 15/8/16.
//  Copyright (c) 2015年 xiyou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "entry.h"

@interface XYPublicInterface : NSObject
+(XYframe*)getFrame;
+(UIWindow*)getRootWindow;
@end
void gotoPage(NSInteger dest,NSMutableDictionary* data);
void gotoPageWithId(NSInteger dest);
void setCurrentNaviLeftItem(UIBarButtonItem* leftItem);
void setCurrentNaviRightItem(UIBarButtonItem* rightItem);
void setDefultNaviLeftItem();
void setCurrentNaviTitleView(UIView* titleView);
void setCurrentNaviTitle(NSString* title);
void closeOtherNavigation();
