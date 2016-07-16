//
//  ViewController.m
//  ZmFMDB
//
//  Created by stone on 16/7/14.
//  Copyright © 2016年 zm. All rights reserved.
//

#import "ViewController.h"
#import "FMDBModel.h"
#import "HandleFMDB.h"
#import "AddRecordViewController.h"
#import "ShowResultController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,UISearchBarDelegate,UISearchResultsUpdating,UISearchControllerDelegate>
@property (nonatomic,strong)FMDBModel* model;
@property (nonatomic,strong)UITableView* tableView;
@property (nonatomic,strong)HandleFMDB* handle;
@property (nonatomic,strong)UISearchController* searchController;
@property (nonatomic,strong)ShowResultController* resultVC;

@end

@implementation ViewController
{
    NSInteger _indexPathRow;
}

-(ShowResultController *)resultVC{
    if (_resultVC == nil) {
        _resultVC = [[ShowResultController alloc]init];
    }
    return _resultVC;
}

-(UISearchController *)searchController{
    if (_searchController == nil) {
        _searchController = [[UISearchController alloc]initWithSearchResultsController:self.resultVC];
        _searchController.delegate = self;
        [_searchController.searchBar sizeToFit];
        _searchController.definesPresentationContext = YES;
        _searchController.searchResultsUpdater = self;
    }
    return _searchController;
}
#pragma mark UISearchResultsUpdating
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController{

    //从委托方中获取用户在文本框中的输入内容
    NSString* searchText = searchController.searchBar.text;

    NSArray* results = [self.handle searchByName:searchText];

    NSLog(@"%ld",results.count);
    self.resultVC.searchResults = results;
}

-(HandleFMDB *)handle{
    if (_handle == nil) {
        _handle = [HandleFMDB new];
    }
    return _handle;
}

-(UITableView *)tableView{

    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

-(FMDBModel *)model{
    if (_model == nil) {
        _model = [FMDBModel new];
    }
    return _model;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableHeaderView = self.searchController.searchBar;
    [self.tableView reloadData];
    [self configureNavi];
}

-(void)confirmAdd:(NSNotification*)notification{

    DDLogVerbose(@"我已近收到确认通知了");
    NSDictionary* userInfo = notification.userInfo;
    DDLogVerbose(@"%@",userInfo);
    self.model.name = userInfo[@"name"];
    self.model.sID = [userInfo[@"sID"] integerValue];
    self.model.sex = userInfo[@"sex"];
    self.model.age = [userInfo[@"age"] integerValue];
    [self.model insertData];
    [self.handle refreshData];
    [self.tableView reloadData];

}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"confirmAdd" object:nil];
}

-(void)configureNavi{
    UIBarButtonItem* item = [[UIBarButtonItem alloc]initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(edit:)];
    self.navigationItem.rightBarButtonItem = item;
}
-(void)edit:(UIBarButtonItem*)item{

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(confirmAdd:) name:@"confirmAdd" object:nil];
    AddRecordViewController* vc = [[AddRecordViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.handle.rowNum;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = [self.handle nameForRow:indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
-(void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  UITableViewCellEditingStyleDelete ;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        DDLogVerbose(@"执行删除操作");
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"确认删除吗" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [alert show];
        _indexPathRow = indexPath.row;
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {

        self.tableView.editing = NO;

    }else{

        [self.handle removeForRow:_indexPathRow];
        [self.handle refreshData];
        [self.tableView reloadData];
    }
}


-(void)dealloc{

}

@end
