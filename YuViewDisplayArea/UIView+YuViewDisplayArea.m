//
//  UIView+YuViewDisplayArea.m
//  YuViewDisplayArea
//
//  Created by niuyulong on 2018/10/16.
//  Copyright © 2018年 nyl. All rights reserved.
//

#import "UIView+YuViewDisplayArea.h"

@implementation UIView (YuViewDisplayArea)
/// 判断当前视图是否显示在当前KeyWindow上
- (BOOL)yu_isDisplayedInKeyWindow {
    return [self yu_isDisplayedInView:nil];
}

- (BOOL)yu_isDisplayedInView:(UIView *)view {
    // 若view 隐藏
    if (self.hidden) return NO;
    
    // 若没有superview
    if (self.superview == nil) return NO;
    
    // 若视图面积为0
    if (self.frame.size.width == 0 || self.frame.size.height == 0) return NO;
    
    UIView *targetView = view?:[UIApplication sharedApplication].keyWindow;
    
    // 转换 self在View上的Rect
    CGRect rect = [self convertRect:self.bounds toView:targetView];
    if (CGRectIsEmpty(rect) || CGRectIsNull(rect)) {
        return NO;
    }
    // 若size为CGrectZero
    if (CGSizeEqualToSize(rect.size, CGSizeZero)) return NO;
    // 获取 self在View上的 交叉的 Rect
    CGRect intersectionRect = CGRectIntersection(rect, targetView.bounds);
    if (CGRectIsEmpty(intersectionRect) || CGRectIsNull(intersectionRect)) {
        return NO;
    }
    
    return YES;
}

- (CGFloat)yu_displayedPrecentInView:(UIView *)view {
    
    BOOL display = [self yu_isDisplayedInView:view];
    if (!display) {
        return 0;
    }
    
    UIView *targetView = view?:[UIApplication sharedApplication].keyWindow;
    
    // 转换 self在View上的Rect
    CGRect rect = [targetView convertRect:self.bounds fromView:self];
    // 获取 self在View上的 交叉的 Rect
    CGRect intersectionRect = CGRectIntersection(rect, targetView.bounds);
    
    CGFloat fullArea = rect.size.width * rect.size.height;
    CGFloat intersectionArea = intersectionRect.size.width * intersectionRect.size.height;
    
    if (fullArea == 0 || intersectionArea == 0) {
        return 0;
    } else {
        CGFloat showPrecent = intersectionArea / fullArea;
        showPrecent = round(showPrecent * 100)/100.0;
        NSAssert(showPrecent >=0, @"出现负数了");
        return showPrecent;
    }
}

- (CGRect)yu_locationInView:(UIView *)view {
    if (!view) {
        return CGRectNull;
    }
    BOOL display = [self yu_isDisplayedInView:view];
    if (!display) {
        return CGRectNull;
    }
    
    CGRect rect = [view convertRect:self.bounds fromView:self];
    return rect;
}

@end

@implementation UIView (YuViewDisplayArea_Superview)
/// 在当前视图的事件传递链中寻找指定类型的节点
- (UIView *)yu_firstSuperviewWithClass:(Class)aClass {
    UIView *target = self.superview;
    while (target) {
        if ([target isKindOfClass:aClass]) {
            break;
        }
        target = target.superview;
    }
    return target;
}
/// 在当前视图的事件传递链中寻找所有指定类型的节点
- (NSArray <UIView *>*)yu_superviewsWithClass:(Class)aClass {
    
    NSMutableArray *responders = [NSMutableArray array];
    
    UIView *target = self.superview;
    while (target) {
        if ([target isKindOfClass:aClass]) {
            [responders addObject:target];
        }
        target = target.superview;
    }
    return responders;
}
/// 在当前视图的事件传递链中寻找指定类型的节点
- (NSArray *)yu_superviewsWithClasses:(NSArray <Class>*)classes {
    NSMutableArray *arrayM = [NSMutableArray array];
    
    UIView *target = self.superview;
    while (target) {
        for (Class aClass in classes) {
            if ([target isKindOfClass:aClass]) {
                [arrayM addObject:target];
            }
        }
        target = target.superview;
    }
    return arrayM;
}
/// 在当前视图的事件传递链中寻找指定类型的节点
- (NSArray *)yu_superviewsWithClassNames:(NSArray <NSString *>*)classNames {
    NSMutableArray *classes = [NSMutableArray arrayWithCapacity:classNames.count];
    for (NSString *name in classNames) {
        Class aClass = NSClassFromString(name);
        [classes addObject:aClass];
    }
    
    NSArray *result = [self yu_superviewsWithClasses:classes];
    return result;
}

- (CGFloat)yu_minDisplayedPrecentInSuperviews:(NSArray <UIView *> *)superviews  {
    
    CGFloat result = 0;
    NSArray <NSNumber *>*array = [self yu_displayedPrecentsInSuperviews:superviews];
    for (int i = 0; i < array.count; i++) {
        CGFloat precent = [array[i] floatValue];
        if (i== 0) {
            result = precent;
        } else if (precent < result) {
            result = precent;
        }
    }
    return result;
}

- (NSArray <NSNumber *>*)yu_displayedPrecentsInSuperviews:(NSArray <UIView *> *)superviews  {
    
    NSArray *array = superviews;
    NSMutableArray *arrayM = [NSMutableArray arrayWithCapacity:array.count];
    for (UIView *superView in array) {
        CGFloat precent = [self yu_displayedPrecentInView:superView];
        [arrayM addObject:@(precent)];
    }
    return arrayM;
}

#pragma mark └ All Superviews

- (NSArray<UIView *> *)yu_AllSuperviews {
    
    NSMutableArray *arrayM = [NSMutableArray array];
    UIView *target = self.superview;
    while (target) {
        [arrayM addObject:target];
        target = target.superview;
    }
    return arrayM;
}

- (CGFloat)yu_minDisplayedPrecentInAllSuperviews {
    NSArray *superviews = [self yu_AllSuperviews];
    return [self yu_minDisplayedPrecentInSuperviews:superviews];
}

@end

@implementation UIView (YuViewDisplayArea_Responder)

- (UIResponder *)yu_firstResponderWithClass:(Class)aClass {
    
    UIResponder *target = self.nextResponder;
    while (target) {
        if ([target isKindOfClass:aClass]) {
            break;
        }
        target = target.nextResponder;
    }
    return target;
}

- (NSArray <UIResponder *>*)yu_respondersWithClass:(Class)aClass {
    
    NSMutableArray *responders = [NSMutableArray array];
    
    UIResponder *target = self.nextResponder;
    while (target) {
        if ([target isKindOfClass:aClass]) {
            [responders addObject:target];
        }
        target = target.nextResponder;
    }
    return responders;
}

- (NSArray *)yu_respondersWithClassNames:(NSArray *)classNames {
    NSMutableArray *classes = [NSMutableArray arrayWithCapacity:classNames.count];
    for (NSString *name in classNames) {
        Class aClass = NSClassFromString(name);
        [classes addObject:aClass];
    }
    
    NSArray *result = [self yu_respondersWithClasses:classes];
    return result;
}

- (NSArray *)yu_respondersWithClasses:(NSArray *)classes {
    NSMutableArray *arrayM = [NSMutableArray array];
    
    UIResponder *target = self.nextResponder;
    while (target) {
        for (Class aClass in classes) {
            if ([target isKindOfClass:aClass]) {
                [arrayM addObject:target];
            }
        }
        target = target.nextResponder;
    }
    return arrayM;
}


- (NSArray <UIResponder *> *)yu_AllResponders {
    NSMutableArray *arrayM = [NSMutableArray array];
    UIResponder *target = self.nextResponder;
    while (target) {
        [arrayM addObject:target];
        target = target.nextResponder;
    }
    return arrayM;
}

#pragma mark └ CurrentViewController

- (UIViewController *)yu_currentViewController {
    
    UIResponder *target = self.nextResponder;
    while (target) {
        if ([target isKindOfClass:[UIViewController class]]) {
            break;
        }
        target = target.nextResponder;
    }
    return (UIViewController *)target;
}

- (UIView *)yu_viewOfViewController {
    
    UIViewController *vc = [self yu_currentViewController];
    if (vc) {
        return vc.view;
    }
    return nil;
}

@end
