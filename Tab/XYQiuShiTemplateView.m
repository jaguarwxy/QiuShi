//
//  firstView.m
//  Tab
//
//  Created by zouxue on 15/8/16.
//  Copyright (c) 2015年 xiyou. All rights reserved.
//

#import "XYQiuShiTemplateView.h"
#import "AFHTTPRequestOperationManager.h"
#import "ContentModal.h"
#import "ContentListCell.h"
#import "XYNodeManager.h"
#import "PullTableView.h"
#import "XYProgressView.h"
#import <AVFoundation/AVFoundation.h>
static NSString* CellIdentifier=@"CellIdentifier";
@interface XYQiuShiTemplateView()<PullTableViewDelegate,UITableViewDelegate,UITableViewDataSource,NSURLConnectionDataDelegate>
{
    BOOL isWaiting;
    BOOL isRefreshing;
}
@property (strong, nonatomic) IBOutlet PullTableView *tableview;
@property(nonatomic,strong)NSMutableArray* mdataSource;
@property(nonatomic,assign)NSInteger page;
@end
@implementation XYQiuShiTemplateView
-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super initWithCoder:aDecoder]) {
        
           }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        [self  loadXibFinish];
        
    }
    return self;
}
-(void)setTheURLString:(NSString *)theURLString
{
    if (![_theURLString isEqualToString:theURLString]) {
        _theURLString=[theURLString copy];
        [self refreshData:NO];
    }
    
}
#pragma -mark 框架方法
-(void)loadXibFinish
{
    isWaiting=NO;
    isRefreshing=NO;
    [self initcontrol];
}
-(void)prepareDismiss
{
    [self stopWaiting];//如果之前开始了等待动画，再离开多时候要关掉，如果美开始，就不影响其他页面的等待
}
-(void)didDismiss
{
}
-(void)prepareDispaly
{
    UIImageView* imageV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo"]];
    setCurrentNaviTitleView(imageV);
}
-(void)didDispaly
{

}
#pragma -mark  控件与数据刷新方法
-(void)initcontrol
{
    if (_tableview==nil) {
        _tableview=[[PullTableView alloc] initWithFrame:self.bounds];
        _tableview.delegate=self;
        _tableview.dataSource=self;
        _tableview.pullDelegate=self;
        [self addSubview:_tableview];
    }
    self.tableview.pullArrowImage=[UIImage imageNamed:@"blackArrow"];
    self.tableview.tableFooterView=[[UIView alloc] initWithFrame:CGRectZero];
    [_tableview registerClass:[ContentListCell class] forCellReuseIdentifier:CellIdentifier];
    self.mdataSource=[[NSMutableArray alloc] init];
    
  //  [self performSelector:@selector(pullTableViewDidTriggerRefresh:) withObject:nil afterDelay:1];
}
-(void)startWaiting
{
    if (!isWaiting) {
        [[XYHelper shareHelper] startWaitAnimation];
        isWaiting=YES;
    }
}
-(void)stopWaiting
{
    if (isWaiting) {
        [[XYHelper shareHelper] stopWaitAnimation];
        isWaiting=NO;
    }
}

- (void)refreshData:(BOOL)isLoadMore
{
    if (!isRefreshing) {
        isRefreshing=YES;
    }
    else
    {
        return;
    }
    [self startWaiting];
    if (isLoadMore) {
        _page++;
    }
    else
    {
        _page=1;
    }
    AFHTTPRequestOperationManager* managers=  [AFHTTPRequestOperationManager manager];
    NSString* str=[NSString stringWithFormat:@"http://m2.qiushibaike.com/article/list/%@?count=30&page=%d",self.theURLString,_page];
    self.tableview.pullTableIsRefreshing=YES;
    NSURLRequest* request=[NSURLRequest requestWithURL:[NSURL URLWithString:str]];
    AFHTTPRequestOperation* oper=[managers HTTPRequestOperationWithRequest:request success:
                                  ^(AFHTTPRequestOperation *operation, id responseObject)
                                  {
                                      NSDictionary * dic=[[NSDictionary alloc]initWithDictionary:responseObject];
                                      [self LoadSuccess:dic];
                                  } failure:^(AFHTTPRequestOperation *operation, NSError *error)
                                  {
                                      [self loadFailed:error];
                                  }];

    [oper start];
}
-(void)LoadSuccess:(NSDictionary*)dic
{
    NSLog(@"最新%@",dic);
    [self fillTheData:dic];
    isRefreshing=NO;
}
-(void)loadFailed:(NSError*)error
{
     NSLog(@"%@",error);
     [self stopWaiting];
     isRefreshing=NO;
    self.tableview.pullTableIsRefreshing = NO;
}
-(void)fillTheData:(NSDictionary*)dic
{
    if ([dic[@"err"] integerValue ]==0) {
        _page=[dic[@"page"] integerValue];
        NSArray* ary=[NSArray arrayWithArray:dic[@"items"]];
        if (_page==1&&[ary count]>0) {
            [self.mdataSource removeAllObjects];
        }
        for (NSDictionary* tem in ary) {
            detailItemData* item=[[detailItemData alloc]initWithDictionary:tem];
            [self.mdataSource addObject:item];
            
        }
        
            [self.tableview reloadData];
        }
    else
        {
          
           [[XYHelper shareHelper] showTips:dic[@"err_msg"]];      
        }
    [self stopWaiting];
    self.tableview.pullLastRefreshDate = [NSDate date];
    self.tableview.pullTableIsRefreshing = NO;
    self.tableview.pullTableIsLoadingMore=NO;
}
#pragma -mark 事件响应方法
-(void)gotoUserInforView:(UITapGestureRecognizer*)gesture
{
    CGPoint position=[gesture locationInView:_tableview];
    NSIndexPath* index=[_tableview indexPathForRowAtPoint:position];
    detailItemData* modal=_mdataSource[index.row];
    NSMutableDictionary* dic=[NSMutableDictionary dictionaryWithCapacity:1];
    if(modal.userData.userID)
    {
        [dic setObject:modal.userData.userID forKey:@"userID"];
        gotoPage(1020, dic);
    }
}
-(void)cellButtonAction:(id)sender
{
    UIButton* btn=(UIButton*)sender;
    id cell=[[btn superview] superview];
    if ([cell isKindOfClass: [ContentListCell class]]) {
        ContentListCell*  curCell=(ContentListCell*)cell;
        NSIndexPath* curIndexPath=[_tableview indexPathForCell:curCell];
        detailItemData* modal=_mdataSource[curIndexPath.row];
        switch (btn.tag) {
            case 1:
            {
                    [curCell.smile setBackgroundImage:[UIImage imageNamed:@"like2Selected"] forState:UIControlStateNormal];
                    [curCell.cry setBackgroundImage:[UIImage imageNamed:@"unlike2"] forState:UIControlStateNormal];
                    curCell.smile.userInteractionEnabled=NO;
                    curCell.cry.userInteractionEnabled=YES;
                    modal.selectType=1;
                    [UIView animateWithDuration:0.5 animations:^{
                        curCell.smile.transform=CGAffineTransformMakeScale(4, 4);
                    }];
                    [UIView animateWithDuration:0.5 animations:^{
                         curCell.smile.transform=CGAffineTransformIdentity;
                    }];
                    [curCell setLikeAndCommentLabelWithLikeNumber:curCell.numberLike+1 andComment:curCell.numberComment];
                
                //                    [UIView animateWithDuration:0.3 animations:^{curCell.smile.transform=CGAffineTransformMakeScale(1.5, 1.5);} completion:^(BOOL finished) {
//                        curCell.smile.transform=CGAffineTransformMakeScale(1, 1);
//                    }] ;这种方法动画不流畅，缩小的动画不好看
                   
                
                
            }
                break;
                
           case 2:
            {
                [curCell.cry setBackgroundImage:[UIImage imageNamed:@"unlike2Selected"] forState:UIControlStateNormal];
                [curCell.smile setBackgroundImage:[UIImage imageNamed:@"like2"] forState:UIControlStateNormal];
                curCell.smile.userInteractionEnabled=YES;
                curCell.cry.userInteractionEnabled=NO;
                modal.selectType=2;
                    [UIView animateWithDuration:0.5 animations:^{
                        curCell.cry.transform=CGAffineTransformMakeScale(4, 4);
                    }];
                    [UIView animateWithDuration:0.5 animations:^{
                        curCell.cry.transform=CGAffineTransformIdentity;
                    }];
                    [curCell setLikeAndCommentLabelWithLikeNumber:curCell.numberLike-1 andComment:curCell.numberComment];
                
            }

                break;
        }
        
    }
    else
        NSLog(@"未知类型的控件");
}

#pragma mark - UITableViewDataSource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    CGFloat height=[(detailItemData*)_mdataSource[indexPath.row] appropriateHeight];
    return height;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.mdataSource count];
}
-(void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContentListCell* contentCell=(ContentListCell*)cell;
    [contentCell removePlayer];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary* data=[[NSMutableDictionary alloc]initWithObjectsAndKeys:_mdataSource[indexPath.row],@"modal" ,nil];
    
        UITableViewCell* theCell=[tableView cellForRowAtIndexPath:indexPath];
        ContentListCell* contentCell=(ContentListCell*)theCell;
        [contentCell removePlayer];
        gotoPage(1015, data);
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    detailItemData* modal=_mdataSource[indexPath.row];
    ContentListCell* cell=(ContentListCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell==nil) {
        cell=[[ContentListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    //NSLog(@"contentURLString:%@",contentURLString);
    [cell fillTheContent:modal];
    //设置头像和配图
    [cell setCellImageWithModal:modal];
    //  cell.contentView.backgroundColor=[UIColor blackColor];
    [cell.smile addTarget:self action:@selector(cellButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.cry addTarget:self action:@selector(cellButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.comment addTarget:self action:@selector(cellButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UITapGestureRecognizer* tapGestur= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gotoUserInforView:)];
    [cell.portrait addGestureRecognizer:tapGestur];
    if(modal.high_url.length>10)//如果有视频的话
    {
        [cell.playerView replacePlayerItemWithVideoURLString:modal.high_url];//切换视频
    }
    return cell;
}
#pragma mark - PullTableViewDelegate
//xib中拖代理
- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    [self refreshData:NO];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
    [self refreshData:YES];
}

@end
