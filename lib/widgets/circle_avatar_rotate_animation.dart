/// @Author: kevin
/// @Date: 2024-02-12 20:25:07
/// @Description:
import 'package:flutter/material.dart';

class CircleAvatarRotateAnimation extends StatefulWidget {
  const CircleAvatarRotateAnimation({Key? key}) : super(key: key);
  @override
  State<CircleAvatarRotateAnimation> createState() =>
      _CircleAvatarRotateAnimationState();
}

class _CircleAvatarRotateAnimationState
    extends State<CircleAvatarRotateAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 点击时，动画暂停
        if (_controller.isAnimating) {
          _controller.stop();
        } else {
          _controller.repeat();
        }
      },
      child: RotationTransition(
        turns: Tween(begin: 0.0, end: 1.0).animate(_controller),
        child: SizedBox(
          width: 200,
          height: 200,
          child: Image.network(
            'https://bigshot.oss-cn-shanghai.aliyuncs.com/nba/bos.png',
          ),
        ),
      ),
    );
  }
}
