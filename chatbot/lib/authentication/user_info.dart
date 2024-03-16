import 'package:flutter/material.dart';

import '../../models/user.dart';
import '../loading.dart';
import '../services/auth_service.dart';
import '../themes.dart';

class UserInfo extends StatefulWidget {
  final Function toggleAuth;
  final String message;
  final MyUser user;
  const UserInfo(
      {required this.toggleAuth,
      this.message = '',
      super.key,
      required this.user});

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  final double _formheight = 60;
  final _formkey = GlobalKey<FormState>();
  double radius = 25;
  bool loading = false;
  bool obscure = false;
  bool reobscure = false;
  final AuthService _auth = AuthService();
  String retypePassword = '';

  Future<bool> _createAccount() async {
    if (_formkey.currentState != null) {
      if (_formkey.currentState?.validate() ?? false) {
        setState(() {
          loading = true;
        });
        dynamic authUser = await _auth.register(widget.user);
        if (authUser == null) {
          print('Failed to register');
          setState(() {
            loading = false;
          });
        } else {
          print('Success');
          setState(() {
            loading = false;
          });
          return true;
        }
      }
    } else {
      print(_formkey.currentState?.validate());
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return (loading)
        ? Loading()
        : Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              elevation: 0.0,
              leading: IconButton(
                icon: const BackButtonIcon(),
                onPressed: () => widget.toggleAuth(0, back: true),
                style: ButtonStyle(
                  elevation: const MaterialStatePropertyAll(200),
                  iconColor: MaterialStatePropertyAll(
                      Color.fromARGB(255, 56, 107, 246)),
                ),
              ),
            ),
            body: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        'Create an Account',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Form(
                      key: _formkey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Full Name',
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            height: _formheight,
                            padding: const EdgeInsets.only(
                              left: 10,
                            ),
                            margin: const EdgeInsets.symmetric(
                              horizontal: 5,
                            ),
                            decoration:
                                boxDecoration(Theme.of(context), radius),
                            alignment: AlignmentDirectional.center,
                            child: TextFormField(
                              style: const TextStyle(),
                              keyboardType: TextInputType.name,
                              decoration: inputDecoration(
                                  Theme.of(context), radius, null),
                              onChanged: (value) {
                                setState(() {
                                  widget.user.name = value;
                                });
                              },
                              validator: (value) => value!.isEmpty
                                  ? 'Please enter your full name'
                                  : null,
                            ),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          Text(
                            'Email',
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            height: _formheight,
                            padding: const EdgeInsets.only(
                              left: 10,
                            ),
                            margin: const EdgeInsets.symmetric(
                              horizontal: 5,
                            ),
                            decoration:
                                boxDecoration(Theme.of(context), radius),
                            alignment: AlignmentDirectional.center,
                            child: Row(
                              children: [
                                Expanded(
                                  child: FractionallySizedBox(
                                    child: TextFormField(
                                      style: const TextStyle(),
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: inputDecoration(
                                          Theme.of(context), radius, null),
                                      onChanged: (value) {
                                        setState(() {
                                          widget.user.email = value;
                                        });
                                      },
                                      validator: (value) => value!.isEmpty
                                          ? 'Please enter your email'
                                          : null,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => {},
                                  icon: const Icon(
                                    Icons.email,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Password',
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          Container(
                            height: _formheight,
                            padding: const EdgeInsets.only(
                              left: 10,
                            ),
                            margin: const EdgeInsets.symmetric(
                              horizontal: 5,
                            ),
                            decoration:
                                boxDecoration(Theme.of(context), radius),
                            alignment: AlignmentDirectional.center,
                            child: Row(
                              children: [
                                Expanded(
                                  child: FractionallySizedBox(
                                    child: TextFormField(
                                      style: const TextStyle(),
                                      obscureText: !obscure,
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      decoration: inputDecoration(
                                          Theme.of(context), radius, null),
                                      onChanged: (value) {
                                        setState(() {
                                          widget.user.password = value;
                                        });
                                      },
                                      validator: (value) =>
                                          widget.user.password?.isEmpty ?? true
                                              ? 'Please enter your password'
                                              : null,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => {
                                    setState(
                                      () {
                                        obscure = !obscure;
                                      },
                                    )
                                  },
                                  icon: Icon(
                                    obscure
                                        ? Icons.remove_red_eye
                                        : Icons.visibility_off,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Password',
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          Container(
                            height: _formheight,
                            padding: const EdgeInsets.only(
                              left: 10,
                            ),
                            margin: const EdgeInsets.symmetric(
                              horizontal: 5,
                            ),
                            decoration:
                                boxDecoration(Theme.of(context), radius),
                            alignment: AlignmentDirectional.center,
                            child: Row(
                              children: [
                                Expanded(
                                  child: FractionallySizedBox(
                                    child: TextFormField(
                                      style: const TextStyle(),
                                      obscureText: !reobscure,
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      decoration: inputDecoration(
                                          Theme.of(context), radius, null),
                                      onChanged: (value) {
                                        setState(() {
                                          retypePassword = value;
                                        });
                                      },
                                      validator: (value) => (retypePassword ==
                                              widget.user.password)
                                          ? null
                                          : 'Passwords do not match',
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => {
                                    setState(
                                      () {
                                        reobscure = !reobscure;
                                      },
                                    )
                                  },
                                  icon: Icon(
                                    reobscure
                                        ? Icons.remove_red_eye
                                        : Icons.visibility_off,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll<Color>(
                                Color.fromARGB(255, 56, 107, 246)),
                            padding: const MaterialStatePropertyAll<EdgeInsets>(
                                EdgeInsets.symmetric(horizontal: 40)),
                          ),
                          onPressed: _createAccount,
                          child: Text(
                            'Create Account',
                            style: const TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Alreafy have an account?',
                          style: const TextStyle(fontSize: 15),
                        ),
                        TextButton(
                          onPressed: () => widget.toggleAuth(1),
                          child: Text(
                            'Sign In',
                            style: const TextStyle(
                              fontSize: 15,
                              color: Color.fromARGB(255, 56, 107, 246),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
