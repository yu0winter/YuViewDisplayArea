#  YuViewDisplayrect

本项目在系统类的基础上提供了简便的API，用于获取UIView之间展示区域的交集关系。

## 核心类（UIView+YuViewDisplayrect.h）提供了以下方法：

```
/// 判断当前视图是否显示在当前KeyWindow上
- (BOOL)yu_isDisplayedInKeyWindow;

/// 判断当前视图是否显示在view上。即两个视图的交集为空时，返回NO。
- (BOOL)yu_isDisplayedInView:(UIView *)view;

/// 获取当前视图在view上展示的比例
- (CGFloat)yu_displayedPrecentInView:(UIView *)view;

/// 获取当前视图在view内部坐标系中的位置
- (CGRect)yu_locationInView:(UIView *)view;
```

## UIView 视图间坐标系转换

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

## 遇到的问题

- 两个视图是否加载一个UIWindow上
	- 主要内容加载在主UIWindow上，每一个UIWindow对应有且只有一个screen。至于其他UIWindow的使用时机，如键盘界面。因此，忽略键盘界面。默认所有视图都加在主UIWindow上。

## 性能测试—— yu_displayedPrecentInView 方法

### TestTableViewController

```
 each of self.tableView.visibleCells call the method '- (CGFloat)yu_displayedPrecentInView:(UIView *)view;'
-------执行1万次查看性能--------
start time = 1539676678095.130859 
end time = 1539676678565.601807 
use time = 470.470947 ms 毫秒 
use time per time =0.047047 ms 毫秒 
```

### TestCollectionViewController

```
 each of self.collectionView.visibleCells call the method '- (CGFloat)yu_displayedPrecentInView:(UIView *)view;'
-------执行1万次查看性能--------
start time = 1539676852782.903076 
end time = 1539676853150.312988 
use time = 367.409912 ms 毫秒 
use time per time =0.036741 ms 毫秒 
```


