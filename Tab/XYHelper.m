//
//  XYHelper.m
//  Tab
//
//  Created by zouxue on 15/9/11.
//  Copyright (c) 2015年 xiyou. All rights reserved.
//

#import "XYHelper.h"
@interface XYHelper()
@property(nonatomic,strong)UIWindow* rootWindow;
@property(nonatomic,strong)UILabel*  tipLabel;
@property(nonatomic,strong)UIImageView*  waitView;
@end
@implementation XYHelper
+(XYHelper*)shareHelper
{
    static XYHelper* instance=nil;
   static dispatch_once_t  once;
    dispatch_once(&once, ^{
        instance=[[XYHelper alloc]init];
        
    });
    return instance;
}
-(instancetype)init
{
    if (self=[super init]) {
        _tipLabel=[UILabel new];
        _tipLabel.backgroundColor=[UIColor blackColor];
        _waitView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 150)];
    }
    return self;
}
-(void)showTips:(NSString*)message
{
    static BOOL isBusy=NO;
    if (isBusy) {
        return;
    }
    isBusy=YES;
    if (message) {
        if (!_rootWindow) {
            self.rootWindow=[XYPublicInterface getRootWindow];
            [_rootWindow addSubview:_tipLabel];
        }
        [self prepareMessage:message];
        [UIView animateWithDuration:1 animations:^{_tipLabel.transform=CGAffineTransformMakeScale(1.5, 1.5);} completion:^(BOOL finished) {
            
        }];
        [UIView animateWithDuration:1.5 animations:^{_tipLabel.transform=CGAffineTransformMakeScale(1, 1);} completion:^(BOOL finished) {
            _tipLabel.alpha=0;
            _tipLabel.transform=CGAffineTransformIdentity;
            isBusy=NO;
        }];
        
        
    }
}
-(void)startWaitAnimation
{
    if (![self.waitView isAnimating]) {
        if (!_rootWindow) {
            self.rootWindow=[XYPublicInterface getRootWindow];
            [_rootWindow addSubview:_tipLabel];
            [_rootWindow addSubview:_waitView];
        }
        _waitView.center=_rootWindow.center;
        NSMutableArray* array=[NSMutableArray array];
        for (int i=0; i<20; i++) {
            NSString* name=[NSString stringWithFormat:@"loading_shit%d",i];
            [array addObject:[UIImage imageNamed:name]];
        } [self.waitView setAnimationImages:array];
            [self.waitView setAnimationRepeatCount:HUGE_VAL];
            [self.waitView setAnimationDuration:20*0.025];
            [self.waitView startAnimating];
    }
}
-(void)stopWaitAnimation
{
    if ([self.waitView isAnimating]) {
        [self.waitView stopAnimating];
    }
    
}
-(void)prepareMessage:(NSString*)message
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:message];
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor whiteColor]};
    [str addAttributes:attributes range:NSMakeRange(0, str.length)];
    
        CGRect bounding=[message boundingRectWithSize:CGSizeMake(300, 300) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
        bounding.size.width+=20;
        bounding.size.height+=20;
        _tipLabel.frame=bounding;
        _tipLabel.center=_rootWindow.center;
        _tipLabel.attributedText=str;
        _tipLabel.layer.cornerRadius=4;
        _tipLabel.layer.masksToBounds=YES;
        _tipLabel.textAlignment=NSTextAlignmentCenter;
        _tipLabel.hidden=NO;
       _tipLabel.alpha=1;

}
-(NSString*)portritURLStringWithUserID:(NSString*)userID andPicName:(NSString*)picName
{
    if (userID==nil||userID.length<4) {
        return nil;
    }
    if (picName==nil||[picName isEqualToString:@""]) {
        return nil;
    }
    NSString* path1=[userID substringWithRange:NSMakeRange(0, 4)];
    return  userPortritURLString(path1, userID, picName);
}
-(NSString*)contentImageURLStringWithPicName:(NSString*)picName
{
    if (picName==nil||picName.length<5) {
        return nil;
    }
    NSString* path1=[picName substringWithRange:NSMakeRange(3, 5)];
    NSString* temString=[picName  substringFromIndex:3];
    temString=[temString substringToIndex:temString.length-4];
    return contentPicturURLString(path1, temString, picName);
}

@end
