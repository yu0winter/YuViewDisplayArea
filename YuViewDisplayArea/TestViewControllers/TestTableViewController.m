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
    
    self.tableView.frame = CGRectMake(0, 64 +50, 375, 675-64-100);
    self.tableView.layer.borderColor = [UIColor orangeColor].CGColor;
    self.tableView.layer.borderWidth = 5;
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
    for (UITableViewCell *cell in visibleCells) {
        CGFloat precent = [cell yu_minDisplayedPrecentInAllSuperviews];
        if (precent > 0.5) {
            cell.contentView.backgroundColor = [UIColor clearColor];
        } else {
            cell.contentView.backgroundColor = [UIColor colorWithWhite:0 alpha:1 - 2*precent];
        }
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f%%",precent *100];
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
        _tableView.clipsToBounds =NO;
        
//        _tableView.estimatedRowHeight = 0;
//        _tableView.estimatedSectionHeaderHeight = 0;
//        _tableView.estimatedSectionFooterHeight = 0;
    }
    return _tableView;
}
@end
