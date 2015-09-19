//
//  ContentModal.h
//  Tab
//
//  Created by zouxue on 15/8/1.
//  Copyright (c) 2015年 xiyou. All rights reserved.
//

#import <Foundation/Foundation.h>
@class userData;
@interface detailItemData : NSObject
@property(nonatomic,copy)NSString* content;
@property(nonatomic,assign)NSInteger comments_count;
@property(nonatomic,assign)NSInteger allow_comment;
@property(nonatomic,assign)NSTimeInterval created_at;
@property(nonatomic,copy)NSString* itemId;
@property(nonatomic,copy)NSString* image;
@property(nonatomic,copy)NSMutableDictionary*  image_size;
@property(nonatomic,assign)NSTimeInterval published_at;
@property(nonatomic,assign)NSInteger share_count;
@property(nonatomic,copy)NSString*  state;
@property(nonatomic,copy)NSString* tag;
@property(nonatomic,copy)NSString* type;
@property(nonatomic,strong)userData*  userData;
@property(nonatomic,copy)NSString* down;
@property(nonatomic,copy)NSString* up;
@property(nonatomic,assign)NSInteger selectType;//0未选 1点了笑脸，2点了哭
@property(nonatomic,strong)UIImage* contentImage;
@property(nonatomic,assign)NSInteger appropriateHeight;
////视频比原来的新增数据
@property(nonatomic,copy)NSString* high_url;//高清视频地址
@property(nonatomic,copy)NSString* low_url;
@property(nonatomic,copy)NSString* pic_url;//截屏地址
@property(nonatomic,assign)NSInteger loop;//再生
@property(nonatomic,assign)NSInteger refresh;
@property(nonatomic,assign)NSInteger total;
@property(nonatomic,assign)CGSize    videoSize;
@property(nonatomic,assign)CGSize    pictureSize;
-(CGFloat)heightOfModal;
-(id)initWithDictionary:(NSDictionary*) dic;
@end

@interface userData : NSObject
@property(nonatomic,assign)NSTimeInterval avatar_updated_at;
@property(nonatomic,assign)NSTimeInterval created_at;
@property(nonatomic,copy)NSString* email;
@property(nonatomic,copy)NSString* icon;
@property(nonatomic,copy)NSString*  userID;
@property(nonatomic,copy)NSString* last_visited_at;
@property(nonatomic,copy)NSString* login;//名字？？？？
@property(nonatomic,copy)NSString* role;
@property(nonatomic,copy)NSString* state;
@property(nonatomic,strong)UIImage* userIcon;
-(id)initWithDictionary:(NSDictionary*) dic;
@end
////////////评论页面modal...还是不用这个方便点
@interface commentMoal : NSObject
@property(nonatomic,copy)NSString* count;
@property(nonatomic,strong)NSMutableArray* items;
@property(nonatomic,copy)NSString* total;
@property(nonatomic,assign)NSInteger  page;
-(id)initWithDictionary:(NSDictionary *)dic;
@end

@interface commentDetail : NSObject
@property(nonatomic,copy)NSString* content;
@property(nonatomic,copy)NSString* floor;
@property(nonatomic,copy)NSString*  commentID;
@property(nonatomic,assign)NSInteger appropriateHeight;
@property(nonatomic,strong)userData*  userData;

-(id)initWithDictionary:(NSDictionary *)dic;
@end
