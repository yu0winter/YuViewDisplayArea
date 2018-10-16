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
    CGRect rect = [view convertRect:self.bounds fromView:self];
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
