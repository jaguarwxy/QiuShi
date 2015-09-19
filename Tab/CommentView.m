//
//  first02.m
//  Tab
//
//  Created by zouxue on 15/8/16.
//  Copyright (c) 2015年 xiyou. All rights reserved.
//

#import "CommentView.h"
#import "AFHTTPRequestOperationManager.h"
#import "ContentModal.h"
#import "ContentListCell.h"
#import "XYNodeManager.h"
#import "PullTableView.h"
#import "CommentCell.h"
static NSString* CellIdentifier=@"CellIdentifier";
static NSString* commentCellIdentifier=@"commentCellIdentifier";
@interface CommentView()<PullTableViewDelegate,UITableViewDelegate,NSURLConnectionDataDelegate>
{
   BOOL isWaiting;
}
@property (weak, nonatomic) IBOutlet PullTableView *tableview;
@property(nonatomic,strong)NSMutableArray* mdataSource;
@property(nonatomic,assign)NSInteger page;
@property(nonatomic,strong)detailItemData* modal;
@end
@implementation CommentView
-(id)initWithCoder:(NSCoder *)aDecoder
{
     
    if (self=[super initWithCoder:aDecoder]) {
        isWaiting=NO;
    }
    return self;
}
-(void)prepareDismiss
{
    setCurrentNaviTitle(nil);

    [self stopWaiting];//如果之前开始了等待动画，再离开多时候要关掉，如果美开始，就不影响其他页面的等待
}
-(void)loadXibFinish
{
    [self initcontrol];
}
-(void)didDismiss
{}
-(void)prepareDispaly
{
    if ([_data[@"modal"] isKindOfClass:[detailItemData class]]) {
        _modal=_data[@"modal"];
        NSString* title=[NSString stringWithFormat:@"糗事%@",_modal.itemId ];
        setCurrentNaviTitle(title);
    }
    _tableview.contentOffset=CGPointMake(0, 0);
    [self refreshData];
}
-(void)didDispaly
{
    
}
-(void)initcontrol
{
    self.tableview.pullArrowImage=[UIImage imageNamed:@"blackArrow"];
    [_tableview registerClass:[ContentListCell class] forCellReuseIdentifier:CellIdentifier];
    [_tableview registerClass:[CommentCell class] forCellReuseIdentifier:commentCellIdentifier];
    _tableview.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    self.mdataSource=[[NSMutableArray alloc] init];
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

- (void)refreshData
{
    [self startWaiting];
    if (_page<=1) {
        _page=1;
    }
    AFHTTPRequestOperationManager* managers=  [AFHTTPRequestOperationManager manager];
    self.tableview.pullTableIsRefreshing=YES;
    NSURLRequest* request=[NSURLRequest requestWithURL:[NSURL URLWithString:detailURLSring(_modal.itemId, 50, (int)_page)]];
    AFHTTPRequestOperation* oper=[managers HTTPRequestOperationWithRequest:request success:
                                  ^(AFHTTPRequestOperation *operation, id responseObject)
                                  {
                                      NSLog(@"%@",responseObject);
                                      NSDictionary * dic=[[NSDictionary alloc]initWithDictionary:responseObject];
                                      [self fillTheData:dic];
                                  } failure:^(AFHTTPRequestOperation *operation, NSError *error)
                                  {
                                      NSLog(@"%@",error);
                                      [self stopWaiting];
                                      self.tableview.pullTableIsRefreshing = NO;
                                  }];
    [oper start];
}
-(void)fillTheData:(NSDictionary*)dic
{
    if ([dic[@"err"] integerValue]==0) {
        _page=[dic[@"page"] integerValue];
           NSArray* ary=[NSArray arrayWithArray:dic[@"items"]];
         if (_page==1) {
            [self.mdataSource removeAllObjects];
        }
        for (NSDictionary* tem in ary) {
            commentDetail* item=[[commentDetail alloc]initWithDictionary:tem];
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
-(void)gotoUserInforView:(UITapGestureRecognizer*)gesture
{
    CGPoint position=[gesture locationInView:_tableview];
    NSIndexPath* index=[_tableview indexPathForRowAtPoint:position];
    NSString* userID;
    if(index.row==0)
    {
        userID=[NSString stringWithFormat:@"%@",_modal.userData.userID];
    }
    else{
       detailItemData* modal=_mdataSource[index.row-1];
    
        userID=[NSString stringWithFormat:@"%@",modal.userData.userID];
    }
    NSMutableDictionary* dic=[NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:userID forKey:@"userID"];
    gotoPage(1020, dic);
}

-(void)cellButtonAction:(id)sender
{
    UIButton* btn=(UIButton*)sender;
    id cell=[[btn superview] superview];
    if ([cell isKindOfClass: [ContentListCell class]]) {
        ContentListCell*  curCell=(ContentListCell*)cell;
        //NSIndexPath* curIndexPath=[_tableview indexPathForCell:curCell];
        detailItemData* modal=_modal;//_mdataSource[curIndexPath.row];
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
    //第一行是糗事，后面的是评论
    if (indexPath.row==0) {
        return _modal.appropriateHeight;
    }
   else
       
   {
       NSInteger i=indexPath.row-1;
       
       if ([_mdataSource count]>i) {
           commentDetail* modal= (commentDetail*)_mdataSource[i];
           return  modal.appropriateHeight;
       }
       else
           return 0;
       
   }
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.mdataSource count]+1;
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        ContentListCell* cell=(ContentListCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        if (cell==nil) {
            cell=[[ContentListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        //NSLog(@"contentURLString:%@",contentURLString);
        [cell fillTheContent:_modal];
        //设置头像和配图
        [cell setCellImageWithModal:_modal];
        [cell.smile addTarget:self action:@selector(cellButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.cry addTarget:self action:@selector(cellButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.comment addTarget:self action:@selector(cellButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        UITapGestureRecognizer* tapGestur= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gotoUserInforView:)];
        [cell.portrait addGestureRecognizer:tapGestur];
        return cell;
    }
    else
    {
        CommentCell* comentCell=(CommentCell*)[tableView dequeueReusableCellWithIdentifier:commentCellIdentifier forIndexPath:indexPath];
        if (comentCell==nil) {
            comentCell=[[CommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:commentCellIdentifier];
        }
        NSInteger i=indexPath.row-1;
        if (i<[_mdataSource count]) {
            commentDetail* modal=_mdataSource[i];
            [comentCell fillTheContent: modal];
            [comentCell PortraitImageInComentCell:modal];
            
        }
        UITapGestureRecognizer* tapGestur= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gotoUserInforView:)];
        [comentCell.portrait addGestureRecognizer:tapGestur];
        return comentCell;
    }
    
   
   
}
#pragma mark - PullTableViewDelegate
//xib中拖代理
- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    _page=1;
   [self refreshData];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
    _page++;
    [self refreshData];
    //[self performSelector:@selector(loadMoreDataToTable) withObject:nil afterDelay:3.0f];
}

@end
