//
//  XYHelper.h
//  Tab
//
//  Created by zouxue on 15/9/11.
//  Copyright (c) 2015年 xiyou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYHelper : NSObject
+(XYHelper*)shareHelper;
-(void)showTips:(NSString*)message;
-(void)startWaitAnimation;
-(void)stopWaitAnimation;
-(NSString*)portritURLStringWithUserID:(NSString*)userID andPicName:(NSString*)picName;
-(NSString*)contentImageURLStringWithPicName:(NSString*)picName;
@end
