//
//  XYView.m
//  Tab
//
//  Created by zouxue on 15/8/16.
//  Copyright (c) 2015年 xiyou. All rights reserved.
//

#import "XYView.h"

@implementation XYView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
@synthesize data=_data;
-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super initWithCoder:aDecoder]) {
    _data=[[NSMutableDictionary alloc] init ];
    }
    return self;
}

@end
