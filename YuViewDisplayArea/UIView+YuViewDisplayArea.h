//
//  UIView+YuViewDisplayArea.h
//  YuViewDisplayArea
//
//  Created by niuyulong on 2018/10/16.
//  Copyright © 2018年 nyl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (YuViewDisplayArea)
/**
 @brief 判断当前视图是否显示在当前KeyWindow上
 
 备注：
 
 还有一个有局限的系统方法，可以判断是否展示在当前屏幕上。
 
 即 -(UIWindow)window;方法。但该方法有所限制，需要界面已经展示完成后，才能获取到window值。比如，在viewWillAppear中获取页面子视图的window值，则会获取到nil。
 
 而本方法无该限制。
 */
- (BOOL)yu_isDisplayedInKeyWindow;

/**
 判断当前视图是否显示在view上。即两个视图的交集为空时，返回NO。

 @param view 目标视图,view 为空时，默认为KeyWindow
 */
- (BOOL)yu_isDisplayedInView:(UIView *)view;

/**
 获取当前视图在view上展示的比例

 @param view 目标视图
 @return 展示的比例。如0.5，即展示了50%。 如过当前视图，没有展示在view中，则返回0。
 */
- (CGFloat)yu_displayedPrecentInView:(UIView *)view;

/**
 获取当前视图在view内部坐标系中的位置

 @param view 目标视图
 @return 在view内部坐标系中的位置。如过当前视图，没有展示在view中，则返回CGRectNull。
 */
- (CGRect)yu_locationInView:(UIView *)view;
@end

@interface UIView (YuViewDisplayArea_Superview)

/// 在当前视图的事件传递链中寻找指定类型的节点
- (UIView *)yu_firstSuperviewWithClass:(Class)aClass;
/// 在当前视图的事件传递链中寻找所有指定类型的节点
- (NSArray <UIView *>*)yu_superviewsWithClass:(Class)aClass;
/// 在当前视图的事件传递链中寻找指定类型的节点
- (NSArray *)yu_superviewsWithClasses:(NSArray <Class>*)classes;
/// 在当前视图的事件传递链中寻找指定类型的节点
- (NSArray *)yu_superviewsWithClassNames:(NSArray <NSString *>*)classNames;

#pragma mark └ All Superviews

/// 在当前视图的事件传递链中节点的集合
- (NSArray <UIView *>*)yu_AllSuperviews;
/// 获取当前视图在事件传递链中所有节点上的展示比例的最小值
- (CGFloat)yu_minDisplayedPrecentInAllSuperviews;
@end


@interface UIView (YuViewDisplayArea_Responder)

/// 在当前视图的事件传递链中寻找指定类型的节点
- (UIResponder *)yu_firstResponderWithClass:(Class)aClass;

/// 在当前视图的事件传递链中寻找所有指定类型的节点
- (NSArray <UIResponder *>*)yu_respondersWithClass:(Class)aClass;
/**
 在当前视图的事件传递链中寻找指定类型的节点
 
 @param classNames 节点类型的字符串格式集合，如 @[@"UIView",@"UIViewController"]。
 @return 节点的集合，可能为空集
 */
- (NSArray *)yu_respondersWithClassNames:(NSArray <NSString *>*)classNames;
/**
 在当前视图的事件传递链中寻找指定类型的节点
 
 @param classes 节点的类型集合，如 @[[UIView class],[UIViewController class]]
 @return 节点的集合，可能为空集
 */
- (NSArray *)yu_respondersWithClasses:(NSArray <Class>*)classes;

/// 在当前视图的事件传递链中节点的集合
- (NSArray <UIResponder *>*)yu_AllResponders;

#pragma mark └ CurrentViewController
/**
 获取当前视图对应的视图控制器
 
 @return UIViewController 可能为空
 */
- (UIViewController *)yu_currentViewController;

/**
 获取当前视图对应的视图控制器中的根视图
 
 @return currentViewController.view 可能为空
 */
- (UIView *)yu_viewOfViewController;

@end

