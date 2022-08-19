import 'package:flutter/material.dart';

import 'bottom_navbar.dart';
import 'database/db.dart';
import 'sign_up.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // global key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // empty list to add all users data
  List<Map> usersList = [];
  // password visibility
  bool isPasswordObscure = true;
  // database
  MyDb myDb = MyDb();
  @override
  void initState() {
    myDb.open();
    openUsersData();
    super.initState();
  }

  void openUsersData() {
    Future.delayed(const Duration(milliseconds: 2000), () async {
      usersList = await myDb.db!.rawQuery("SELECT * FROM users");
      setState(() {});
      print(usersList);
    });
  }

  @override
  void dispose() {
    myDb.db!.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.orange.shade800,
      body: Center(
        child: Container(
          height: 500,
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                emailTextFormField(),
                passwordTextFormField(),
                elevatedButtonWidget(),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const SignUp(),
                      ),
                    );
                  },
                  child: RichText(
                    text: TextSpan(
                      text: "Don't have an Account? ",
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: "Sign up",
                          style: TextStyle(
                            color: Colors.orange.shade800,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget passwordTextFormField() => TextFormField(
        controller: _passwordController,
        validator: (String? value) {
          if (value!.isEmpty) {
            return "password should not be empty";
          }
          if (value.length > 8) {
            return "password should not exceed 8 characters";
          }
          return null;
        },
        obscureText: isPasswordObscure,
        cursorColor: Colors.orange,
        style: const TextStyle(
          color: Colors.orange,
        ),
        decoration: InputDecoration(
          hintText: "password",
          hintStyle: const TextStyle(
            color: Colors.orange,
          ),
          prefixIcon: const Icon(
            Icons.lock,
            color: Colors.orange,
            size: 20,
          ),
          suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  isPasswordObscure = !isPasswordObscure;
                });
              },
              child: isPasswordObscure
                  ? const Icon(
                      Icons.visibility_off,
                      color: Colors.orange,
                      size: 20,
                    )
                  : const Icon(
                      Icons.visibility,
                      color: Colors.orange,
                      size: 20,
                    )),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(width: 2, color: Colors.orange)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(width: 2, color: Colors.orange)),
          errorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(width: 2, color: Colors.red)),
          focusedErrorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(width: 2, color: Colors.red)),
        ),
      );

  Widget emailTextFormField() => TextFormField(
        controller: _emailController,
        validator: (String? value) {
          if (value!.isEmpty) {
            return "email should not be empty";
          } else if (!value.contains('@')) {
            return "Please enter valid email address";
          }
          return null;
        },
        obscureText: false,
        cursorColor: Colors.orange,
        style: const TextStyle(
          color: Colors.orange,
        ),
        decoration: InputDecoration(
          hintText: "email",
          hintStyle: const TextStyle(
            color: Colors.orange,
          ),
          prefixIcon: const Icon(
            Icons.email,
            color: Colors.orange,
            size: 20,
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(width: 2, color: Colors.orange)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(width: 2, color: Colors.orange)),
          errorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(width: 2, color: Colors.red)),
          focusedErrorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(width: 2, color: Colors.red)),
        ),
      );

  Widget elevatedButtonWidget() => SizedBox(
        height: 50,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            String? email, password, username;
            var userDatas = usersList
                .where((user) => user["email"] == _emailController.text);
            for (var user in userDatas) {
              email = user["email"];
              password = user["password"];
              username = user["username"];
            }
            print(email);
            print(username);
            print(password);

            if (_formKey.currentState!.validate()) {
              if (_emailController.text == email) {
                if (_passwordController.text == password) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          HomeBottomNavBar(username: username),
                    ),
                  );
                } else if (_passwordController.text != password) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Colors.orange,
                      content: Text(
                        "Please provide valid password",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  );
                }
              } else if (_emailController.text != email) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: Colors.orange,
                    content: Text(
                      "User doesnot exists, Please register first and try to Login",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                );
              }
            }
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.orange,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text(
            "Login",
            style: TextStyle(
              color: Colors.white,
              letterSpacing: 1,
              fontSize: 15,
            ),
          ),
        ),
      );
}
