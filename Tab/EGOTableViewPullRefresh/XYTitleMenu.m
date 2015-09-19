//
//  XYTitleMenu.m
//  Tab
//
//  Created by zouxue on 15/8/29.
//  Copyright (c) 2015年 xiyou. All rights reserved.
//
#define layerHeight 3
#import "XYTitleMenu.h"
@interface XYTitleMenu()
{
    NSInteger curSelected;
}
@property(nonatomic,strong)NSMutableArray* buttonsArray;
@property(nonatomic,strong)NSMutableArray* titlesArray;
@property(nonatomic,assign)CGFloat totalWidth;
@property(nonatomic,strong)CALayer* markLayer;
@end

@implementation XYTitleMenu
@dynamic delegate;
-(instancetype)initWithFrame:(CGRect)frame andTtiles:(NSArray*)titles
{
    if ([super initWithFrame:frame]) {
        
        _buttonsArray=[NSMutableArray new];
        _titlesArray=[[NSMutableArray alloc]initWithArray:titles];
        _markLayer=[CALayer new];
        if ([_titlesArray count]>0) {
            [self setUp];
            curSelected=0;
        }
    }
    return self;
}
-(void)setUp
{
    for (NSInteger i=0; i<[_titlesArray count]; i++) {
      [self createItemWithTitle:_titlesArray[i] andID:i];
    }
}
-(CGFloat)createItemWithTitle:(NSString*)title andID:(NSInteger) itemID
{
    UIButton* itemBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat width=[title boundingRectWithSize:CGSizeMake(60, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size.width;
    [itemBtn setTitle:title forState:UIControlStateNormal];
    itemBtn.frame=CGRectMake(0, 0, width, self.bounds.size.height);
    itemBtn.tag=itemID;
    itemBtn.titleLabel.font=[UIFont systemFontOfSize:16];
    [itemBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
    [itemBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    _totalWidth+=width;
    [itemBtn setBackgroundColor:[UIColor clearColor]];
    [itemBtn addTarget:self action:@selector(menuButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    if (curSelected==itemID) {
        itemBtn.selected=YES;
    }
    [_buttonsArray addObject:itemBtn];
    [self addSubview:itemBtn];
    return width;
}
-(void)layoutSubviews
{
    [self resizeItemsFrame];
}
-(void)resizeItemsFrame
{
    NSInteger  titleCount=[_titlesArray count];
    if (titleCount) {
    if (_totalWidth>self.bounds.size.width/2&&titleCount>6) {
        CGFloat tem=_totalWidth+titleCount*30 ;
        CGFloat theWidth= MAX(tem, self.bounds.size.width);
        self.contentSize=CGSizeMake(theWidth , self.bounds.size.height);
    }
    else
    {
        self.contentSize=CGSizeMake(self.bounds.size.width , self.bounds.size.height);
    }
    CGFloat gap=(self.contentSize.width-_totalWidth)/titleCount;
         UIButton* btn=_buttonsArray[0];
         CGRect btnFrame=btn.frame;
        btnFrame.origin.x=gap/2;
        btn.frame=btnFrame;
        for (NSInteger i=1; i<titleCount; i++) {
             btn=_buttonsArray[i];
            btnFrame.origin.x=CGRectGetMaxX(btnFrame)+gap;
            btnFrame.size.width=btn.frame.size.width;
            btn.frame=btnFrame;
        }
   }
    if (![_markLayer superlayer]) {
        [self.layer addSublayer:_markLayer];
        _markLayer.backgroundColor=[UIColor orangeColor].CGColor;
        [self moveMarkLayerToIndex:curSelected];
    }
   
}
-(void)menuButtonClicked:(UIButton*)sender
{
    NSInteger  tag=sender.tag;
    if ([self.delegate respondsToSelector:@selector(titleButtonCliked:)]) {
        [self.delegate titleButtonCliked:sender];
        
    }
    [self selectItemWithIndex:tag];
}
-(void)selectItemWithIndex:(NSInteger)index
{
    
    if (index<[_buttonsArray count]) {
        UIButton* curBtn=_buttonsArray[curSelected];
        UIButton* toBtn=_buttonsArray[index];
        curBtn.selected=NO;
        [self moveMarkLayerToIndex:index];
        toBtn.selected=YES;
        curSelected=index;
    }
   
}
-(void)moveMarkLayerToIndex:(NSInteger)index
{
    if (index<[_buttonsArray count]) {
    
        CGRect dest=[[_buttonsArray objectAtIndex:index] frame];
        dest.origin.y=dest.size.height-layerHeight;
        dest.size.height=layerHeight;
        _markLayer.frame=dest;
//        CABasicAnimation * basicAnimation=[CABasicAnimation  animationWithKeyPath:@"transform.translation"];
//        basicAnimation.fromValue=[NSValue valueWithCGPoint:_markLayer.position];
//        basicAnimation.toValue=[NSValue valueWithCGPoint:dest];
//        basicAnimation.duration=.7f;
//        basicAnimation.removedOnCompletion=NO;
//        [_markLayer addAnimation:basicAnimation forKey:nil];
    }
}
-(UIButton*)preButton
{
    if (curSelected-1>=0&&curSelected-1<[_buttonsArray count]) {
        return (UIButton*)_buttonsArray[curSelected-1];
    }
    return nil;
}
-(UIButton*)nextButton
{
    if (curSelected>=0&&curSelected+1<[_buttonsArray count]) {
        return (UIButton*)_buttonsArray[curSelected+1];
    }
    return nil;
}
-(UIButton*)currentButton
{
    if (curSelected<[_buttonsArray count]&&curSelected>=0) {
        return (UIButton*)_buttonsArray[curSelected];
    }
    return nil;
}
-(void)moveCurrentTitleWithOffsetX:(CGFloat)offset
{
    UIButton* theButton=nil;
    if (offset<0) {
        theButton=[self nextButton];
    }
    else if(offset>0)
    {
        theButton=[self preButton];
    }
    if ((curSelected>0&&offset>0)|| (curSelected<[_buttonsArray count]-1&&offset<0)) {//如果要是在最边边的酒不移动了
    CGRect frame= _markLayer.frame;
    CGFloat finalOffset=-offset*ABS(theButton.center.x-_markLayer.position.x)/4;
    frame.origin.x+=finalOffset;
    _markLayer.frame=frame;
    }
}
@end
