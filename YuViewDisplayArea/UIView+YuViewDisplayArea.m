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


- (UIResponder *)yu_targetResponderWithClass:(Class)aClass {
    
    UIResponder *target = self.nextResponder;
    while (target) {
        if ([target isKindOfClass:aClass]) {
            break;
        }
        target = target.nextResponder;
    }
    return target;
}

- (NSArray *)yu_displayAreaClasses {
    return @[
             [UITableView class]
             ,[UICollectionView class]
             ,[UIViewController class]
             ,[UIWindow class]
             ];
}

- (NSArray *)yu_targetRespondersWithClassNames:(NSArray *)classNames {
    NSMutableArray *classes = [NSMutableArray arrayWithCapacity:classNames.count];
    for (NSString *name in classNames) {
        Class aClass = NSClassFromString(name);
        [classes addObject:aClass];
    }
    
    NSArray *result = [self yu_targetRespondersWithClasses:classes];
    return result;
}

- (NSArray *)yu_targetRespondersWithClasses:(NSArray *)classes {
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

- (NSArray *)yu_targetRespondersWithDisplayAreaClasses {
    NSArray *classes = [self yu_displayAreaClasses];
    return [self yu_targetRespondersWithClasses:classes];
}

- (CGFloat)yu_minPrecentDisplayedInNextResponders {
    
    NSArray *array = [self yu_targetRespondersWithDisplayAreaClasses];
    NSMutableArray *arrayM = [NSMutableArray arrayWithCapacity:array.count];
    for (UIResponder *responder in array) {
        CGFloat precent;
        if ([responder isKindOfClass:[UIView class]]) {
            precent = [self yu_displayedPrecentInView:(UIView *)responder];
        } else if ([responder isKindOfClass:[UIViewController class]]) {
            precent = [self yu_displayedPrecentInView:((UIViewController *)responder).view];
        } else {
            continue;
        }
        [arrayM addObject:@(precent)];
    }
    
    CGFloat result = 0;
    for (int i = 0; i < arrayM.count; i++) {
        CGFloat precent = [(NSNumber *)arrayM[i] floatValue];
        if (i== 0) {
            result = precent;
        }
        else if (precent < result) {
            result = precent;
        }
    }
    return result;
}

@end
