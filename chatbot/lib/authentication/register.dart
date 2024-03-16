import 'package:flutter/material.dart';

import '../../models/user.dart';
import 'user_info.dart';

class Register extends StatefulWidget {
  final Function toggleAuth;
  Register({required this.toggleAuth});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  MyUser user = MyUser(
      email: '',
      password: '',
      name: '',
      uid: '',
      financeBarValue: 0,
      academicBarValue: 0,
      careerBarValue: 0,
      badges: []);

  @override
  Widget build(BuildContext context) {
    return UserInfo(toggleAuth: widget.toggleAuth, user: user);
  }
}
