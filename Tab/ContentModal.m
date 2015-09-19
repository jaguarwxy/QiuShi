//
//  ContentModal.m
//  Tab
//
//  Created by zouxue on 15/8/1.
//  Copyright (c) 2015年 xiyou. All rights reserved.
//

#import "ContentModal.h"
@implementation detailItemData
-(id)initWithDictionary:(NSDictionary *)dic
{
    if (self=[super init]) {
        self=[self init];
        self.videoSize=CGSizeZero;
        self.pictureSize=CGSizeZero;
        [self setValuesForKeysWithDictionary:dic];
        [self heightOfModal];
    }
    return self;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.itemId=[NSString stringWithFormat:@"%@",value];
    }
    if ([key isEqualToString:@"votes"]) {
        self.down=[NSString stringWithFormat:@"%@",value[@"down"]];
        self.up=[NSString stringWithFormat:@"%@",value[@"up"]];
    }
}
-(void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"user"]) {
        self.userData=[[userData alloc]initWithDictionary:value];
    }
    else if([key isEqualToString:@"pic_size"])//视频大小
    {
        NSArray* ary=(NSArray*)value;
        self.videoSize=CGSizeMake([[ary firstObject] floatValue ]/2 , [[ary lastObject] floatValue]/2);
    }
    else
        [super setValue:value forKey:key];
}
-(CGFloat)heightOfModal
{
    CGFloat sum=136;
    UIFont* font=[UIFont systemFontOfSize:14];
    sum+=[self.content boundingRectWithSize:CGSizeMake(280, 400) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size.height;;
    if (self.image_size) {
        NSArray* picSize=[self.image_size objectForKey:@"m"];
        if (picSize!=nil) {
            CGFloat picW=[picSize[0] floatValue];
            CGFloat picH=[picSize[1] floatValue];
            if (picW>320) {
                if (picH) {
                    picH=picH/picW*300;
                }
                picW=300;
                self.pictureSize=CGSizeMake(picW, picH);
            }
            sum+=picH;
        }
    }
    if (self.high_url) {//视频
        sum+=340;
    }
    self.appropriateHeight=sum;
    return sum;

}
@end

@implementation userData

-(id)initWithDictionary:(NSDictionary *)dic
{
    if (self=[super init]) {
        self=[self init];
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.userID=[NSString stringWithFormat:@"%@",value];
    }

   // [super setValue:value forUndefinedKey:key];
}


-(NSString*)description
{
    return [NSString stringWithFormat:@"avatar_updated_at:%f, created_at:%f,  email:%@  ,icon:%@   userID: %@  last_visited_at:%@,,login:%@  role:%@ state:%@, userIcon:%@",_avatar_updated_at,_created_at,_email,_icon,_userID,_last_visited_at,_login,_role,_state,_userIcon];
}
@end

@implementation commentMoal

-(id)initWithDictionary:(NSDictionary *)dic
{
    if (self=[super init]) {
        self=[self init];
        _items=[NSMutableArray new];
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
-(void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"items"]) {
        for (NSDictionary* dic in value) {
            commentDetail* item=[[commentDetail alloc] initWithDictionary:dic];
            [_items addObject:item];
        }
    }
    else
        [super setValue:value forKey:key];
}
@end

@implementation commentDetail
-(id)initWithDictionary:(NSDictionary *)dic
{
    if (self=[super init]) {
        self=[self init];
        [self setValuesForKeysWithDictionary:dic];
        [self heightOfModal];
    }
    
    return self;
}
-(CGFloat)heightOfModal
{
    CGFloat sum=55;
    UIFont* font=[UIFont systemFontOfSize:14];
    sum+=[self.content boundingRectWithSize:CGSizeMake(280, 400) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size.height;;
    self.appropriateHeight=sum;
    return sum;
    
}

-(void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"user"]) {
        _userData=[[userData alloc]initWithDictionary:value];
    }
    else
        [super setValue:value forKey:key];
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        _commentID=[NSString stringWithFormat:@"%@",value];
    }
}
-(NSString*)description
{
    return [NSString stringWithFormat:@"content: %@, commentID:%@ floor:%@  userdata:%@",_content,_commentID,_floor,_userData];
}
@end
