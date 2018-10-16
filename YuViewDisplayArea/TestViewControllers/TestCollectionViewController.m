//
//  TestCollectionViewController.m
//  YuViewDisplayArea
//
//  Created by niuyulong on 2018/10/16.
//  Copyright © 2018年 nyl. All rights reserved.
//

#import "TestCollectionViewController.h"
#import "UIView+YuViewDisplayArea.h"

@interface TestCollectionViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property(nonatomic, assign) CGSize itemSize;
@property(nonatomic, strong) UIButton *btn;
@end

@implementation TestCollectionViewController
#pragma mark - Life Cycle 生命周期
#pragma mark └ Dealloc
// - (void)dealloc {}
#pragma mark └ Init
- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSStringFromClass([self class]);
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    [btn setTitle:@"testVertical" forState:UIControlStateNormal];
    [btn setTitle:@"testHorizontal" forState:UIControlStateSelected];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.btn = btn;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [self btnOnClick:self.btn];
}

#pragma mark - Event Response 事件响应
- (void)btnOnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    if (_collectionView) {
        [_collectionView removeFromSuperview];
        _collectionView = nil;
    }
    
    if (sender.selected) {
        [self testHorizontal];
    } else {
        [self testVertical];
    }
    
    [self.view addSubview:self.collectionView];
    [self.collectionView reloadData];
    // FixMe: 此处为何需要调用layoutIfNeeded方法，请看我的另外一篇文章？？？
    [self.collectionView layoutIfNeeded];
    [self scrollViewDidScroll:self.collectionView];
}
- (void)testVertical {
    self.flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.itemSize = CGSizeMake(300, 100);
    self.collectionView.frame = CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64);
}

- (void)testHorizontal {
    self.flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.itemSize = CGSizeMake(200, 100);
    self.collectionView.frame = CGRectMake(0, 64+20, self.view.bounds.size.width, 100);
}

- (void)testPerformance {
    double start = [[NSDate date] timeIntervalSince1970]*1000;
    for (int i =0; i < 10000; i++) {
        [self scrollViewDidScroll:self.collectionView];
    }
    double end = [[NSDate date] timeIntervalSince1970]*1000;
    NSLog(@"\n-------执行1万次查看性能--------");
    printf("start time = %f \n", start);
    printf("end time = %f \n", end);
    printf("use time = %f ms 毫秒 \n", (end-start));
    printf("use time per time =%f ms 毫秒 \n", (end-start)/10000.0);
}
#pragma mark - Delegate Realization 委托方法
#pragma mark └ UISCrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    for (UICollectionViewCell *cell in self.collectionView.visibleCells) {
        CGFloat precent = [cell yu_displayedPrecentInView:self.collectionView];
        UILabel *label = (UILabel *)[cell.contentView viewWithTag:99];
        if (!label) continue;
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
        label.text = [NSString stringWithFormat:@"%ld  %.2f",(long)indexPath.item,precent];
        [self.view yu_isDisplayedInKeyWindow];
    }
}
#pragma mark └ UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class]) forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithWhite:indexPath.row / 10.0 alpha:1];
    
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:99];
    if (!label) {
        label = [[UILabel alloc] initWithFrame:cell.contentView.bounds];
        label.textColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.8];
        label.textAlignment = NSTextAlignmentCenter;
        label.tag= 99;
        [cell.contentView addSubview:label];
    }
    label.text = @(indexPath.item).stringValue;
    
    return cell;
}

#pragma mark └ UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.itemSize;
}

#pragma mark - Custom Method    自定义方法
#pragma mark - Custom Accessors 自定义属性
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = self.view.backgroundColor;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 10.0f;
        flowLayout.minimumInteritemSpacing = 10.0f;
        _flowLayout = flowLayout;
    }
    return _flowLayout;
}

@end
