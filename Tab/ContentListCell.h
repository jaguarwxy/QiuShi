//
//  ContentListCell.h
//  Tab
//
//  Created by zouxue on 15/8/1.
//  Copyright (c) 2015年 xiyou. All rights reserved.
//
@class detailItemData;
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "XYPlayer.h"
@interface ContentListCell : UITableViewCell
@property (strong, nonatomic)  UIButton *smile;
@property (strong, nonatomic)  UIImageView *contentImage;
@property (strong, nonatomic)  UILabel *contentText;
@property (strong, nonatomic)  UILabel *laughNumber;
@property (strong, nonatomic)  UIButton *cry;
@property (strong, nonatomic)  UIButton *comment;
@property (strong, nonatomic)  UILabel *name;
@property (strong, nonatomic)  UIImageView *portrait;
@property (strong, nonatomic)  XYPlayer*  playerView;
@property(assign,nonatomic)NSInteger numberLike;//为了点击笑脸后的个数变化，这里要存一个数值
@property(nonatomic,assign)CGFloat cellHeight;
@property(assign,nonatomic)NSInteger numberComment;
-(void)fillTheContent:(detailItemData*)modal;
-(void)setLikeAndCommentLabelWithLikeNumber:(NSInteger )like andComment:(NSInteger)comment;
-(void)setCirclePortrit:(UIImage*)image;
-(void)setCellImageWithModal:(detailItemData*)modal;
-(void)removePlayer;
@end
