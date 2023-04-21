import 'package:flutter/material.dart';

class TextMaxLinesWidget extends StatefulWidget {
  final String content;
  final int? maxLines;
  const TextMaxLinesWidget(this.content, {super.key, this.maxLines = 3});

  @override
  State<TextMaxLinesWidget> createState() => _TextMaxLinesWidgetState();
}

class _TextMaxLinesWidgetState extends State<TextMaxLinesWidget> {
  // 内容
  late final String _content;
  late final int _maxLines;
  // 是否展开
  bool _isExpansion = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _content = widget.content;
    _maxLines = widget.maxLines!;
  }

  Widget _mainView() {
    return LayoutBuilder(
      builder: (BuildContext ctx, BoxConstraints constraints) {
        // 将TextSpan 树绘制到 Canvas 中的对象
        // 利用这个对象  预先绘制且绘制到界面上去
        // 计算出我们最大行的文本是否显示的下 显示不下的话 则就展示全部按钮
        final TextPainter textPainter = TextPainter(
            text: TextSpan(
                text: _content,
                style: const TextStyle(fontSize: 15, color: Colors.black54)),
            maxLines: _maxLines,
            textDirection: TextDirection.ltr)
          ..layout(
              // 设置宽度约束
              maxWidth: constraints.maxWidth);

        // 如果不展开文字
        if (_isExpansion == false) {
          List<Widget> ws = [];
          // 1.1 检查是否超出高度
          if (textPainter.didExceedMaxLines && _isExpansion == false) {
            ws.add(Text(
              _content,
              maxLines: _maxLines,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 15, color: Colors.black54),
            ));

            ws.add(GestureDetector(
              onTap: () => _doExpansion(),
              child: const Text(
                "全文",
                style: TextStyle(fontSize: 15, color: Colors.blueAccent),
              ),
            ));
          } else {
            // 不超出则显示全部内容
            ws.add(Text(
              _content,
              style: const TextStyle(fontSize: 15, color: Colors.black54),
            ));
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: ws,
          );
        } else {
          // 展示显示全部
          return Text(
            _content,
            style: const TextStyle(fontSize: 15, color: Colors.black54),
          );
        }
      },
    );
  }

  void _doExpansion() {
    setState(() {
      _isExpansion = !_isExpansion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _mainView();
  }
}
