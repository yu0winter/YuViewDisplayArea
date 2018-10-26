#  YuViewDisplayArea

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

/// 获取当前视图在事件传递链中所有节点上的展示比例的最小值
- (CGFloat)yu_minDisplayedPrecentInAllSuperviews;

```
## 算法逻辑
- [UIView之视图间坐标系转换](https://github.com/yu0winter/YuViewDisplayArea/blob/master/UIView之视图间坐标系转换.md)
- [UIView之在屏幕上的展示百分比](https://github.com/yu0winter/YuViewDisplayArea/blob/master/UIView之在屏幕上的展示百分比.md)

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


