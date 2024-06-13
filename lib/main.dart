import 'dart:js_interop';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black45),
        useMaterial3: true,
      ),
      home: const SignUpPage(title: 'Sign Up'),
    );
  }
}

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key, required this.title});

  final String title;

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isValidationShowing = false;
  bool _isEmailValid = false;
  bool _isPasswordValid = false;

  String _charactersAmount = '8 characters or more (no spaces)';
  String _uppercaseAndLowercase = 'Uppercase and lowercase letters';
  String _digitAmount = 'At least one digit';

  bool _isCharactersAmountValid = false;
  bool _isUppercaseAndLowercaseValid = false;
  bool _isDigitAmountValid = false;

  TextStyle _inputTextStyle(bool isInputValid) {
    if (isInputValid && _isValidationShowing) {
      return TextStyle(color: Color(0xFF27B274));
    }
    if (!isInputValid && _isValidationShowing) {
      return TextStyle(color: Color(0xFFFF8080));
    }
    return TextStyle(color: Color(0xFF4A4E71));
  }

  TextStyle _hintTextStyle(bool isHintValid) {
    if (isHintValid && _isValidationShowing) {
      return TextStyle(
          fontSize: 13.0,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
          color: Color(0xFF27B274));
    }
    if (!isHintValid && _isValidationShowing) {
      return TextStyle(
          fontSize: 13.0,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
          color: Color(0xFFFF8080));
    }
    return TextStyle(
        fontSize: 13.0,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w400,
        color: Color(0xFF4A4E71));
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      setState(() {
        _isEmailValid = false;
      });
      return 'Please enter your email';
    }

    String emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    RegExp regex = RegExp(emailPattern);

    if (!regex.hasMatch(value)) {
      setState(() {
        _isEmailValid = false;
      });
      return 'Please enter a valid email';
    }
    setState(() {
      _isEmailValid = true;
    });
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      setState(() {
        _isPasswordValid = false;
      });
      return 'Please enter your password';
    }

    String uppercasePattern = r'[A-Z]';
    RegExp uppercaseRegex = RegExp(uppercasePattern);
    String lowercasePattern = r'[a-z]';
    RegExp lowercaseRegex = RegExp(lowercasePattern);
    String digitAmountPattern = r'\d';
    RegExp digitAmountRegex = RegExp(digitAmountPattern);

    if (value.length >= 8 && value.length <= 64 && !value.contains(' ')) {
      setState(() {
        _isCharactersAmountValid = true;
      });
    } else {
      setState(() {
        _isCharactersAmountValid = false;
      });
    }

    if (uppercaseRegex.hasMatch(value) && lowercaseRegex.hasMatch(value)) {
      setState(() {
        _isUppercaseAndLowercaseValid = true;
      });
    } else {
      setState(() {
        _isUppercaseAndLowercaseValid = false;
      });
    }

    if (digitAmountRegex.hasMatch(value)) {
      setState(() {
        _isDigitAmountValid = true;
      });
    } else {
      setState(() {
        _isDigitAmountValid = false;
      });
    }

    if (_isCharactersAmountValid &&
        _isUppercaseAndLowercaseValid &&
        _isDigitAmountValid) {
      setState(() {
        _isPasswordValid = true;
      });
      return null;
    } else {
      setState(() {
        _isPasswordValid = false;
      });
      return '';
    }
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sign up success'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text('Email: ${emailController.text}'),
                Text('Password: ${passwordController.text}'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFF4F9FF), Color(0xFFE0EDFB)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.disabled,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 200),
          child: Column(
            children: [
              Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: Text(
                    widget.title,
                    style: TextStyle(
                        fontSize: 28.0,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                        color: Color.fromRGBO(74, 78, 113, 1.0)),
                  )),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: TextFormField(
                  controller: emailController,
                  enableInteractiveSelection: false,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: "Email",
                      labelStyle: TextStyle(color: Color(0xFF6F91BC)),
                      filled: true,
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF6F91BC)),
                          borderRadius: BorderRadius.circular(10.0)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: _isEmailValid
                                  ? Color(0xFF27B274)
                                  : Colors.transparent),
                          borderRadius: BorderRadius.circular(10.0)),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFFF8080)),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      errorStyle:
                          TextStyle(height: 0, color: Color(0xFFFF8080)),
                      floatingLabelStyle: _inputTextStyle(_isEmailValid)),
                  style: _inputTextStyle(_isEmailValid),
                  validator: _validateEmail,
                  onTap: () {
                    if (_isValidationShowing) {
                      setState(() {
                        _isEmailValid = false;
                        _isPasswordValid = false;
                        _isValidationShowing = false;
                      });
                      _formKey.currentState?.reset();
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: TextFormField(
                  controller: passwordController,
                  obscureText: _obscurePassword,
                  enableInteractiveSelection: false,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: "Password",
                    labelStyle: TextStyle(color: Color(0xFF6F91BC)),
                    filled: true,
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF6F91BC)),
                        borderRadius: BorderRadius.circular(10.0)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: _isPasswordValid
                                ? Color(0xFF27B274)
                                : Colors.transparent),
                        borderRadius: BorderRadius.circular(10.0)),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFFF8080)),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    errorStyle: TextStyle(height: 0, color: Color(0xFFFF8080)),
                    floatingLabelStyle: _inputTextStyle(_isPasswordValid),
                    suffixIcon: IconButton(
                      icon: Padding(
                          padding: EdgeInsets.only(right: 20),
                          child: Icon(
                            _obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Color(0xFF6F91BC),
                          )),
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  style: _inputTextStyle(_isPasswordValid),
                  validator: _validatePassword,
                  onTap: () {
                    if (_isValidationShowing) {
                      setState(() {
                        _isEmailValid = false;
                        _isPasswordValid = false;
                        _isValidationShowing = false;
                      });

                      _formKey.currentState?.reset();
                    }
                  },
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(bottom: 40.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                            padding: EdgeInsets.only(left: 12, bottom: 4.0),
                            child: Text(
                              _charactersAmount,
                              style: _hintTextStyle(_isCharactersAmountValid),
                            )),
                        Padding(
                            padding: EdgeInsets.only(left: 12, bottom: 4.0),
                            child: Text(
                              _uppercaseAndLowercase,
                              style:
                                  _hintTextStyle(_isUppercaseAndLowercaseValid),
                            )),
                        Padding(
                            padding: EdgeInsets.only(left: 12, bottom: 4.0),
                            child: Text(
                              _digitAmount,
                              style: _hintTextStyle(_isDigitAmountValid),
                            )),
                      ],
                    ),
                  )),
              Center(
                child: Container(
                  height: 48,
                  width: 240,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Color(0xFF70C3FF), Color(0xFF4B65FF)]),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isValidationShowing = true;
                      });
                      if (_formKey.currentState!.validate()) {
                        _showDialog(context);
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all(Colors.transparent),
                      overlayColor: WidgetStateProperty.resolveWith((states) {
                        if (states.contains(WidgetState.hovered)) {
                          return Colors.transparent;
                        }
                        return Colors.transparent;
                      }),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                    child: const Text(
                      'Submit',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
