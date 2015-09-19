//
//  XYTalkView.m
//  Tab
//
//  Created by zouxue on 15/9/9.
//  Copyright (c) 2015年 xiyou. All rights reserved.
//
#import "XYPlayer.h"
#import "XYTalkView.h"
@interface XYTalkView()
@property(nonatomic,strong)XYPlayer* playerView;
@property (strong, nonatomic)  UIImageView *backGroundImage;
@end
@implementation XYTalkView

-(void)loadXibFinish
{
    [self initControl];
}
-(void)prepareDispaly
{
    setCurrentNaviTitle(@"小纸条");
}
-(void)didDispaly
{}
-(void)prepareDismiss
{}
-(void)didDismiss
{}
-(void)initControl
{
    _backGroundImage=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"qiuBaiTalk"]];
    _backGroundImage.frame=CGRectMake(50, 70, 220, 220);
    [self addSubview:_backGroundImage];
    UILabel* tips=[[UILabel alloc] initWithFrame:CGRectMake(50, 290, 220, 20)];
    tips.textAlignment=NSTextAlignmentCenter;
    tips.text=@"糗友聊一聊，给他小纸条";
    [self addSubview:tips];

}
@end
