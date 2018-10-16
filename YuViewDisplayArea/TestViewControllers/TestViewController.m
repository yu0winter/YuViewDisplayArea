//
//  TestViewController.m
//  YuViewDisplayArea
//
//  Created by niuyulong on 2018/10/16.
//  Copyright © 2018年 nyl. All rights reserved.
//

#import "TestViewController.h"
#import "UIView+YuViewDisplayArea.h"

#define screenWidth [UIScreen mainScreen].bounds.size.width;
#define screenHeight [UIScreen mainScreen].bounds.size.height;

//打印日志
#ifndef __OPTIMIZE__

#define NSLog(format, ...) {\
NSString *file = [[NSString stringWithFormat:@"%s",__FILE__] lastPathComponent];\
NSString *printString = [NSString stringWithFormat:@"%s【--%@：%d--】 %@",__TIME__, file, __LINE__, [NSString stringWithFormat:format, ##__VA_ARGS__]];\
printf("%s\n", [printString UTF8String]);\
}

#else
#define NSLog(format, ...)
#endif


@interface TestViewController ()

@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *hiddenLabel;
@property (weak, nonatomic) IBOutlet UILabel *nosuperViewLabel;
@property(nonatomic, strong) NSArray *views;
@end

@implementation TestViewController
#pragma mark - Life Cycle 生命周期
#pragma mark └ Dealloc
// - (void)dealloc {}
#pragma mark └ Init
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSStringFromClass([self class]);
    self.hiddenLabel.hidden = YES;
    [self.nosuperViewLabel removeFromSuperview];
    self.views = @[self.label1,self.label2,self.label3,self.hiddenLabel,self.nosuperViewLabel];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    [btn setTitle:@"测试万次性能" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(testPerformance) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self testWindowOfSubView];
}
#pragma mark - Event Response 事件响应
- (void)testPerformance {
    double start = [[NSDate date] timeIntervalSince1970]*1000;
    for (int i =0; i < 10000; i++) {
        [self.label1 yu_isDisplayedInKeyWindow];
        [self.label1 yu_isDisplayedInView:self.label2];
        [self.label1 yu_locationInView:self.label2];
        [self.label1 yu_displayedPrecentInView:self.label2];
    }
    double end = [[NSDate date] timeIntervalSince1970]*1000;
    NSLog(@"\n-------执行1万次查看性能--------");
    printf("start time = %f \n", start);
    printf("end time = %f \n", end);
    printf("use time = %f ms 毫秒 \n", (end-start));
    printf("use time per time =%f ms 毫秒 \n", (end-start)/10000.0);
}

- (void)testWindowOfSubView {
    for ( int i = 0; i < self.views.count; i++) {
        UIView *view = self.views[i];
        //        NSLog(@"判断View是否显示在屏幕上%@",@([view isDisplayedInScreen]));
        NSLog(@"是否展示：%d，是否展示:%d,展示比例:%.2f",[view yu_isDisplayedInKeyWindow]
              ,[view yu_isDisplayedInView:self.view],[view yu_displayedPrecentInView:self.view]);
        NSLog(@"view.window=%@",view.window);
    }
    
    NSLog(@"[self.label1 locationInView:self.label2]:%@",NSStringFromCGRect([self.label1 yu_locationInView:self.label2]));
    
    NSLog(@"[self.label1 locationInView:self.label3]:%@",NSStringFromCGRect([self.label1 yu_locationInView:self.label3]));
    
    NSLog(@"[self.label1 locationInView:self.hiddenLabel]:%@",NSStringFromCGRect([self.label1 yu_locationInView:self.hiddenLabel]));
    NSLog(@"[self.label1 locationInView:self.nosuperViewLabel]:%@",NSStringFromCGRect([self.label1 yu_locationInView:self.nosuperViewLabel]));
}

- (void)testNosuperViewLabel {
    
    UIView *view = [UIView new];
    
    UILabel *label = self.nosuperViewLabel;
    [view addSubview:label];
    [label yu_isDisplayedInView:nil];
    NSLog(@"nosuperViewLabel:是否展示：%d，是否展示:%d",[label yu_isDisplayedInView:nil]
          ,[label yu_isDisplayedInView:nil]);
}

#pragma mark - Delegate Realization 委托方法
#pragma mark - Custom Method    自定义方法
#pragma mark - Custom Accessors 自定义属性
@end
