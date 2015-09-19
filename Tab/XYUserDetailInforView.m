//
//  XYUserDetailInforView.m
//  Tab
//
//  Created by zouxue on 15/9/12.
//  Copyright (c) 2015年 xiyou. All rights reserved.
//

#import "XYUserDetailInforView.h"
#import "AFHTTPRequestOperationManager.h"
#import "userInforModal.h"
@interface XYUserDetailInforView()
{
    BOOL isWaiting;
}
@property (strong, nonatomic)  UIImageView *portrait;
@property(nonatomic,strong) UserInforModal* modal;
@property(nonatomic,strong)UIButton* hisQiuShiBtn;
@property(nonatomic,strong)UIButton* addFriendBtn;
@property(copy,nonatomic) NSString* userID;
@property(strong,nonatomic)UIView* fullScreenView;

@end
@implementation XYUserDetailInforView
#pragma -mark 框架方法
-(void)loadXibFinish
{
    isWaiting=NO;
    [self initControl];
}
-(void)prepareDispaly
{
    self.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0.4];
}
-(void)didDispaly
{
    [self request];
}
-(void)prepareDismiss
{
    [self stopWaiting];
}
-(void)didDismiss
{}
#pragma -mark 控件和数据刷新
-(void)initControl
{
    _fullScreenView=[[UIView alloc]initWithFrame:self.bounds];
    _fullScreenView.backgroundColor=[UIColor blackColor];
    _fullScreenView.hidden=YES;
    [self addSubview:_fullScreenView];
    
    _portrait=[[UIImageView alloc]initWithFrame:CGRectMake(20, 20, 35, 35)];
    [self addSubview:_portrait];
    _portrait.userInteractionEnabled=YES;
    UITapGestureRecognizer* tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(fullScreen)];
    [_portrait addGestureRecognizer:tapGesture];
    
    _hisQiuShiBtn=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.frame)-70, 20, 70, 40)];
    _hisQiuShiBtn.backgroundColor=[UIColor clearColor];
    [_hisQiuShiBtn addTarget:self action:@selector(gotoHisQiuShi) forControlEvents:UIControlEventTouchUpInside];
    _addFriendBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
    CGPoint center=self.center;
    
    center.y=CGRectGetMaxY(self.bounds)-113;//这是状态栏24 导航44 还有50偏移量
    _addFriendBtn.center=center;
    _addFriendBtn.backgroundColor=[UIColor clearColor];
    [_addFriendBtn addTarget:self action:@selector(addFriendAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_addFriendBtn];
    [self addSubview:_hisQiuShiBtn];
}

-(void)startWaiting
{
    if (!isWaiting) {
        [[XYHelper shareHelper] startWaitAnimation];
        isWaiting=YES;
    }
}
-(void)stopWaiting
{
    if (isWaiting) {
        [[XYHelper shareHelper] stopWaitAnimation];
        isWaiting=NO;
    }
}

-(void)request
{
     [self startWaiting];
        self.userID=[_data objectForKey:@"userID"];
    AFHTTPRequestOperationManager* managers=  [AFHTTPRequestOperationManager manager];
    NSString* str=UserDetailInforURLString(self.userID);
   
    NSURLRequest* request=[NSURLRequest requestWithURL:[NSURL URLWithString:str]];
    AFHTTPRequestOperation* oper=[managers HTTPRequestOperationWithRequest:request success:
                                  ^(AFHTTPRequestOperation *operation, id responseObject)
                                  {
                                      NSDictionary * dic=[[NSDictionary alloc]initWithDictionary:responseObject];
                                      NSLog(@"%@",dic);
                                      [self fillTheData:dic];
                                  } failure:^(AFHTTPRequestOperation *operation, NSError *error)
                                  {
                                      NSLog(@"%@",error);
                                      [self stopWaiting];
                                      //self.tableview.pullTableIsRefreshing = NO;
                                  }];
    
    [oper start];
    

}
-(void)fillTheData:(NSDictionary*)dic
{
    if ([dic[@"err"] integerValue]==0) {
         NSMutableDictionary * userInfor=[dic objectForKey:@"userdata"];
        self.modal=[[UserInforModal alloc]initWithDictionary:userInfor];
        [self fillBaseInfor];
        setCurrentNaviTitle(_modal.login);
    }
    else
    {
        [[XYHelper shareHelper] showTips:dic[@"err_msg"]];
    }
}
-(void)fillBaseInfor
{
     __weak __typeof(self)weakSelf = self;
    NSString* portritURLString=[[XYHelper shareHelper] portritURLStringWithUserID:_userID andPicName:_modal.icon ];
    NSBlockOperation* operation=[NSBlockOperation blockOperationWithBlock:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (portritURLString) {
        NSData * data=[NSData dataWithContentsOfURL:[NSURL URLWithString:portritURLString]];
            strongSelf.modal.portrait=[UIImage imageWithData:data];
            strongSelf.portrait.image=[UIImage imageWithData:data];
            [strongSelf setCirclePortrit];
            [self stopWaiting];
            [self setNeedsDisplay];
        }
        if (strongSelf.modal.big_cover) {
        NSData* backData=[NSData dataWithContentsOfURL:[NSURL URLWithString:strongSelf.modal.big_cover]];
        strongSelf.modal.coverImage=[UIImage imageWithData:backData];
            [self stopWaiting];
            [self setNeedsDisplay];
        }
    }];
//   [operation setCompletionBlock:^{  //这样速度有点慢
    
//       [self stopWaiting];
//       
//   }];
    [operation start];
}
#pragma -mark 事件响应
-(void)addFriendAction
{
    [[XYHelper shareHelper] showTips:NeedLoginTips];
}
-(void)fullScreen
{
    static BOOL isFullScreen=NO;
    
    if (!isFullScreen) {
        _fullScreenView.hidden=NO;
        _portrait.frame=_fullScreenView.bounds;
        _portrait.contentMode=UIViewContentModeScaleAspectFit;
        _portrait.layer.cornerRadius=0;
    }
    else{
        _fullScreenView.hidden=YES;
        [self setCirclePortrit];
    }
    isFullScreen=!isFullScreen;
}
-(void)gotoHisQiuShi
{
    if (self.userID) {
        NSMutableDictionary* dic=[NSMutableDictionary dictionaryWithCapacity:1];
        [dic setObject:self.userID forKey:@"userID"];
        gotoPage(1021, dic);
    }
}
#pragma -mark 画图相关方法 core graphics
-(void)setCirclePortrit
{
    //但是这样会强制离屏渲染，改天用clip处理下
    _portrait.frame=CGRectMake(20, 20, 35, 35);
    if (_portrait.image) {
    [_portrait.layer setCornerRadius:CGRectGetHeight(_portrait.bounds)/2];
    _portrait.layer.masksToBounds=YES;
    _portrait.layer.borderWidth=2;
    _portrait.layer.borderColor=[[UIColor whiteColor] CGColor];
    [self bringSubviewToFront:_portrait];
    }
}
-(NSArray* )stringLocationsInRect:(CGRect)rect andArray:(NSArray*)array
{
    CGFloat baseHeight=rect.size.height-160;
    CGFloat baseWidth1=0;
    CGFloat baseWidth2=0;
   
    NSMutableArray* resultArray=[NSMutableArray new];
    for (int i=0; i<[array count]; i++) {
        NSString* str=[array objectAtIndex:i];
         CGFloat width=[str boundingRectWithSize:CGSizeMake(100, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]} context:nil].size.width;
        if (width==0) {
            width=20;
        }
        if (i<3) {
            baseWidth1+=width;
        }
        else
        {
            baseWidth2+=width;
        }
        [resultArray addObject:@(width)];
    }
    baseWidth1=(rect.size.width-baseWidth1-20*3-10*2)/2;
    baseWidth2=(rect.size.width-baseWidth2-20*2-10*1)/2;
    CGFloat fix1=0;
    CGFloat fix2=0;
    for (int i=0; i<[resultArray count]; i++) {
        if(i<3)
        {
            CGFloat tem=[resultArray[i] floatValue];
            CGRect rec=CGRectMake(baseWidth1+fix1, baseHeight,tem, 20);
            [resultArray replaceObjectAtIndex:i withObject:[NSValue valueWithCGRect:rec]];
            fix1+=tem+30;
        }
        else
        {
            CGFloat tem=[resultArray[i] floatValue];
            CGRect rec=CGRectMake(baseWidth2+fix2, baseHeight+30,tem, 20);
            [resultArray replaceObjectAtIndex:i withObject:[NSValue valueWithCGRect:rec]];
            fix2+=tem+30;
        }
    }
    
    
    return resultArray;
}
-(void)drawQiuShiButton:(CGContextRef)ctx andRect:(CGRect)rect andTransform:(CGAffineTransform)transform
{
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:11],NSForegroundColorAttributeName:[UIColor whiteColor]};
    CGContextSetRGBStrokeColor(ctx, 1, 1, 1, 1);
    CGContextSetLineWidth(ctx, 2);
    CGContextSetRGBFillColor(ctx, 0, 0, 0, 0.5);
    CGMutablePathRef pathBtn=CGPathCreateMutable();
    CGPathAddArc(pathBtn, &transform, CGRectGetMaxX(rect)-60, CGRectGetMinY(rect)+40, 22, -M_PI_2, M_PI_2, 1);
    CGPathAddLineToPoint(pathBtn, &transform, CGRectGetMaxX(rect), CGRectGetMinY(rect)+60);
    CGPathAddLineToPoint(pathBtn, &transform, CGRectGetMaxX(rect), CGRectGetMinY(rect)+18);
    CGPathAddLineToPoint(pathBtn, &transform, CGRectGetMaxX(rect)-60, CGRectGetMinY(rect)+18);
       CGContextAddPath(ctx, pathBtn);
    CGContextDrawPath(ctx, kCGPathFill);
     CGContextSaveGState(ctx);
    CGMutablePathRef pathArrow=CGPathCreateMutable()
    ;
    CGPathMoveToPoint(pathArrow, &transform, CGRectGetMaxX(rect)-15, CGRectGetMinY(rect)+35);
    CGPathAddLineToPoint(pathArrow, &transform, CGRectGetMaxX(rect)-10, CGRectGetMinY(rect)+40);
    CGPathAddLineToPoint(pathArrow, &transform, CGRectGetMaxX(rect)-15, CGRectGetMinY(rect)+45);
    CGContextAddPath(ctx, pathArrow);
    CGContextDrawPath(ctx, kCGPathStroke);
     NSString* qscnt=[NSString stringWithFormat:@"%@",_modal.qs_cnt];
    [qscnt drawAtPoint:CGPointMake(CGRectGetMaxX(rect)-45, CGRectGetMinY(rect)+26) withAttributes:attributes];
    NSString* smilecnt=[NSString stringWithFormat:@"%@",_modal.smile_cnt];
    [smilecnt drawAtPoint:CGPointMake(CGRectGetMaxX(rect)-45, CGRectGetMinY(rect)+43) withAttributes:attributes];
    CGContextSaveGState(ctx);
    CGContextDrawImage(ctx, CGRectMake(CGRectGetMaxX(rect)-65, CGRectGetMinY(rect)+25, 15, 15), [UIImage imageNamed:@"tab_02"].CGImage);
    CGContextDrawImage(ctx, CGRectMake(CGRectGetMaxX(rect)-65, CGRectGetMinY(rect)+42.5, 15, 15), [UIImage imageNamed:@"like02"].CGImage);
    CGContextSaveGState(ctx);
    CGPathRelease(pathArrow);
    CGPathRelease(pathBtn);
}
-(void)drawMidleLabel:(CGContextRef)ctx andRect:(CGRect)rect andTtansform:(CGAffineTransform)transform
{
    NSArray* array=[NSArray arrayWithObjects:_modal.location,_modal.qb_age,_modal.mobile_brand,_modal.job,_modal.hometown, nil];
    NSArray* finalLocation=[self stringLocationsInRect:rect andArray:array];
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor whiteColor]};
    CGContextSetRGBStrokeColor(ctx, 1, 1, 1, 1);
    
    CGContextSetLineWidth(ctx, 1);
    
    for (int i=0; i<[finalLocation count]; i++) {
        NSValue* recValue=[finalLocation objectAtIndex:i] ;
        CGRect rec=[recValue CGRectValue];
        CGMutablePathRef path=CGPathCreateMutable();
        CGPathAddArc(path, &transform, CGRectGetMinX(rec), CGRectGetMidY(rec), 10, -M_PI_2, M_PI_2, 1);
        CGPathAddLineToPoint(path, &transform, CGRectGetMaxX(rec), CGRectGetMaxY(rec));
        CGPathAddArc(path, &transform, CGRectGetMaxX(rec), CGRectGetMidY(rec), 10, M_PI_2, -M_PI_2, 1);
        CGPathAddLineToPoint(path, &transform, CGRectGetMinX(rec), CGRectGetMinY(rec));
        CGContextAddPath(ctx, path);
        NSString* str=[array objectAtIndex:i];
        [str drawAtPoint:CGPointMake(rec.origin.x, rec.origin.y+2.5) withAttributes:attributes];
        CGPathRelease(path);
        
    }
    CGContextDrawPath(ctx, kCGPathStroke);
    CGContextSaveGState(ctx);

}
-(void)drawBottomButton:(CGContextRef)ctx andRect:(CGRect)rect andTransform:(CGAffineTransform)transform
{
    CGFloat padding=(rect.size.width-(40+50+40))/4;
    
    CGMutablePathRef pathDelete=CGPathCreateMutable();
    CGContextSetRGBFillColor(ctx, 1, 1, 1, 0.12);
    CGPathAddArc(pathDelete, &transform, 20+padding   , CGRectGetMaxY(rect)-50, 20, -M_PI, M_PI, 1);
    CGContextDrawImage(ctx, CGRectMake(padding+5,CGRectGetMaxY(rect)-65 , 30, 30), [UIImage imageNamed:@"delete"].CGImage);
    CGContextAddPath(ctx, pathDelete);
    CGContextDrawPath(ctx, kCGPathFill);//左边的举报和图片
    // CGContextSaveGState(ctx);//commentButton1
    
    CGMutablePathRef pathTalk=CGPathCreateMutable();
    CGContextSetRGBFillColor(ctx, 0, 0, 0, 0.4);
    CGPathAddArc(pathTalk, &transform, CGRectGetMaxX(rect)-padding-20   , CGRectGetMaxY(rect)-50, 20, -M_PI, M_PI, 1);
    CGContextAddPath(ctx, pathTalk);
    CGContextDrawPath(ctx, kCGPathFill);
    
    CGContextDrawImage(ctx, CGRectMake(CGRectGetMaxX(rect)-padding-35, CGRectGetMaxY(rect)-65, 30, 30), [UIImage imageNamed:@"commentButton2"].CGImage);//右边的纸条和图片
    
    CGMutablePathRef pathAdd=CGPathCreateMutable();
    CGPathAddArc(pathAdd, &transform, CGRectGetMidX(rect), CGRectGetMaxY(rect)-50, 30, -M_PI, M_PI, 1);
    CGContextSetRGBFillColor(ctx, 255/255, 20/255, 147/255, .7);//玫瑰红，网上查的rgb
    //中间的圆圈
    
    //下面是画十字
    CGPathMoveToPoint(pathAdd, &transform, CGRectGetMidX(rect)-10, CGRectGetMaxY(rect)-50);
    CGPathAddLineToPoint(pathAdd, &transform, CGRectGetMidX(rect)+10, CGRectGetMaxY(rect)-50);
    CGPathMoveToPoint(pathAdd, &transform, CGRectGetMidX(rect), CGRectGetMaxY(rect)-60);
    CGPathAddLineToPoint(pathAdd, &transform, CGRectGetMidX(rect), CGRectGetMaxY(rect)-40);
    CGContextAddPath(ctx, pathAdd);
    CGContextSetRGBStrokeColor(ctx, 1, 1, 1, 1);
    CGContextSetLineCap(ctx, kCGLineCapRound);//设置线条重点形状
    CGContextSetLineWidth(ctx, 2);
    CGContextAddPath(ctx, pathAdd);
    CGContextDrawPath(ctx, kCGPathFillStroke);
    CGContextSaveGState(ctx);
    CGPathRelease(pathAdd);
    CGPathRelease(pathTalk);
    CGPathRelease(pathDelete);
}
-(void)drawBaseInfor:(CGContextRef)ctx andRect:(CGRect)rect andTransform:(CGAffineTransform)transform
{
        CGContextTranslateCTM(ctx, 0, rect.size.height);
    CGContextScaleCTM(ctx, 1, -1);

    if (_modal.coverImage) {
        CGContextDrawImage(ctx, rect, [_modal.coverImage CGImage]);
    }
    if(_modal.portrait)
    {
        //不好画，以后再加
    }
    CGContextSaveGState(ctx);
    CGContextTranslateCTM(ctx, 0, rect.size.height);
    CGContextScaleCTM(ctx, 1, -1);
    NSString* userName=_modal.login;
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor orangeColor]};
    if (userName) {
        [userName drawAtPoint:CGPointMake(60, 20) withAttributes:attributes];
    }
    
     UIBezierPath *agePath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(60.0, 40.0, 20.0, 13) cornerRadius:3];
    if ([_modal.gender isEqualToString:@"M"]) {
        CGContextSetRGBFillColor(ctx, 0/255, 191/255, 255/255, .6);
    }
    else
    {
        CGContextSetRGBFillColor(ctx, 255/255, 128/255, 191/255, .8);
    }
    [agePath fill];
     UIBezierPath *horoscopePath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(85.0, 40.0, 40.0, 13) cornerRadius:3];
    [horoscopePath fill];
     NSDictionary *attributesAge = @{NSFontAttributeName: [UIFont systemFontOfSize:10],NSForegroundColorAttributeName:[UIColor whiteColor]};
    NSString* age=[NSString stringWithFormat:@"%ld",(unsigned long)_modal.age];
    if (age) {
        [age drawAtPoint:CGPointMake(64, 40) withAttributes:attributesAge];
    }
    
   
    if (_modal.astrology) {
        [_modal.astrology drawAtPoint:CGPointMake(90, 40) withAttributes:attributesAge];
    }
    
}
-(void)drawRect:(CGRect)rect
{
if (_modal) {
    
    CGAffineTransform transform = CGAffineTransformMakeTranslation(0, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [self drawBaseInfor:ctx andRect:rect andTransform:transform];
    [self drawQiuShiButton:ctx andRect:rect andTransform:transform];
    [self drawMidleLabel:ctx andRect:rect andTtansform:transform];
    [self drawBottomButton:ctx andRect:rect andTransform:transform];
    
        
   
}
   
}
@end
