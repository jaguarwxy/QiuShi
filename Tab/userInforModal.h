//
//  userInforModal.h
//  Tab
//
//  Created by zouxue on 15/9/12.
//  Copyright (c) 2015年 xiyou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInforModal : NSObject
@property(nonatomic,assign)NSInteger age;
@property(nonatomic,copy)NSString*  astrology;//星座
@property(nonatomic,assign)NSInteger bg;
@property(nonatomic,copy)NSString*  big_cover;//大照
@property(nonatomic,assign)NSInteger big_cover_eday;
@property(nonatomic,assign)NSTimeInterval created_at;
@property(nonatomic,copy)NSString* emotion;
@property(nonatomic,copy)NSString* gender;
@property(nonatomic,copy)NSString* haunt;
@property(nonatomic,copy)NSString* hobby;
@property(nonatomic,copy)NSString* hometown;
@property(nonatomic,copy)NSString* icon;
@property(nonatomic,copy)NSString* introduce;
@property(nonatomic,copy)NSString* job;
@property(nonatomic,copy)NSString* location;
@property(nonatomic,copy)NSString* login;
@property(nonatomic,copy)NSString* mobile_brand;
@property(nonatomic,copy)NSString* qb_age;
@property(nonatomic,copy)NSString*  qs_cnt;
@property(nonatomic,copy)NSString*  relationship;
@property(nonatomic,copy)NSString*  signature;
@property(nonatomic,assign)NSInteger  uid;
@property(nonatomic,copy)NSString*  smile_cnt;
@property(nonatomic,strong)UIImage* portrait;
@property(nonatomic,strong)UIImage*  coverImage;
-(id)initWithDictionary:(NSDictionary *)dic;
@end
