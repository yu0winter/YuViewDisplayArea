//
//  UIView+YuViewDisplayArea_Responder.m
//  YuViewDisplayArea
//
//  Created by niuyulong on 2018/10/23.
//  Copyright © 2018年 nyl. All rights reserved.
//

#import "UIView+YuViewDisplayArea_Responder2.h"

@implementation UIView (YuViewDisplayArea_Responder2)
- (NSArray <NSNumber *>*)yu_displayedPrecentsInResonders:(NSArray <UIResponder *> *)responders  {
    
    NSArray *array = responders;
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
    return arrayM;
}

- (CGFloat)yu_minDisplayPrecentInResonders:(NSArray <UIResponder *> *)responders  {
    
    CGFloat result = 0;
    NSArray <NSNumber *>*array = [self yu_displayedPrecentsInResonders:responders];
    for (int i = 0; i < array.count; i++) {
        CGFloat precent = [array[i] floatValue];
        if (i== 0) {
            result = precent;
        }
        else if (precent < result) {
            result = precent;
        }
    }
    return result;
}

#pragma mark └ All Responders

- (NSArray <UIResponder *> *)yu_AllResponders {
    NSMutableArray *arrayM = [NSMutableArray array];
    UIResponder *target = self.nextResponder;
    while (target) {
        [arrayM addObject:target];
        target = target.nextResponder;
    }
    return arrayM;
}

- (CGFloat)yu_minDisplayedPrecentInAllResonders {
    NSArray *array = [self yu_AllResponders];
    return [self yu_minDisplayPrecentInResonders:array];
}

#pragma mark └ Key Responders

- (NSArray *)yu_classesOfKeyResponders {
    return @[
             [UITableView class]
             ,[UICollectionView class]
             ,[UIViewController class]
             ,[UIWindow class]
             ];
}

- (NSArray *)yu_KeyResponders {
    NSArray *classes = [self yu_classesOfKeyResponders];
    return [self yu_respondersWithClasses:classes];
}

- (CGFloat)yu_minDisplayedPrecentInKeyResponders {
    NSArray *responders = [self yu_KeyResponders];
    return [self yu_minDisplayPrecentInResonders:responders];
}
@end
