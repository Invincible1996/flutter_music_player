/// @Author: kevin
/// @Date: 2024-01-05 23:02:20
/// @Description:
import 'package:flutter/material.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);
  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        color: Colors.white.withOpacity(0.8),
        child: Text(
          '未完待续~~',
          style: TextStyle(
            color: Theme.of(context).colorScheme.inversePrimary,
            fontSize: 40,
          ),
        ),
      ),
    );
  }
}
