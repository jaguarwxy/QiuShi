//
//  XYUserInforView.m
//  Tab
//
//  Created by zouxue on 15/9/11.
//  Copyright (c) 2015年 xiyou. All rights reserved.
//
#import "LatestQiuShi.h"
#import "XYQiuShiTemplateView.h"
@interface LatestQiuShi()
@property(nonatomic,strong)XYQiuShiTemplateView* qiuShiView;
@end
@implementation LatestQiuShi

-(void)loadXibFinish
{
    CGRect frame=self.bounds;
    frame.size.height-=140;
    _qiuShiView=[[XYQiuShiTemplateView alloc] initWithFrame:frame];
    _qiuShiView.theURLString=@"latest";
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
