//
//  XYVideoQiuShi.m
//  Tab
//
//  Created by zouxue on 15/9/9.
//  Copyright (c) 2015年 xiyou. All rights reserved.
//
#import "XYVideoQiuShi.h"
#import "XYQiuShiTemplateView.h"
@interface XYVideoQiuShi()
{
     BOOL isWaiting;
    
}
//ERROR:     847: AudioQueue: request to trim 2112 + 0 = 2112 frames from buffer containing 2048 frames
@property(nonatomic,strong)XYQiuShiTemplateView* qiuShiView;
@end
@implementation XYVideoQiuShi
-(void)loadXibFinish
{
    CGRect frame=self.bounds;
    frame.size.height-=140;
    _qiuShiView=[[XYQiuShiTemplateView alloc] initWithFrame:frame];
    _qiuShiView.theURLString=@"video";
    [self addSubview:_qiuShiView];
}
-(void)prepareDispaly
{
    [_qiuShiView prepareDispaly];
}
-(void)didDispaly
{
    [_qiuShiView didDispaly];
}
-(void)prepareDismiss
{
    [_qiuShiView prepareDismiss];
}
-(void)didDismiss
{
    [_qiuShiView didDismiss];
}
@end
