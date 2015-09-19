//
//  secondView.m
//  Tab
//
//  Created by zouxue on 15/8/28.
//  Copyright (c) 2015年 xiyou. All rights reserved.
//

#import "ContainerView.h"
#import "XYProgressView.h"
#import "XYTitleMenu.h"
#import "XYPublicInterface.h"
#import "XYframe.h"
@interface ContainerView()<titleMenuDelegate>
{
    NSInteger currentIndex;
    CGRect subViewFrame;
}
@property(nonatomic,strong)XYProgressView* progress;
@property(nonatomic,strong)XYTitleMenu* titleMenu;
@property(nonatomic,strong)NSMutableArray* viewsIDArray;
@property(nonatomic,strong)NSMutableArray* subViewsArray;
//@property(nonatomic,strong)UIView* subView;
@end
@implementation ContainerView

-(void)loadXibFinish
{
    currentIndex=0;
    _subViewsArray=[NSMutableArray new];
    subViewFrame=CGRectMake(0, 30, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)-30);
    [self initControl];
    [self addViewAtIndex:currentIndex andFrame:subViewFrame];
}
-(void)prepareDispaly
{
    UIImageView* imageV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo"]];
    setCurrentNaviTitleView(imageV);
}
-(void)initControl
{
     _titleMenu=[[XYTitleMenu alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 30) andTtiles:@[@"最新",@"精华",@"纯文",@"纯图",@"视频"]];
    [self addSubview:_titleMenu];
    _titleMenu.delegate=self;
    _viewsIDArray=[[NSMutableArray alloc]initWithArray:@[@"1001",@"1002",@"1003",@"1004",@"1005"]];
      UIPanGestureRecognizer* panGesture=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(moveTheView:)];
    [self addGestureRecognizer:panGesture];
}
-(void)addViewAtIndex:(NSInteger)index andFrame:(CGRect)frame;
{
    static NSInteger  color=0;
        if(index>=[_viewsIDArray count])
    {
        NSLog(@"添加页面失败");
        return;
    }
    XYframe* appFrame=[XYPublicInterface getFrame];
    frame.origin.x+=frame.size.width*index;
    frame.size.width=deviceWidth;
    UIView* theNewSubView=[appFrame viewWithNodeId:_viewsIDArray[index]];
    theNewSubView.frame=frame;
    theNewSubView.tag=index;
    [self addSubview:theNewSubView];
    [self.subViewsArray addObject:theNewSubView];
}
-(void)moveTheView:(UIPanGestureRecognizer*)gesture
{
    static  CGPoint translation;
    static BOOL start;
    static moveDirection direction;
    if(gesture.state==UIGestureRecognizerStateBegan)
    {  //懒加载，，如果页面从来没往右划过，就不用加载了
         if ([_subViewsArray count]==currentIndex+1&&currentIndex<[_viewsIDArray count]) {
                [self addViewAtIndex:currentIndex+1 andFrame:subViewFrame];
        }
        
    }
    if (gesture.state==UIGestureRecognizerStateChanged) {
        if (!start) {
            translation=[gesture translationInView:self];
            start=YES;
            direction=[self directionWithOffestX:translation];
            return;
        }
        CGPoint    curLocation=[gesture translationInView:self];
        [_titleMenu moveCurrentTitleWithOffsetX:curLocation.x/self.bounds.size.width];
        CGFloat offset=curLocation.x-translation.x;
        translation=curLocation;
        UIView* currentView=_subViewsArray[currentIndex];
        CGPoint center=currentView.center;
        currentView.center=CGPointMake(center.x+offset, center.y);
        UIView* nearView=[self nearViewWithDirection:direction];
        if (nearView!=nil) {
            center=nearView.center;
            nearView.center=CGPointMake(center.x+offset, center.y);
        }
        
    }
    else if(gesture.state==UIGestureRecognizerStateEnded||gesture.state==UIGestureRecognizerStateCancelled||gesture.state==UIGestureRecognizerStateRecognized)
    {
        start=NO;
        UIView* currentView=[self getCurrentView];
        CGPoint center=currentView.center;
        if (direction==directionLeft) {
            if (center.x<50) {
                [self setCurrentView:currentIndex+1];
                
            }
            else{
                [self setCurrentView:currentIndex];
            }
        }
        else if(direction==directionRight)
        {
            if (center.x>280) {
                [self setCurrentView:currentIndex-1];
            }
            else{
                [self setCurrentView:currentIndex];
            }
                
        }
        else
        {
             [self setCurrentView:currentIndex];
        }
        direction=directionNone;
    }
    
    
}
-(void)setCurrentView:(NSInteger)index
{
    if (index<[_subViewsArray count]) {
        currentIndex=index;
    }
    [_titleMenu selectItemWithIndex:currentIndex];
    [UIView animateWithDuration:.5 animations:^{
    for (int i=0; i<[_subViewsArray count]; i++) {
        CGFloat offset =i-currentIndex;
        
        UIView* theView=_subViewsArray[i];
        CGPoint center=self.center;
        theView.center=CGPointMake(center.x+(offset*deviceWidth), theView.center.y);
    }
    }];
}
-(UIView*)nearViewWithDirection:(moveDirection)direction
{
    UIView* nearView=nil;
    if (direction==directionLeft) {
        nearView=[self getNextView];
    }
    else if(direction==directionRight)
    {
        nearView=[self getPreView ];
    }
    return nearView;
}
-(moveDirection)directionWithOffestX:(CGPoint)offset
{
    moveDirection  direction=directionNone;
    if (offset.x>0) {
        direction= directionRight;//往右滑
    }
    else if(offset.x<0)
    {
        direction=directionLeft;//往左滑
    }
    else{
        NSLog(@"不适用");
    }
    return direction;
}
-(UIView*)getCurrentView
{
    if (currentIndex<[_subViewsArray count]) {
        return _subViewsArray[currentIndex];
    }
    return nil;
}
-(UIView*)getNextView
{
    if (currentIndex+1<[_subViewsArray count]) {
        return _subViewsArray[currentIndex+1];
    }
    return nil;
}
-(UIView*)getPreView
{
    if (currentIndex-1>=0&&currentIndex-1<[_subViewsArray count]) {
        return _subViewsArray[currentIndex-1];
    }
    return nil;
}
-(void)titleButtonCliked:(UIButton *)btn
{
    NSInteger index=btn.tag;
    if (index<[_viewsIDArray count]) {
        if ([_subViewsArray count]<=index) {
            
            for (NSInteger i=[_subViewsArray count]; i<=index; i++) {
                [self addViewAtIndex:i andFrame:subViewFrame];
            }
        }
        
        
        [self setCurrentView:index];
    }
    
}

-(void)didDispaly
{
}
-(void)prepareDismiss
{
    
}
-(void)didDismiss
{
}
@end
