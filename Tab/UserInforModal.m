//
//  userInforModal.m
//  Tab
//
//  Created by zouxue on 15/9/12.
//  Copyright (c) 2015年 xiyou. All rights reserved.
//

#import "UserInforModal.h"

@implementation UserInforModal
-(id)initWithDictionary:(NSDictionary *)dic
{
    if (self=[super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    [self check];
    return self;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"login_eday"]||[key isEqualToString:@"icon_eday"]) {
        NSLog(@"login_eday");
    }
    else if([key isEqualToString:@"qs_cnt"])
    {
        NSInteger qscnt=[value integerValue];
        if (qscnt>100) {
            qscnt/=100;
            _qs_cnt=[NSString stringWithFormat:@"%ldk",(unsigned long)qscnt];
        }
        else
        {
            _qs_cnt=[NSString stringWithFormat:@"%ld",(unsigned long)qscnt];
        }
        
    }
    else if ([key isEqualToString:@"smile_cnt"])
    {
        NSInteger smile=[value integerValue];
        if (smile>100) {
            smile/=100;
            _smile_cnt=[NSString stringWithFormat:@"%ldk",(unsigned long)smile];
        }
        else
        {
            _smile_cnt=[NSString stringWithFormat:@"%ld",(unsigned long)smile];
        }
    }
    else
    {
        [super setValue:value forUndefinedKey:key];
    }
}
-(void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"qb_age"]) {
        [self qiuBaiAgeWithInt:[value integerValue]];
    }
    else
    {
       [super setValue:value forKey:key];
    }
}
-(void)check
{
   
    if(self.location==nil)
    {
        _location=[NSString stringWithFormat:@"未知"];
    }
    if (self.mobile_brand==nil) {
        _mobile_brand=[NSString stringWithFormat:@"未知"];
    }
    if (self.job==nil) {
       _job=[NSString stringWithFormat:@"未知"];
    }
    if (self.hometown==nil) {
        _hometown=[NSString stringWithFormat:@"未知"];
    }
  
}
-(void)qiuBaiAgeWithInt:(NSInteger)day
{
    NSInteger year=day/365;
    day%=365;
    NSInteger month=day/30+1;
    if (year>0) {
        _qb_age=[NSString stringWithFormat:@"%d年%d月",(int)year,(int)month];
    }
    else
    {
       _qb_age=[NSString stringWithFormat:@"%d月",(int)month];
    }
}
@end
