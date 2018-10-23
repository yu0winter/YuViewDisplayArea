//
//  UIView+YuViewDisplayArea_Responder.h
//  YuViewDisplayArea
//
//  Created by niuyulong on 2018/10/23.
//  Copyright © 2018年 nyl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+YuViewDisplayArea.h"

@interface UIView (YuViewDisplayArea_Responder2)

/// 获取当前视图在所有节点上的展示比例的集合
- (NSArray <NSNumber *>*)yu_displayedPrecentsInResonders:(NSArray <UIResponder *> *)responders;

/// 获取当前视图在所有节点上的展示比例的最小值
- (CGFloat)yu_minDisplayPrecentInResonders:(NSArray <UIResponder *>*)responders;

#pragma mark └ All Responders

/// 在当前视图的事件传递链中节点的集合
- (NSArray <UIResponder *>*)yu_AllResponders;

/// 获取当前视图在事件传递链中所有节点上的展示比例的最小值
- (CGFloat)yu_minDisplayedPrecentInAllResonders;

#pragma mark └ Key Responders
/**
 事件传递链中影响屏幕显示较大的类
 
 @return @[[UITableView class],
 [UICollectionView class],[UIViewController class],[UIWindow class]]
 */
- (NSArray <Class>*)yu_classesOfKeyResponders;
/**
 在当前视图的事件传递链中寻找指定类型的节点，节点类型为“事件传递链中影响屏幕显示较大的类”。可参考yu_classesOfKeyResponder方法
 
 @return 指定类型的节点的集合
 */
- (NSArray <UIResponder *>*)yu_KeyResponders;
/**
 获取当前视图在事件传递链中几个关键节点上的展示比例。节点类型参考yu_displayAreaClasses方法
 并返回最小展示比例
 
 @return 最小展示比例。数值区域：(0,1.0)
 */
- (CGFloat)yu_minDisplayedPrecentInKeyResponders;
@end
