//
//  PurePictureQiuShi.m
//  Tab
//
//  Created by zouxue on 15/9/11.
//  Copyright (c) 2015年 xiyou. All rights reserved.
//

#import "PurePictureQiuShi.h"
#import "XYQiuShiTemplateView.h"
static NSString* CellIdentifier=@"CellIdentifier";
@interface PurePictureQiuShi()
{
    BOOL isWaiting;
}
@property(nonatomic,strong)XYQiuShiTemplateView* qiuShiView;
@end
@implementation PurePictureQiuShi
-(void)loadXibFinish
{
    CGRect frame=self.bounds;
    frame.size.height-=140;
    _qiuShiView=[[XYQiuShiTemplateView alloc] initWithFrame:frame];
    _qiuShiView.theURLString=@"imgrank";
    [self addSubview:_qiuShiView];
}
-(void)prepareDispaly
{
    [_qiuShiView prepareDispaly];
}
-(void)didDispaly
{
    [_qiuShiView didDispaly];
}
-(void)prepareDismiss
{
    [_qiuShiView prepareDismiss];
}
-(void)didDismiss
{
    [_qiuShiView didDismiss];
}
@end

//@property (weak, nonatomic) IBOutlet PullTableView *tableview;
//@property(nonatomic,strong)NSMutableArray* mdataSource;
//@property(nonatomic,assign)NSInteger page;
//@end
//@implementation PurePictureQiuShi
//-(id)initWithCoder:(NSCoder *)aDecoder
//{
//    if (self=[super initWithCoder:aDecoder]) {
//        isWaiting=NO;
//    }
//    return self;
//}
//#pragma -mark 框架方法
//-(void)loadXibFinish
//{
//    
//    [self initcontrol];
//}
//-(void)prepareDismiss
//{}
//-(void)didDismiss
//{
//    [self stopWaiting];
//}
//-(void)prepareDispaly
//{
//    UIImageView* imageV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo"]];
//    setCurrentNaviTitleView(imageV);
//}
//-(void)defultBack
//{
//    
//}
//-(void)didDispaly
//{
//    
//}
//#pragma -mark 控件和数据刷新
//-(void)initcontrol
//{
//    self.tableview.pullArrowImage=[UIImage imageNamed:@"blackArrow"];
//    self.tableview.tableFooterView=[[UIView alloc] initWithFrame:CGRectZero];
//    [_tableview registerClass:[ContentListCell class] forCellReuseIdentifier:CellIdentifier];
//    self.mdataSource=[[NSMutableArray alloc] init];
//    
//    [self performSelector:@selector(pullTableViewDidTriggerRefresh:) withObject:nil afterDelay:1];
//}
//-(void)startWaiting
//{
//    if (!isWaiting) {
//        [[XYHelper shareHelper] startWaitAnimation];
//        isWaiting=YES;
//    }
//}
//-(void)stopWaiting
//{
//    if (isWaiting) {
//        [[XYHelper shareHelper] stopWaitAnimation];
//        isWaiting=NO;
//    }
//}
//
//- (void)refreshData
//{
//  
//    [self startWaiting];
//    if (_page<=1) {
//        _page=1;
//    }
//    AFHTTPRequestOperationManager* managers=  [AFHTTPRequestOperationManager manager];
//    NSString* str=PurePicURLString(30, (int)_page);
//    self.tableview.pullTableIsRefreshing=YES;
//    NSURLRequest* request=[NSURLRequest requestWithURL:[NSURL URLWithString:str]];
//    AFHTTPRequestOperation* oper=[managers HTTPRequestOperationWithRequest:request success:
//                                  ^(AFHTTPRequestOperation *operation, id responseObject)
//                                  {
//                                      NSDictionary * dic=[[NSDictionary alloc]initWithDictionary:responseObject];
//                                      [self fillTheData:dic];
//                                  } failure:^(AFHTTPRequestOperation *operation, NSError *error)
//                                  {
//                                      NSLog(@"%@",error);
//                                      [self stopWaiting];
//                                      self.tableview.pullTableIsRefreshing = NO;
//                                  }];
//    
//    [oper start];
//}
//-(void)fillTheData:(NSDictionary*)dic
//{
//    if ([dic[@"err"] integerValue]==0) {
//        _page=[dic[@"page"] integerValue];
//        NSArray* ary=[NSArray arrayWithArray:dic[@"items"]];
//        if (_page==1&&[ary count]>0) {
//            [self.mdataSource removeAllObjects];
//        }
//        for (NSDictionary* tem in ary) {
//            detailItemData* item=[[detailItemData alloc]initWithDictionary:tem];
//            [self.mdataSource addObject:item];
//            
//        }
//        
//        [self.tableview reloadData];
//    }
//    else
//    {
//         [[XYHelper shareHelper] showTips:dic[@"err_msg"]];
//    }
//    [self stopWaiting];
//    self.tableview.pullLastRefreshDate = [NSDate date];
//    self.tableview.pullTableIsRefreshing = NO;
//    self.tableview.pullTableIsLoadingMore=NO;
//}
//#pragma -mark 事件响应方法
//-(void)gotoUserInforView:(UITapGestureRecognizer*)gesture
//{
//    CGPoint position=[gesture locationInView:_tableview];
//    NSIndexPath* index=[_tableview indexPathForRowAtPoint:position];
//    detailItemData* modal=_mdataSource[index.row];
//    NSMutableDictionary* dic=[NSMutableDictionary dictionaryWithCapacity:1];
//    if(modal.userData.userID)
//    {
//        [dic setObject:modal.userData.userID forKey:@"userID"];
//        gotoPage(1020, dic);
//    }
//}
//
//-(void)cellButtonAction:(id)sender
//{
//    UIButton* btn=(UIButton*)sender;
//    id cell=[[btn superview] superview];
//    if ([cell isKindOfClass: [ContentListCell class]]) {
//        ContentListCell*  curCell=(ContentListCell*)cell;
//        NSIndexPath* curIndexPath=[_tableview indexPathForCell:curCell];
//        detailItemData* modal=_mdataSource[curIndexPath.row];
//        switch (btn.tag) {
//            case 1:
//            {
//                [curCell.smile setBackgroundImage:[UIImage imageNamed:@"like2Selected"] forState:UIControlStateNormal];
//                [curCell.cry setBackgroundImage:[UIImage imageNamed:@"unlike2"] forState:UIControlStateNormal];
//                curCell.smile.userInteractionEnabled=NO;
//                curCell.cry.userInteractionEnabled=YES;
//                modal.selectType=1;
//                [UIView animateWithDuration:0.5 animations:^{
//                    curCell.smile.transform=CGAffineTransformMakeScale(4, 4);
//                }];
//                [UIView animateWithDuration:0.5 animations:^{
//                    curCell.smile.transform=CGAffineTransformIdentity;
//                }];
//                [curCell setLikeAndCommentLabelWithLikeNumber:curCell.numberLike+1 andComment:curCell.numberComment];
//                
//                //                    [UIView animateWithDuration:0.3 animations:^{curCell.smile.transform=CGAffineTransformMakeScale(1.5, 1.5);} completion:^(BOOL finished) {
//                //                        curCell.smile.transform=CGAffineTransformMakeScale(1, 1);
//                //                    }] ;这种方法动画不流畅，缩小的动画不好看
//                
//                
//                
//            }
//                break;
//                
//            case 2:
//            {
//                [curCell.cry setBackgroundImage:[UIImage imageNamed:@"unlike2Selected"] forState:UIControlStateNormal];
//                [curCell.smile setBackgroundImage:[UIImage imageNamed:@"like2"] forState:UIControlStateNormal];
//                curCell.smile.userInteractionEnabled=YES;
//                curCell.cry.userInteractionEnabled=NO;
//                modal.selectType=2;
//                [UIView animateWithDuration:0.5 animations:^{
//                    curCell.cry.transform=CGAffineTransformMakeScale(4, 4);
//                }];
//                [UIView animateWithDuration:0.5 animations:^{
//                    curCell.cry.transform=CGAffineTransformIdentity;
//                }];
//                [curCell setLikeAndCommentLabelWithLikeNumber:curCell.numberLike-1 andComment:curCell.numberComment];
//                
//            }
//                
//                break;
//        }
//        
//    }
//    else
//        NSLog(@"未知类型的控件");
//}
//
//#pragma mark - UITableViewDataSource
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//    CGFloat height=[(detailItemData*)_mdataSource[indexPath.row] appropriateHeight];
//    return height;
//}
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}
//
//- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return [self.mdataSource count];
//}
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSMutableDictionary* data=[[NSMutableDictionary alloc]initWithObjectsAndKeys:_mdataSource[indexPath.row],@"modal" ,nil];
//    gotoPage(1015, data);
//}
//- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//    detailItemData* modal=_mdataSource[indexPath.row];
//    ContentListCell* cell=(ContentListCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
//    if (cell==nil) {
//        cell=[[ContentListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//    }
//    //NSLog(@"contentURLString:%@",contentURLString);
//    [cell fillTheContent:modal];
//    //设置头像和配图
//    [cell setCellImageWithModal:modal];
//    //  cell.contentView.backgroundColor=[UIColor blackColor];
//    [cell.smile addTarget:self action:@selector(cellButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//    [cell.cry addTarget:self action:@selector(cellButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//    [cell.comment addTarget:self action:@selector(cellButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//    UITapGestureRecognizer* tapGestur= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gotoUserInforView:)];
//    [cell.portrait addGestureRecognizer:tapGestur];
//    return cell;
//}
//#pragma mark - PullTableViewDelegate
////xib中拖代理
//- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
//{
//    _page=1;
//    [self refreshData];
//}
//
//- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
//{
//    _page++;
//    [self refreshData];
//    //[self performSelector:@selector(loadMoreDataToTable) withObject:nil afterDelay:3.0f];
//}
//
//@end
