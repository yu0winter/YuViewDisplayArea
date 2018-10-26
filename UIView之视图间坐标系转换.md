
# UIView之视图间坐标系转换

如你所知，iOS中坐标系转换，需要使用以下两个系统API。

```
- (CGRect)convertRect:(CGRect)rect fromView:(UIView *)view;
- (CGRect)convertRect:(CGRect)rect toView:(UIView *)view;
```

本文将讲述两个API的具体使用和含义。

* ### convertRect: fromView:

```
- (CGRect)convertRect:(CGRect)rect fromView:(UIView *)view;

// 转换viewB坐标系内区域rect，在viewA坐标系中的位置。
CGRect rect = viewB.bounds;
CGRect result = [viewA convertRect:rect fromView:viewB];

viewB坐标系内区域rect，在viewA坐标系中的位置。
上述方法rect取的是viewB.bounds的值，因此又可以描述为：
viewB在viewA内部坐标系中的位置。
```

* ### convertRect: toView:
```
- (CGRect)convertRect:(CGRect)rect toView:(UIView *)view;

// 转换viewA坐标系内区域rect，在viewB坐标系中的位置。
CGRect rect = viewA.bounds;
CGRect result = [viewA convertRect:rect toView:viewB];
上述方法rect取的是viewA.bounds的值，因此又可以描述为：
viewA在viewB内部坐标系中的位置。
```


* ### 常见误区

rect 参数的使用经常会出现错误：
```
CGRect result_false = [viewA convertRect:viewA.frame toView:viewB]; 错误：❌
CGRect result_right = [viewA convertRect:viewA.frame toView:viewB]; 正确：✅

result_false 为，viewA坐标系中frame位置，应设在viewB坐标系中的区域。
相对result_right 来说，result_false的origin会附加viewA.frame.origin的值。
```
## 资料

- [YuViewDisplayArea](https://github.com/yu0winter/YuViewDisplayArea/)
- [UIView之在屏幕上的展示百分比](https://github.com/yu0winter/YuViewDisplayArea/blob/master/UIView之在屏幕上的展示百分比.md)

