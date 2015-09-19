//
//  myCommentCell.h
//  Tab
//
//  Created by zouxue on 15/8/23.
//  Copyright (c) 2015年 xiyou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class commentDetail;
@interface CommentCell : UITableViewCell
@property(nonatomic,strong)UIImageView* portrait;
@property(nonatomic,strong)UILabel* name;
@property(nonatomic,strong)UILabel* content;
@property(nonatomic,strong)UILabel* floor;
-(void)fillTheContent:(commentDetail*)modal;
-(void)PortraitImageInComentCell:(commentDetail*)modal;
-(void)setCirclePortrit:(UIImage*)image;
@end
