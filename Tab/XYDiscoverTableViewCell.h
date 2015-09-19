//
//  XYDiscoverTableViewCell.h
//  Tab
//
//  Created by zouxue on 15/9/17.
//  Copyright (c) 2015年 xiyou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYDiscoverTableViewCell : UITableViewCell
@property (strong, nonatomic) UIImageView *icon;
@property (strong, nonatomic) UILabel *title;
@property (strong, nonatomic) UILabel *subTitle;
-(void)fillTheContent:(NSDictionary*)dic;
@end
