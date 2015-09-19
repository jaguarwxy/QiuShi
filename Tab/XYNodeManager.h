//
//  XYNodeManager.h
//  Tab
//
//  Created by zouxue on 15/7/29.
//  Copyright (c) 2015年 xiyou. All rights reserved.
//

#import <Foundation/Foundation.h>
@class pageNode;
@interface XYNodeManager : NSObject
+(XYNodeManager*)shareNodeManager;
-(NSMutableArray*)theNaviNodesAry;

-(NSInteger)getNaviIndexWithPageID:(NSString*)pageid;
-(BOOL)isPage:(NSInteger)pageid inStack:(NSInteger)stackId;
-(pageNode*)pageNodeWithPageID:(NSInteger)pageid;
-(pageNode*)pageNodeWithPageIDString:(NSString*)pageidString;
@property(nonatomic,strong)NSMutableArray* popNaviList;
@end


@interface naviNode : NSObject
@property(nonatomic,assign)NSInteger naviID;
@property(nonatomic,strong)NSMutableArray* nodesAry;
-(id)initWithDictionary:(NSDictionary*)dic;
-(BOOL)isPageIdInArray:(NSInteger)pageID;

@end
@interface pageNode : NSObject
@property(nonatomic,copy)NSString*   nodeName;
@property(nonatomic,assign)NSInteger nodeID;
@property(nonatomic,assign)NSInteger nodeLevel;
-(id)initWithDictionary:(NSDictionary*)dic;
@end