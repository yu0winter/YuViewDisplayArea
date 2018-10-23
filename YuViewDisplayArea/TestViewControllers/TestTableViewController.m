//
//  TestTableViewController.m
//  YuViewDisplayArea
//
//  Created by niuyulong on 2018/10/16.
//  Copyright © 2018年 nyl. All rights reserved.
//

#import "TestTableViewController.h"
#import "UIView+YuViewDisplayArea.h"

@interface TestTableViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UIButton *btn;
@property(nonatomic, strong) UILabel *label19;
@end

@implementation TestTableViewController
#pragma mark - Life Cycle 生命周期
#pragma mark └ Dealloc
// - (void)dealloc {}
#pragma mark └ Init
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSStringFromClass([self class]);
    
    self.tableView.frame = CGRectMake(0, 64, 375, 675-64);
    [self.view addSubview:self.tableView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"测试万次性能" style:UIBarButtonItemStyleDone target:self action:@selector(testPerformance)];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self scrollViewDidScroll:self.tableView];
}
#pragma mark - Event Response 事件响应
- (void)testPerformance {
    double start = [[NSDate date] timeIntervalSince1970]*1000;
    for (int i =0; i < 10000; i++) {
        [self scrollViewDidScroll:self.tableView];
    }
    double end = [[NSDate date] timeIntervalSince1970]*1000;
    NSLog(@"\n-------执行1万次查看性能--------");
    printf("start time = %f \n", start);
    printf("end time = %f \n", end);
    printf("use time = %f ms 毫秒 \n", (end-start));
    printf("use time per time =%f ms 毫秒 \n", (end-start)/10000.0);
}

#pragma mark - Delegate Realization 委托方法
#pragma mark └ UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSArray *visibleCells = self.tableView.visibleCells;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        // An object representing a cell of the table, or nil if the cell is not visible or indexPath is out of range.
        // 代表当前indexPath对应的Cell不可见，或者indexPath超出数据源的范围
    }
    [self.tableView.visibleCells.firstObject yu_minDisplayedPrecentInAllSuperviews];
    return;
    for (UITableViewCell *cell in visibleCells) {
//        NSLog(@"*********Cell:%@*********",cell.textLabel.text);
        [cell yu_minDisplayedPrecentInAllSuperviews];
        
//        UIView *view = cell.yu_viewOfViewController;
//        NSArray *array = [cell yu_targetRespondersWithDisplayAreaClasses];
//        CGFloat precent = [cell yu_displayedPrecentInView:self.tableView];
//        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f",precent];
//        [self.view yu_isDisplayedInKeyWindow];
//
//        for (UIResponder *responder in array) {
//            CGFloat precent;
//            if ([responder isKindOfClass:[UIView class]]) {
//                precent = [cell yu_displayedPrecentInView:(UIView *)responder];
//            } else if ([responder isKindOfClass:[UIViewController class]]) {
//                precent = [cell yu_displayedPrecentInView:((UIViewController *)responder).view];
//            }
//            NSLog(@"(%@,%.2f)",[responder class],precent);
//        }
    }
}

#pragma mark └ UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    
    if (indexPath.row ==19) {
        self.label19 = [[UILabel alloc] init];
        [cell.contentView addSubview:self.label19];
    }
    cell.textLabel.text = @(indexPath.row).stringValue;
    return cell;
}
#pragma mark - Custom Method    自定义方法
#pragma mark - Custom Accessors 自定义属性
- (UITableView *)tableView
{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, 375, 675-64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor lightGrayColor];
//        _tableView.estimatedRowHeight = 0;
//        _tableView.estimatedSectionHeaderHeight = 0;
//        _tableView.estimatedSectionFooterHeight = 0;
    }
    return _tableView;
}
@end
