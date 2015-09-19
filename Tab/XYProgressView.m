//
//  progressView.m
//  Tab
//
//  Created by zouxue on 15/8/28.
//  Copyright (c) 2015年 xiyou. All rights reserved.
//


#import "XYProgressView.h"
@interface XYProgressView()
@property(nonatomic,strong)CAShapeLayer* shapLayer;
@property(nonatomic,assign)CGFloat progress;
@property(nonatomic,assign)XYProgressViewStyle style;
@end
@implementation XYProgressView
-(void)setLineWidth:(CGFloat)lineWidth
{
    //self.layer.borderWidth=self.bounds.size.width+10;
    self.layer.backgroundColor=[UIColor clearColor].CGColor;
    self.shapLayer.lineWidth=lineWidth;
}
-(void)setTintColor:(UIColor *)tintColor
{
    self.layer.borderColor=tintColor.CGColor;
    self.shapLayer.strokeColor=tintColor.CGColor;//画笔颜色
    
}
-(id)initWithFrame:(CGRect)frame andStyle:(XYProgressViewStyle)style

{
    if (style==XYProgressViewStylePie)
    {
        CGRect theFrame=frame;
        theFrame.size.width/=2;
        theFrame.size.height/=2;
        if (self=[super initWithFrame:theFrame]) {
            _style=style;
            [self setUp];
        }
    }
    else
    {
        _style=style;
        if (self=[super initWithFrame:frame]) {
            [self setUp];
        }
    }
    
    
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        _style=XYProgressViewStyleCircle;
        [self setUp];
    }
    
    return self;
}

-(void)layoutSubviews
{
    switch (_style) {
        case XYProgressViewStyleCircle:
            self.shapLayer.path=[self layoutCircleParh].CGPath;
            self.layer.borderWidth=10;
            self.layer.cornerRadius=self.bounds.size.width/2;
            break;
            
       case XYProgressViewStylePie:
            self.shapLayer.lineWidth=self.bounds.size.width;
            self.shapLayer.path=[self layoutPieParh].CGPath;
            break;
        case XYProgressViewStyleLine:
            self.shapLayer.path=[self layoutLinePath];
            break;
    }
     //self.shapLayer.path=[self layoutParh].CGPath;
    [self.layer addSublayer:_shapLayer];
    self.progress=0;
}
-(void)setUp
{    //默认设置一些
     self.layer.borderColor=[UIColor purpleColor].CGColor;
    self.progressChangeBlock=nil;
    self.shapLayer=[[CAShapeLayer alloc]init];
    self.shapLayer.fillColor=[UIColor clearColor].CGColor;
    self.shapLayer.strokeColor=[UIColor purpleColor].CGColor;
    self.shapLayer.lineWidth=10;
}
-(UIBezierPath*)layoutPieParh
{
    const double two_p=2.0*M_PI;
    const double startAngle=0.75*two_p;
    const double endAngle=startAngle+two_p;
    CGFloat width=self.shapLayer.lineWidth/2;
    return [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.width/2) radius:width startAngle:startAngle endAngle:endAngle clockwise:YES];
    //被塞尔曲线圆形路径。radius是shaplayer的半径，取成frame的宽度好了，如果要画饼呢，就把radius半径取sharplayer。linewidrh的一半刚好，因为，linewithd的中心点（长度一半）是在半径那算的，然后往两边延伸（linewidth/2）;所以linewidth取半径的两倍，刚好是以原来对原点为中心，画一个半径是path半径两倍的圆。如果要画圈圈，那就半径减去linewidth，意思一下，问题不大
}
-(UIBezierPath*)layoutCircleParh
{
    const double two_p=2.0*M_PI;
    const double startAngle=0.75*two_p;
    const double endAngle=startAngle+two_p;
    CGFloat width=self.bounds.size.width/2;
    CGFloat borderWidth=self.shapLayer.lineWidth;
    return [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.width/2) radius:width-borderWidth startAngle:startAngle endAngle:endAngle clockwise:YES];
}
-(CGMutablePathRef)layoutLinePath
{
    
    CGMutablePathRef path=CGPathCreateMutable();
    CGAffineTransform transform=CGAffineTransformMakeTranslation(0, 0);
    CGPathMoveToPoint(path, &transform, 0, 0);
    CGPathAddLineToPoint(path, &transform, self.bounds.size.width, 0);
    return path;
}
-(void)setProgress:(CGFloat)progress
{
    progress = MAX( MIN(progress, 1.0), 0.0);
    if (_progress==progress) {
        return;
    }
    _progress=progress;
    if (self.progressChangeBlock) {
        self.progressChangeBlock(self,_progress);
    }
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    self.shapLayer.strokeEnd=progress;
    [CATransaction commit];

}
@end
