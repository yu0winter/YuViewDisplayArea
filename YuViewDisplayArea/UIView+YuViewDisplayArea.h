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
