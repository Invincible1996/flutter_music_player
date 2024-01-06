/// @Author: kevin
/// @Date: 2024-01-05 23:02:00
/// @Description:
import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);
  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        color: Colors.white.withOpacity(.5),
        child: Text(
          '尽情期待~~',
          style: TextStyle(
            color: Theme.of(context).colorScheme.inversePrimary,
            fontSize: 40,
          ),
        ),
      ),
    );
  }
}
