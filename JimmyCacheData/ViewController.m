//
//  ViewController.m
//  JimmyCacheData
//
//  Created by Lenwave on 2017/5/15.
//  Copyright © 2017年 jimmy. All rights reserved.
//

#import "ViewController.h"
#import "VTableViewCell.h"
#import "DataModel.h"
#import "LSPNetworkHelper.h"
#import "SVProgressHUD.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "SDWebImageManager.h"


#define WeakObj(o) __weak typeof(o) o##Weak = o

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(assign,nonatomic) int page;
/** 注释 */
@property(strong,nonatomic) NSMutableArray * dataAry;

@end

@implementation ViewController

- (NSMutableArray *)dataAry
{
    if (_dataAry  == nil) {
        _dataAry  = [[NSMutableArray  alloc] init];
    }
    return _dataAry ;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.rowHeight = 100;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self initDatas];
    }];
    
    
    self.tableView.mj_footer = [MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
        [self initMoreData];
    }];
    
    self.tableView.mj_footer.hidden = YES;
    
    
    NSLog(@"网络缓存大小 = %fMB",[LSPNetworkCache getAllHttpCacheSize]/1024/1024.f);
    
     [[SDWebImageManager sharedManager].imageCache getSize];
    
}

- (void)initData
{
    //检测网络状态
    WeakObj(self);
    [LSPNetworkHelper networkStatusWithBlock:^(LSPNetworkStatusType status) {
        switch (status) {
            case LSPNetworkStatusNotReachable || LSPNetworkStatusUnknown:{
                selfWeak.title = @"没有网络";
                //从缓存加载数据
                [selfWeak getNoInnetData];
                NSLog(@"%@", @"没有网络的时候要实时的监控");
                break;
            }
            case LSPNetworkstatusReachableWWAN:{
                selfWeak.title = @"蜂窝煤移动";
                [selfWeak getData];
            }
            case LSPNetworkStatusReachableWiFi:{
                selfWeak.title = @"WiFi";
                [selfWeak getData];
            }
            default:
                break;
        }
    }];
}


- (void)initDatas
{
    
    if ([LSPNetworkHelper isNetwork]) {
        [self getData];
    }else
    {
        [self getNoInnetData];
    }
}


- (void)initMoreData
{
    
    if ([LSPNetworkHelper isNetwork]) {
        [self getMoreData];
    }else
    {
        [self getNotMoreData];
    }
}

- (void)getData
{
    self.page = 1;
    NSString * url = [NSString stringWithFormat:@"http://mobile.ximalaya.com/mobile/discovery/v1/category/album?calcDimension=hot&categoryId=2&device=ios&pageId=%d&pageSize=20&status=0&tagName=%@", self.page, @"%E8%80%81%E6%AD%8C"];
    

    WeakObj(self);
    [LSPNetworkHelper GETWithURL:url parameters:nil responseCache:^(id responseCache) {

        NSLog(@" -- 缓存数据");
    } success:^(id responseObject) {
        [selfWeak.tableView.mj_header endRefreshing];
        NSLog(@" -- 网络数据 %@", responseObject);
        [selfWeak.dataAry removeAllObjects];
        for (NSDictionary * dict in responseObject[@"list"]) {
            DataModel * model = [DataModel mj_objectWithKeyValues:dict];
            [selfWeak.dataAry addObject:model];
        }
        [selfWeak.tableView reloadData];
        
    } failure:^(NSError *error) {
        NSLog(@"error = %@",error);
    }];
}

- (void)getNotMoreData
{
    NSString * url = [NSString stringWithFormat:@"http://mobile.ximalaya.com/mobile/discovery/v1/category/album?calcDimension=hot&categoryId=2&device=ios&pageId=%d&pageSize=20&status=0&tagName=%@", ++self.page, @"%E8%80%81%E6%AD%8C"];
    WeakObj(self);
    [LSPNetworkHelper GETWithURL:url parameters:nil responseCache:^(id responseCache) {
        [selfWeak.tableView.mj_footer endRefreshing];
        for (NSDictionary * dict in responseCache[@"list"]) {
            DataModel * model = [DataModel mj_objectWithKeyValues:dict];
            [selfWeak.dataAry addObject:model];
        }
        [selfWeak.tableView reloadData];
        
    } success:^(id responseObject) {
  
    } failure:^(NSError *error) {
        NSLog(@"error = %@",error);
    }];
}

- (void)getMoreData
{
    NSString * url = [NSString stringWithFormat:@"http://mobile.ximalaya.com/mobile/discovery/v1/category/album?calcDimension=hot&categoryId=2&device=ios&pageId=%d&pageSize=20&status=0&tagName=%@", ++self.page, @"%E8%80%81%E6%AD%8C"];
    
    WeakObj(self);
    [LSPNetworkHelper GETWithURL:url parameters:nil responseCache:^(id responseCache) {

    } success:^(id responseObject) {
        [selfWeak.tableView.mj_footer endRefreshing];
        for (NSDictionary * dict in responseObject[@"list"]) {
            DataModel * model = [DataModel mj_objectWithKeyValues:dict];
            [selfWeak.dataAry addObject:model];
        }
        [selfWeak.tableView reloadData];
        
    } failure:^(NSError *error) {
        NSLog(@"error = %@",error);
    }];
}

- (void)getNoInnetData
{
    self.page = 1;
    NSString * url = [NSString stringWithFormat:@"http://mobile.ximalaya.com/mobile/discovery/v1/category/album?calcDimension=hot&categoryId=2&device=ios&pageId=%d&pageSize=20&status=0&tagName=%@", self.page, @"%E8%80%81%E6%AD%8C"];
    WeakObj(self);
    [LSPNetworkHelper GETWithURL:url parameters:nil responseCache:^(id responseCache) {
        [selfWeak.tableView.mj_header endRefreshing];
        [selfWeak.dataAry removeAllObjects];
        for (NSDictionary * dict in responseCache[@"list"]) {
            DataModel * model = [DataModel mj_objectWithKeyValues:dict];
            [selfWeak.dataAry addObject:model];
        }
        [selfWeak.tableView reloadData];
        
    } success:^(id responseObject) {
        [SVProgressHUD showWithStatus:@"缓存成功"];
        
    } failure:^(NSError *error) {
        NSLog(@"error = %@",error);
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataAry.count != 0) {
        self.tableView.mj_footer.hidden = NO;
    }
    return self.dataAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * idStr = @"Cell_id";
    VTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:idStr];
    if (!cell) {
        cell = [[VTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idStr];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.model = (DataModel *)self.dataAry[indexPath.row];
    
    
    return cell;
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
