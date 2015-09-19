//
//  XYPlayer.h
//  Tab
//
//  Created by zouxue on 15/9/5.
//  Copyright (c) 2015年 xiyou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface XYPlayer : UIView
@property(nonatomic,strong)NSString* videoURL;
-(instancetype)initWithFrame:(CGRect)frame andVideoURL:(NSString*)urlString;
-(void)replacePlayerItemWithVideoURLString:(NSString*)otherVideoURLString;
-(void)play;
-(void)pause;
@end

