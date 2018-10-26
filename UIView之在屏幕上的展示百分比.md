
[TOC]

# UIView之在屏幕上展示的百分比

## 前言
众所周知，屏幕上的视图们以树状结构一层层的加载，并最终显示在屏幕上。而如何判断视图是否展示呢？常见方法，是判断视图是否展示在了当前keyWindow上，但这样是否是正确的呢？答案，不够的。下面请跟随本文一起来追溯原因。

### 对比 UIWindow 查看显示区域

如下图所示，currentView有部分内容超出了父视图，而被隐藏。如果仅对比currentView在UIWindow上展示的区域，结果将会是全部展示。因此，想要精确的判断视图的展示比例，需要考虑currentView的层层父视图。

<div align="center">    
<img src="http://or5n398vd.bkt.clouddn.com/UIWindow_error.png" width = "200" height = "200" alt="UITableView-VisibleCells" />
</div>

## 根据父视图类型，具体分析

### 视图本身(currentView)

打铁须得自身硬。

- self.hidden 是否隐藏
- self.alpha 是否透明
- self.size 是否尺寸为0
- self.superview 父视图是否存在

### 父视图(currentView.superview)

如下图，所示。需要计算当前视图在各级父视图上的展示情况。（self->self.superView->...->keyWindow）

[- (CGFloat)yu_displayedPrecentInView:(UIView *)view;](https://www.jianshu.com/p/2a460047c6cd)

<div align="center">    
<img src="http://or5n398vd.bkt.clouddn.com/UIView_Precent1.png" width = "200" height = "200" alt="UITableView-VisibleCells" />
</div>


为节省篇幅，具体实现方法可参考我的另一篇文章

// 获取当前视图在view上展示的比例

### UITableView、UICollectionView

由于UITableView、UICollectionView中Cell的复用机制，因此在判断Cell展示区域时，需要首先判断Cell是否在visibleCells中。

也就是需要知道Cell对应的IndexPath：
```
NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
if (cell == nil) {
// An object representing a cell of the table, or nil if the cell is not visible or indexPath is out of range.
// 代表当前indexPath对应的Cell不可见，或者indexPath超出数据源的范围
}
```

另外需要额外注意的是，当UITableView 的frame区域超出屏幕时。例如，表单高度超出屏幕，底部cell不能显示在屏幕上，但仍被包含在visibleCells中。
此时，判断cell是否展示在屏幕上就需要考虑UITableView在屏幕上的展示区域，进而转换计算。

<div align="center">    
<img src="http://or5n398vd.bkt.clouddn.com/UITableView-VisibleCells.png" width = "200" height = "200" alt="UITableView-VisibleCells" />
</div>

### UIViewController.view

需要确保UIViewController.view本身全部展示在屏幕中。其中遇到以下情况：

- UIContainerViewController中，UIViewController可以看待成普通视图展示。
- UITabBarController包含了多个UIViewController。
- UINavigationViewController内部自适应时，UIViewController的展示区域从导航栏底部开始。[详情见外链](https://blog.csdn.net/wuyulunbi12580/article/details/52691155)

## 结论：需要组合以上各情况计算显示情况

### 场景一：任意View获取在屏幕上的展示百分比 (父视图不包含UITableView、UICollectionView)

- 视图本身（currentView）
- 当前视图在各级父视图上的展示情况（self->self.superView->...->keyWindow）
- UIView 使用[- (CGFloat)yu_displayedPrecentInView:(UIView *)view;](https://www.jianshu.com/p/2a460047c6cd)方法计算。

综合以上各情况，求取最小值，即视图在屏幕上的展示情况。

### 场景二：任意View获取在屏幕上的展示百分比 (父视图包含UITableView、UICollectionView)

- 视图本身（currentView）
- 当前视图在各级父视图上的展示情况（self->self.superView->...->keyWindow）
- UIView 使用[- (CGFloat)yu_displayedPrecentInView:(UIView *)view;](https://www.jianshu.com/p/2a460047c6cd)方法计算 。
- UITableView 需要预先知道indexPath，判断所在Cell是否可见
- UICollectionView 需要预先知道indexPath，判断所在Cell是否可见

必须说明的是，IndexPath想要预先知道，就必须做出特出处理，不能简单的使用[- (CGFloat)yu_displayedPrecentInView:(UIView *)view;](https://www.jianshu.com/p/2a460047c6cd)方法计算。

综合以上各情况，求取最小值，即视图在屏幕上的展示情况。


###  场景三：在UITableView、UICollectionView滑动过程中，获取Cell在屏幕上展示的百分比

- 获取visibleCells
- 遍历每个Cell，并在屏幕上的展示百分比

此时，相对场景二，省却了锁定indexPath的事务，应用也更灵活一些。


## 注意事项

- UIViewController.viewDidAppear 方法执行完成之前，控制器上的视图在获取superView/nextResponder时，会发现获取到UIViewController之后为nil.这是由于，UIViewController尚未加载到UIWindow/UINaviationController上。


## 资源

- [UIViewController添加UICollectionView控件顶端出现留白的解决办法](https://blog.csdn.net/wuyulunbi12580/article/details/52691155)
- [Don't talk,show you the code!](https://github.com/yu0winter/YuViewDisplayArea/)
- [UIView之视图间坐标系转换](https://github.com/yu0winter/YuViewDisplayArea/blob/master/UIView之视图间坐标系转换.md)
