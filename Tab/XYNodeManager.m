//
//  XYNodeManager.m
//  Tab
//
//  Created by zouxue on 15/7/29.
//  Copyright (c) 2015年 xiyou. All rights reserved.
//

#import "XYNodeManager.h"
@interface XYNodeManager()
@property(nonatomic,strong)NSMutableArray* nodesAry;
@property(nonatomic,strong)NSMutableArray* popAry;
@property(nonatomic,strong)NSMutableArray* naviNodesAry;

@property(nonatomic,strong)NSMutableArray* naviList;
@property(nonatomic,strong)NSMutableArray* pageNodes;

@end
@implementation XYNodeManager
-(id)init
{
    if (self=[super init]) {
        _naviList=[NSMutableArray new];
        _pageNodes=[NSMutableArray new];
        _popNaviList=[NSMutableArray new];
        [self loadNodeData];
    }
    return self;
}
+(XYNodeManager*)shareNodeManager
{
    static  dispatch_once_t onceToken;
    static XYNodeManager * manager=nil;
    dispatch_once(&onceToken, ^{
            manager=[[XYNodeManager alloc]init];
   });
    return manager;
    
}
-(void)loadNodeData
{
    NSString* path=[[NSBundle mainBundle] bundlePath];
    NSString* fileParh=[path stringByAppendingPathComponent:@"pageNodes"];
    NSData* data=[NSData dataWithContentsOfFile:fileParh];
    NSString* stringcContent=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    data=[stringcContent dataUsingEncoding:NSUTF8StringEncoding];
    NSError* error=nil;
    NSDictionary* jsonObject=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    if (error==nil) {
        [self setValuesForKeysWithDictionary:jsonObject];
    }
    else
    {
        NSLog(@"%@",[error localizedFailureReason]);
    }
    
}
-(void)setValue:(id)value forKey:(NSString *)key
{
    if([key isEqualToString:@"naviList"])
    {
        NSArray* array=(NSArray*)value;
        for (NSDictionary* tem in array) {
            naviNode* modal=[[naviNode alloc] initWithDictionary:tem];
            [_naviList addObject:modal];
        }
    }
    else if([key isEqualToString:@"pageNodes"])
    {
        NSArray* array=(NSArray*)value;
        for (NSDictionary* tem in array) {
            pageNode* modal=[[pageNode alloc] initWithDictionary:tem];
            [_pageNodes addObject:modal];
        }
    }
    else if ([key isEqualToString:@"popNaviList"])
    {
        NSArray* array=(NSArray*)value;
        for (NSDictionary* tem in array) {
            naviNode* modal=[[naviNode alloc] initWithDictionary:tem];
            [_popNaviList addObject:modal];
        }

    }
    else
    {
        [super setValue:value forKey:key];
    }
}
-(BOOL)isPage:(NSInteger)pageid inStack:(NSInteger)stackId
{
    for (naviNode* naviNode in _naviList) {
        if (stackId==naviNode.naviID) {
            return  [naviNode isPageIdInArray:pageid];
        }
    }
    for (naviNode* naviNode in _popNaviList) {
        if (stackId==naviNode.naviID)
        {
            return [naviNode isPageIdInArray:pageid];
        }
    }
    return NO;
}
-(NSMutableArray*)theNaviNodesAry
{
    return self.naviList;
}

-(NSInteger)getNaviIndexWithPageID:(NSString*)pageid
{
    for (naviNode* navi in _naviList) {
        if ([navi isPageIdInArray:[pageid integerValue]]) {
            return navi.naviID;
        }
    }
    for (naviNode* navi in _popNaviList) {
        if ([navi isPageIdInArray:[pageid integerValue]]) {
            return navi.naviID;
        }
    }
    return -1;
}
-(pageNode*)pageNodeWithPageID:(NSInteger)pageid
{
    for (pageNode* pageNode in _pageNodes) {
        if (pageid==pageNode.nodeID) {
            return pageNode;
        }
    }
    return nil;
}
-(pageNode*)pageNodeWithPageIDString:(NSString*)pageidString
{
    NSInteger pageID=[pageidString integerValue];
    return [self pageNodeWithPageID:pageID];
}

@end


@implementation naviNode

-(id)initWithDictionary:(NSDictionary *)dic
{
    if (self=[super init]) {
        _nodesAry=[[NSMutableArray alloc]init];
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
-(BOOL)isPageIdInArray:(NSInteger)pageID
{
    for (NSString* node in _nodesAry) {
        if (pageID==[node integerValue]) {
            return YES;
        }
    }
    return NO;
    
}
@end
@implementation pageNode

-(id)initWithDictionary:(NSDictionary*)dic
{
    if (self=[super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

@end