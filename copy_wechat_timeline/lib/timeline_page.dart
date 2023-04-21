import 'package:copy_wechat_timeline/model/timeline_model/comment.dart';
import 'package:copy_wechat_timeline/model/timeline_model/like.dart';
import 'package:copy_wechat_timeline/model/timeline_model/user.dart';
import 'package:copy_wechat_timeline/styles/text_style.dart';
import 'package:copy_wechat_timeline/utils/date_tool.dart';
import 'package:copy_wechat_timeline/widget/text_expand.dart';
import 'package:flutter/material.dart';
import 'model/example_data.dart';
import 'model/timeline_model/timeline_model.dart';
import 'widget/space_widget.dart';

class TimelinePage extends StatefulWidget {
  const TimelinePage({Key? key}) : super(key: key);

  @override
  State<TimelinePage> createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage>
    with SingleTickerProviderStateMixin {
  // 遮罩层
  OverlayState? _overlayState;

  OverlayEntry? _overlayEntry;
  // 更多按钮的位置
  Offset _btnOffset = Offset.zero;
  // 动画控制器
  late AnimationController _animatedContainer;
  late Animation<double> _sizeTween;
  // 滚动控制器
  final ScrollController _scrollController = ScrollController();
  // appBar 背景色
  Color? _appBarColor;
  //当前点击的item
  TimelineModel? _currentItem;

  // 数据
  List<TimelineModel> _items = [];

  // 是否显示评论输入框
  bool _isShowInput = false;
  // 是否展开列表
  bool _isShowEmoji = false;
  // 是否输入内容
  bool _isInputWords = false;
  // 评论输入框
  final TextEditingController _textEditingController = TextEditingController();
  // 输入框焦点
  final FocusNode _focusNode = FocusNode();
  // 键盘输入高度
  final double _keyboardheight = 200;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // 初始化遮罩层管理对象
    _overlayState = Overlay.of(context);
    // 监控输入
    _textEditingController.addListener(() {
      setState(() {
        _isInputWords = _textEditingController.text.isNotEmpty;
      });
    });
    // 监听滚动
    _scrollController.addListener(() {
      // 滚动条数超过 200 单位的时候开始渐变
      if (_scrollController.position.pixels > 200) {
        // 透明度系数
        double opacity = (_scrollController.position.pixels - 200) / 100;
        if (opacity < 0.85) {
          setState(() {
            _appBarColor = Colors.black.withOpacity(opacity);
          });
        }
      } else {
        // 没有滚动的时候 去隐藏AppBar
        setState(() {
          _appBarColor = null;
        });
      }
    });

    _animatedContainer = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));

    _sizeTween = Tween<double>(begin: 0.0, end: 145).animate(
        CurvedAnimation(parent: _animatedContainer, curve: Curves.easeInOut));

    _loadData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _textEditingController.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    _animatedContainer.dispose();
  }

  _loadData() {
    _items = example_data2.map((e) => TimelineModel.fromJson(e)).toList();
    if (mounted) {
      setState(() {});
    }
    print(_items.length);
  }

  _getMoreBtnOffset(GlobalKey key) {
    final RenderBox? renderBox =
        key.currentContext?.findRenderObject() as RenderBox?;
    // localToGlobal 从这个0 0 的位置找他的相对位置
    final Offset offset = renderBox?.localToGlobal(Offset.zero) ?? Offset.zero;
    _btnOffset = offset;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 这个属性可以将body 扩展到顶部对齐
      // 不加这个属性 渐变效果很是生硬
      extendBodyBehindAppBar: true,
      appBar: _buildAppbar(),
      bottomNavigationBar: _isShowInput ? _buildCommentBar() : null,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          //
          SliverPadding(padding: EdgeInsets.only(top: 0)),
          // 创建头部
          SliverToBoxAdapter(
            child: _buildHeaderView(),
          ),
          _buildList(),
        ],
      ),
    );
  }

  _buildAppbar() {
    return _appBarColor == null
        ? null
        : AppBar(title: Text("大佬的朋友圈"), backgroundColor: _appBarColor);
  }

  // 创建头部
  _buildHeaderView() {
    return Container(
      color: Colors.white,
      height: 300,
      child: Stack(
        children: [
          // 封面
          Image.asset(
            "images/new-york.png",
            fit: BoxFit.cover,
            height: 275,
          ),
          // 照相机按钮
          Positioned(
              top: 5,
              right: 5,
              child: IconButton(
                icon: Icon(Icons.camera_alt, color: Colors.white, size: 25),
                onPressed: () => print("click"),
              )),
          Positioned(
              bottom: 8,
              right: 20,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.network(
                    "https://up.enterdesk.com/edpic_source/0e/54/54/0e5454f85bbc336d6db640aa8fb0be6d.jpg",
                    fit: BoxFit.cover,
                    width: 58,
                    height: 58,
                  ))),

          // 名字
          Positioned(
            bottom: 36,
            right: 85,
            child: Row(
              children: <Widget>[
                Text(
                  "Leonardo Fibonacci",
                  style: TextStyle(
                      fontSize: 17,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  // 创建内容部分
  _buildList() {
    return SliverList(
        delegate: SliverChildBuilderDelegate((ctx, idx) {
      var item = _items[idx];
      return _buildItem(item);
    }, childCount: _items.length));
  }

  _buildItem(TimelineModel item) {
    int _imgCount = item.images!.length;
    GlobalKey _btnKey = GlobalKey();
    return Container(
      color: Colors.grey[100],
      child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              // 正文信息
              _buildContent(item, _imgCount, _btnKey),
              // 点赞列表
              _buildLikeList(item),
              // 评论列表
              _buildContentList(item)
            ],
          )),
    );
  }

  // 正文信息
  _buildContent(TimelineModel item, int imgCount, GlobalKey btnKey) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 左侧头像
        Image.network(
          item.user?.avator ?? "",
          fit: BoxFit.cover,
          width: 45,
          height: 45,
        ),
        const SpaceHorizontalWidget(),
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 昵称
            Text(
              item.user?.nickname ?? "",
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            const SpaceVerticalWidget(),
            // 正文部分
            TextMaxLinesWidget(item.content ?? ""),
            SpaceVerticalWidget(),
            // 拿到父组件的约束宽度 动态的布局
            // 9宫格列表图片
            LayoutBuilder(builder: (ctx, constraints) {
              // 如果是一张图的话  占比 0.6最大的宽度
              double imgWidth = imgCount == 1
                  ? constraints.maxWidth * 0.6
                  : (imgCount == 2 || imgCount == 4)
                      ? (constraints.maxWidth - 4 * 2) / 2
                      : (constraints.maxWidth - 4 * 3) / 3;
              return Wrap(
                spacing: 4,
                runSpacing: 4,
                runAlignment: WrapAlignment.start,
                children: item.images!.map((e) {
                  return Image.network(
                    e,
                    fit: BoxFit.cover,
                    width: imgWidth,
                    height: imgWidth,
                  );
                }).toList(),
              );
            }),
            const SpaceVerticalWidget(),
            // 地理位置
            Text(
              "辽宁市大连市海边的小房子",
              style: TextStyle(color: Colors.black54, fontSize: 14),
            ),
            const SpaceVerticalWidget(),
            // 更多按钮
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    _onShowMenu(item, ontap: _onCloseMenu);
                    // 获取点击按钮的offset
                    _getMoreBtnOffset(btnKey);
                  },
                  child: Container(
                      key: btnKey,
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(2)),
                      height: 20,
                      width: 30,
                      child: Icon(
                        Icons.more_horiz_outlined,
                        size: 20,
                      )),
                )
              ],
            ),
          ],
        ))
      ],
    );
  }

  // 创建是否点赞弹出动画
  _buildIsLikeMenu(TimelineModel item) {
    return LayoutBuilder(builder: (ctx, constraints) {
      return Container(
        decoration: BoxDecoration(
            color: Colors.black87, borderRadius: BorderRadius.circular(4)),
        height: 35,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            // 动态的去控制显示 否则会产生溢出
            // 宽度大于85的时候 才会显示喜欢按钮
            if (constraints.maxWidth > 85)
              TextButton.icon(
                  onPressed: () {
                    _currentItem = item;
                    _onLike();
                  },
                  icon: Icon(
                    Icons.favorite,
                    color:
                        item.isLike ?? false ? Colors.redAccent : Colors.white,
                    size: 16,
                  ),
                  label: Text(item.isLike ?? false ? "取消" : "喜欢",
                      style: TextStyle(color: Colors.white))),
            if (constraints.maxWidth > 140)
              TextButton.icon(
                  onPressed: () {
                    _currentItem = item;
                    // 评论操作
                    _onSwitchCommentBar();
                    // 关闭弹出菜单
                    _onCloseMenu();
                  },
                  icon: Icon(
                    Icons.comment_sharp,
                    color: Colors.white,
                    size: 16,
                  ),
                  label: Text(
                    "评论",
                    style: TextStyle(color: Colors.white),
                  )),
          ],
        ),
      );
    });
  }

  // 点赞的列表
  Widget _buildLikeList(TimelineModel item) {
    return Container(
      padding: const EdgeInsets.all(4),
      color: Colors.grey[100],
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 点赞心形图标
          const Padding(
            padding: EdgeInsets.only(top: 4),
            child: Icon(
              Icons.favorite_border_outlined,
              size: 20,
              color: Colors.black54,
            ),
          ),
          const SpaceHorizontalWidget(),
          // 点赞的列表
          Expanded(
              child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (Like item in item.likes ?? [])
                Image.network(
                  item.avator!,
                  width: 30,
                  height: 30,
                  fit: BoxFit.cover,
                )
            ],
          ))
        ],
      ),
    );
  }

  // 评论列表
  Widget _buildContentList(TimelineModel item) {
    return Container(
      padding: EdgeInsets.all(4),
      margin: EdgeInsets.only(top: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 左边的图标
          Icon(
            Icons.comment_bank_outlined,
            color: Colors.grey,
            size: 20,
          ),
          SpaceHorizontalWidget(),
          // 评论数据
          Expanded(
              child: Column(
            children: [
              for (Comment c_item in item.comments ?? [])
                _buildCommentItem(c_item),
            ],
          ))
        ],
      ),
    );
  }

  // 评论列表item
  _buildCommentItem(Comment item) {
    return Container(
      padding: EdgeInsets.all(2),
      color: Colors.grey[100],
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 头像
          Image.network(
            item.user?.avator ?? "",
            width: 37,
            height: 37,
          ),
          const SpaceHorizontalWidget(),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 昵称和时间
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item.user?.nickname ?? "",
                    style: textStyleName,
                  ),
                  Text(
                    DateFormateTool.dateTimeFormat(item.publishDate ?? ""),
                    style: textStyleComment,
                  )
                ],
              ),
              Text(
                item.content ?? "",
                style: textStyleComment,
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ))
        ],
      ),
    );
  }

  // 底部弹出评论栏
  Widget _buildCommentBar() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 100),
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: Colors.grey[100]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 评论输入框
              Row(
                children: [
                  // 输入框
                  Expanded(
                      child: TextField(
                    controller: _textEditingController,
                    focusNode: _focusNode,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    maxLines: 1,
                    minLines: 1,
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                    decoration: InputDecoration(
                        hintStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black26,
                            letterSpacing: 2),
                        fillColor: Colors.white,
                        filled: true,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                        hintText: "评论",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                        )),
                  )),
                  const SpaceHorizontalWidget(),
                  // 表情或者键盘图标
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          _isShowEmoji = !_isShowEmoji;
                        });
                        if (_isShowEmoji) {
                          _focusNode.unfocus();
                        } else {
                          _focusNode.requestFocus();
                        }
                      },
                      child: Icon(
                        _isShowEmoji
                            ? Icons.keyboard_alt_outlined
                            : Icons.mood_outlined,
                        size: 32,
                        color: Colors.black54,
                      )),
                  const SpaceHorizontalWidget(),
                  // 发送按钮
                  ElevatedButton(
                      onPressed: !_isInputWords ? null : _onComment,
                      child: const Text(
                        "发送",
                        style: TextStyle(fontSize: 16),
                      ))
                ],
              )
              // 下面是表情列表
              ,
              if (_isShowEmoji)
                Container(
                  margin: EdgeInsets.only(top: 5),
                  padding: const EdgeInsets.all(4),
                  height: _keyboardheight,
                  child: GridView(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    children: List.generate(100, (index) {
                      return Container(
                        color: Colors.grey[200],
                      );
                    }),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  /***-----action ---*****/

  // 点击显示遮罩层
  _onShowMenu(TimelineModel item, {Function()? ontap}) {
    // 实例化遮罩层
    _overlayEntry = OverlayEntry(builder: (ctx) {
      return Positioned(
        top: 0,
        right: 0,
        left: 0,
        bottom: 0,
        child: GestureDetector(
            onTap: ontap,
            child: Stack(
              children: [
                AnimatedContainer(
                  duration: const Duration(seconds: 2),
                  child: Container(color: Colors.black.withOpacity(0.3)),
                ),
                // 评价的按钮 和 喜欢的按钮
                AnimatedBuilder(
                    animation: _animatedContainer,
                    builder: (ctx, child) {
                      return Positioned(
                          left: _btnOffset.dx - _sizeTween.value,
                          top: _btnOffset.dy - 10,
                          child: SizedBox(
                            width: _sizeTween.value,
                            child: _buildIsLikeMenu(item),
                          ));
                    })
              ],
            )),
      );
    });
    // 延时启动动画 先起来遮罩 再去做动画
    Future.delayed(Duration(milliseconds: 100), () {
      if (_animatedContainer.status == AnimationStatus.dismissed) {
        _animatedContainer.forward();
      }
    });
    // 插入遮罩层 这时候就可以显示了
    _overlayState?.insert(_overlayEntry!);
  }

  //点赞操作
  _onLike() {
    // 安全检查
    if (_currentItem == null) return;
    // 设置状态
    setState(() {
      _currentItem!.isLike = !(_currentItem!.isLike ?? false);
    });
    // 关闭菜单
    _onCloseMenu();
    // 发送网络请求
  }

  _onCloseMenu() async {
    if (_animatedContainer.status == AnimationStatus.completed) {
      await _animatedContainer.reverse();
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
  }

  // 评论操作
  void _onComment() {
    // 安全检查
    if (_currentItem == null) return;

    // 设置状态
    setState(() {
      _currentItem?.comments?.add(Comment(
          content: _textEditingController.text,
          publishDate: DateTime.now().toString(),
          user: User(
            uid: "fasdasdas",
            nickname: "leo",
            avator:
                "https://tupian.qqw21.com/article/UploadPic/2021-3/202132721124233200.jpeg",
          )));
    });

    //
    _onSwitchCommentBar();
    // 请求后台接口
  }

  // 切换评论输入栏
  void _onSwitchCommentBar() {
    setState(() {
      _isShowInput = !_isShowInput;
      if (_isShowInput) {
        // 获取焦点
        _focusNode.requestFocus();
      } else {
        // 释放焦点
        _focusNode.unfocus();
      }
      _textEditingController.text = "";
    });
  }
}
