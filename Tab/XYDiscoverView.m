//
//  XYDiscoverView.m
//  Tab
//
//  Created by zouxue on 15/9/17.
//  Copyright (c) 2015年 xiyou. All rights reserved.
//

#import "XYDiscoverView.h"
#import "XYDiscoverTableViewCell.h"
static NSString* discoverCellIdentifier=@"discoverCell";
@interface XYDiscoverView()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView* tableview;
@property(nonatomic,strong)NSMutableArray* mDataSource;

@end
@implementation XYDiscoverView

-(void)loadXibFinish
{
    [self initControl];
}
-(void)prepareDispaly
{
    [_tableview reloadData];
}
-(void)didDispaly
{
    setCurrentNaviTitle(@"发现");
}
-(void)prepareDismiss
{}
-(void)didDismiss
{}
-(void)initControl
{
    _tableview=[[UITableView alloc] initWithFrame:self.bounds];
    _tableview.tableFooterView=[[UIView alloc] initWithFrame:CGRectZero];
    [_tableview registerClass:[XYDiscoverTableViewCell class] forCellReuseIdentifier:discoverCellIdentifier];
    _tableview.rowHeight=(self.bounds.size.height-113)/4;
    [self addSubview:_tableview];
    _tableview.dataSource=self;
    _tableview.delegate=self;
    _mDataSource=[NSMutableArray  new];
    [self loadTitles];
    
}
-(void)loadTitles
{
     NSDictionary* item1=@{@"icon":@"discovery_cafe",@"pic_size":@[@(33),@(24)],@"title":@"里屋",@"subTitle":@"糗百逗比集中营"};
    NSDictionary* item2=@{@"icon":@"discovery_nearby",@"pic_size":@[@(28),@(33)],@"title":@"附近",@"subTitle":@"查看附近糗友"};
    NSDictionary* item3=@{@"icon":@"icon_posted",@"pic_size":@[@(40),@(40)],@"title":@"任意门",@"subTitle":@"不用去外地，就能广交朋友"};
    NSDictionary* item4=@{@"icon":@"discovery_qiubaihuo",@"pic_size":@[@(31),@(32)],@"title":@"糗百货",@"subTitle":@"萌萌但糗事百科周边，买买买"};
    [self.mDataSource addObject:item1];
    [self.mDataSource addObject:item2];
    [self.mDataSource addObject:item3];
    [self.mDataSource addObject:item4];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XYDiscoverTableViewCell* cell=(XYDiscoverTableViewCell*)[tableView dequeueReusableCellWithIdentifier:discoverCellIdentifier forIndexPath:indexPath];
    NSDictionary* dic=[_mDataSource objectAtIndex:indexPath.row];
    [cell fillTheContent:dic];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[XYHelper shareHelper] showTips:@"您还没有登录哦"];
}
@end
