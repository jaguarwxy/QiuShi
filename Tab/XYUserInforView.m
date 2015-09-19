//
//  XYUserInforView.m
//  Tab
//
//  Created by zouxue on 15/9/11.
//  Copyright (c) 2015年 xiyou. All rights reserved.
//
#import "XYNewPlayer.h"
#import "XYPlayer.h"
#import "XYUserInforView.h"
#import "XYQiuShiTemplateView.h"
@interface XYUserInforView()
//@property (weak, nonatomic) IBOutlet XYPlayer *text;
@property(nonatomic,strong)XYQiuShiTemplateView* qiuShiView;
@property(nonatomic,strong)XYPlayer* player;
@property(nonatomic,strong)XYNewPlayer* player2;
@end
@implementation XYUserInforView

-(void)loadXibFinish
{
    _player=[[XYPlayer alloc]initWithFrame:CGRectMake(10,0, 300, 300) andVideoURL:@"http://qiubai-video.qiushibaike.com/MXK4KV4O6DCS1KYW.mp4"];
    [self addSubview:_player];
    _player2=[[XYNewPlayer alloc]initWithFrame:CGRectMake(10,300, 300, 300)];
    _player2.URL=[NSURL URLWithString:@"http://qiubai-video.qiushibaike.com/MXK4KV4O6DCS1KYW.mp4"];
    [self addSubview:_player2];
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
