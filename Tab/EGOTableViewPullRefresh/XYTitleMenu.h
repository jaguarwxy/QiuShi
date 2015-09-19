//
//  XYTitleMenu.h
//  Tab
//
//  Created by zouxue on 15/8/29.
//  Copyright (c) 2015年 xiyou. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol titleMenuDelegate<NSObject>
@optional
-(void)titleButtonCliked:(UIButton*)btn;
-(void)selectItemWithIndex:(NSInteger)index;
-(void)moveCurrentTitleWithOffsetX:(CGFloat)offset;
@end
@interface XYTitleMenu : UIScrollView<titleMenuDelegate>
{
}
-(instancetype)initWithFrame:(CGRect)frame andTtiles:(NSArray*)titles;
@property(nonatomic,strong)UIColor* titleColor;
@property(nonatomic,weak)id<titleMenuDelegate>delegate;
@end
