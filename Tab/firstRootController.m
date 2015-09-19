//
//  firstRootControllerViewController.m
//  Tab
//
//  Created by zouxue on 15/7/26.
//  Copyright (c) 2015年 xiyou. All rights reserved.
//
static NSString* CellIdentifier=@"CellIdentifier";
#import "firstRootController.h"
#import "AFHTTPRequestOperationManager.h"
#import "contentModal.h"
#import "contentListCell.h"
#import "XYNodeManager.h"
@interface firstRootController ()<PullTableViewDelegate,UITableViewDelegate,NSURLConnectionDataDelegate>
- (IBAction)btnClick:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet PullTableView *tableview;
@property(nonatomic,strong)NSMutableArray* mdataSource;
@property(nonatomic,assign)NSInteger page;
@end

@implementation firstRootController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initcontrol];
    XYNodeManager* manager=[XYNodeManager shareNodeManager];
   // manager.naviNodesAry[0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)initcontrol
{
    UIView* headv=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 130)];
    self.tableview.tableHeaderView=headv;
   // headv.backgroundColor=[UIColor blackColor];
    self.tableview.pullArrowImage=[UIImage imageNamed:@"blackArrow"];
    UINib* nib=[UINib nibWithNibName:@"contentListCell" bundle:nil];
    [self.tableview registerNib:nib forCellReuseIdentifier:CellIdentifier];
    self.mdataSource=[[NSMutableArray alloc] init];
    
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)btnClick:(UIButton *)sender {
    _tableview.pullTableIsRefreshing=NO;
    
    AFHTTPRequestOperationManager* managers=  [AFHTTPRequestOperationManager manager];
    NSString* str=[NSString stringWithFormat:@"http://m2.qiushibaike.com/article/list/suggest?count=10&page=1"];
    self.tableview.pullTableIsRefreshing=YES;
    NSURLRequest* request=[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://m2.qiushibaike.com/article/list/suggest?count=10&page=1"]];
     AFHTTPRequestOperation* oper=[managers HTTPRequestOperationWithRequest:request success:
     ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSLog(@"%@",responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        NSLog(@"%@",error);
        self.tableview.pullTableIsRefreshing = NO;
    }];
    [oper start];
   
}
- (void)refreshData
{
    if (_page<=1) {
        _page=1;
    }
        AFHTTPRequestOperationManager* managers=  [AFHTTPRequestOperationManager manager];
        NSString* str=[NSString stringWithFormat:@"http://m2.qiushibaike.com/article/list/suggest?count=10&page=%d",_page];
        self.tableview.pullTableIsRefreshing=YES;
      //  NSURLRequest* request=[NSURLRequest requestWithURL:[NSURL URLWithString:str]];
     NSURLRequest* request=[NSURLRequest requestWithURL:[NSURL URLWithString:str]];//@"http://m2.qiushibaike.com/article/list/suggest?count=10&page=1"
         AFHTTPRequestOperation* oper=[managers HTTPRequestOperationWithRequest:request success:
         ^(AFHTTPRequestOperation *operation, id responseObject)
        {
            NSLog(@"%@",responseObject);
          NSDictionary * dic=[[NSDictionary alloc]initWithDictionary:responseObject];
            [self fillTheData:dic];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error)
        {
            NSLog(@"%@",error);
            self.tableview.pullTableIsRefreshing = NO;
        }];
        [oper start];
  }
-(void)fillTheData:(NSDictionary*)dic
{
    if (_page==1) {
        [self.mdataSource removeAllObjects];
    }
    _page=[dic[@"page"] integerValue];
    NSArray* ary=[NSArray arrayWithArray:dic[@"items"]];
    for (NSDictionary* tem in ary) {
       detailItemData* item=[[detailItemData alloc]initWithDictionary:tem];
        [self.mdataSource addObject:item];
        
    }
    
    [self.tableview reloadData];
    
    self.tableview.pullLastRefreshDate = [NSDate date];
    self.tableview.pullTableIsRefreshing = NO;
    self.tableview.pullTableIsLoadingMore=NO;
}
#pragma mark - UITableViewDataSource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    contentListCell* cell=[tableView cellForRowAtIndexPath:indexPath];
//    return cell.cellHeight;
    return 230;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.mdataSource count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    contentListCell* cell=(contentListCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    //cell.contentView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"1234"]];
    [cell fillTheContent:_mdataSource[indexPath.row]];
    
  //  cell.contentView.backgroundColor=[UIColor blackColor];
    
    return cell;
}

#pragma mark - PullTableViewDelegate
//xib中拖代理
- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    _page++;
    [self refreshData];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
    _page++;
    [self refreshData];
    //[self performSelector:@selector(loadMoreDataToTable) withObject:nil afterDelay:3.0f];
}
@end
