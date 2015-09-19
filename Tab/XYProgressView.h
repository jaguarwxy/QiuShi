//
//  progressView.h
//  Tab
//
//  Created by zouxue on 15/8/28.
//  Copyright (c) 2015年 xiyou. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, XYProgressViewStyle) {
    XYProgressViewStyleLine=1,
    XYProgressViewStyleCircle,
    XYProgressViewStylePie,
    
};
@interface XYProgressView : UIView

@property(nonatomic,copy)void(^progressChangeBlock)(XYProgressView* progressView,CGFloat progress);
@property(nonatomic,assign)CGFloat lineWidth ;
//@property(nonatomic,assign)CGFloat radious ;
@property(nonatomic,strong)UIColor* tintColor;
//@property(nonatomic,assign)CGFloat boardWidth;
//@property (nonatomic, assign) CFTimeInterval animationDuration ;
-(void)setProgress:(CGFloat)progress;
-(id)initWithFrame:(CGRect)frame andStyle:(XYProgressViewStyle)style;
@end
