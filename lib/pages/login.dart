import 'dart:convert';
import 'package:enquiry/models/user_detail_model.dart';
// import 'package:enquiry/models/user_model.dart';
import 'package:enquiry/utils/pref.dart';
import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
import 'package:enquiry/api_calls/user_auth.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  _LogInScreenState createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final _isObscure = ValueNotifier<bool>(true); // Track password visibility
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final UserDetail userDetail;

  bool _isLoading = false;

  void _loginUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      String username = _usernameController.text;
      String password = _passwordController.text;

      try {
        var response = await UserAuth.userLogin(username, password);
        if (response['code'] == 200) {
          userDetail = UserDetail.fromJson(response);
          Pref.setPref('userDetail', json.encode(response));
          Navigator.pushReplacementNamed(context, '/dashboard');
          return;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response['error'] ?? 'Login failed')),
          );
        }
      } catch (error) {
        print('Login error: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An error occurred during login')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    Pref().removePref('userDetail');
    _checkLoggedIn();
  }

  _checkLoggedIn() async {
    final checkUserData = await Pref().getPref('userDetail');
    if (checkUserData == null) {
      // Navigator.pushReplacementNamed(context, '/dashboard');
      return;
    } else if (checkUserData != 'null') {
      Navigator.pushReplacementNamed(context, '/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 182, 6, 6),
        title: const SizedBox.shrink(),
        toolbarHeight: 1,
      ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.only(top: 100.0),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image(
                  image: const AssetImage('assets/images/aboodGroupLogo.png'),
                  height: 200.0,
                  width: MediaQuery.of(context).size.width * 0.5,
                ),
                const SizedBox(height: 20.0),

                // Email Field
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Focus(
                    child: TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        prefixIcon: const Icon(Icons.email),
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 15.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50.0),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                            width: 2.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50.0),
                          borderSide:
                              const BorderSide(color: Colors.red, width: 2.0),
                        ),
                        labelStyle: const TextStyle(color: Colors.black),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(color: Colors.black),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Username is required';
                        }
                        return null;
                      },
                    ),
                  ),
                ),

                // Password Field
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Focus(
                          child: TextFormField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon: const Icon(Icons.lock),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isObscure.value
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed: () => setState(() {
                                  _isObscure.value = !_isObscure.value;
                                }),
                              ),
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 15.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50.0),
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                  width: 2.0,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50.0),
                                borderSide: const BorderSide(
                                    color: Colors.red, width: 2.0),
                              ),
                              labelStyle: const TextStyle(color: Colors.black),
                            ),
                            obscureText: _isObscure.value,
                            style: const TextStyle(color: Colors.black),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Password is required';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20.0),

                // Login Button
                ElevatedButton(
                  onPressed: _isLoading ? null : _loginUser,
                  style: ElevatedButton.styleFrom(
                    minimumSize:
                        Size(MediaQuery.of(context).size.width - 40, 50),
                    backgroundColor: const Color.fromARGB(255, 182, 6, 6),
                    foregroundColor: Colors.white,
                  ),
                  child: Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      if (_isLoading)
                        const Positioned(
                          left: 16,
                          child: SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 1,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      Padding(
                        padding: EdgeInsets.only(left: _isLoading ? 40 : 0),
                        child: const Text(
                          'SIGN IN',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
