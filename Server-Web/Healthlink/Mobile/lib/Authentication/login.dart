import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile/Pages/Home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool loading = false;
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: loading == true ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElasticIn(
              child: SpinKitWaveSpinner(// Replace SpinKitCircle with any other available spinner
                color: Colors.blueAccent,  // Set the color of the spinner
                size: 100.0,          // Set the size of the spinner
              ),
            ),
            Padding(padding: EdgeInsets.all(18)),
            ElasticIn(child: Text('Welcome back!!', style: TextStyle(color: Colors.white, fontFamily: 'Quicksand', fontWeight: FontWeight.bold),))
          ],
        ),
      ) : Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black,
              Colors.black
            ], // Replace with your desired colors
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(
                height: 340,
                child: Center(
                  child: Container(
                    child: SvgPicture.asset(
                      'Assets/login.svg',
                      semanticsLabel: 'My SVG Image',
                      width: 200,
                    ),
                  ),
                ),
              ),
              SlideInUp(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade900,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(70.0),
                      topRight: Radius.circular(70.0),
                    ),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(49.0),
                      child: Container(
                        child: Form(
                          key: formKey,
                          child: Column(
                            children: [
                              const Text(
                                "Login",
                                style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontSize: 38,
                                    fontFamily: 'Quicksand',
                                    fontWeight: FontWeight.w900),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              TextFormField(
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                                decoration: InputDecoration(
                                    filled: true,
                                    prefixIcon: const Icon(Icons.mail),
                                    prefixIconColor: Colors.white,
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 10.0,
                                      horizontal: 15,
                                    ),
                                    fillColor: Colors.grey.shade800,
                                    labelText: "Username",
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade800),
                                      borderRadius: BorderRadius.circular(
                                          20.0), // Set the same border radius here
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                      borderSide: const BorderSide(
                                          color: Colors.blueAccent),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                      borderSide: const BorderSide(
                                          color: Colors.orange),
                                    ),
                                    labelStyle: const TextStyle(
                                        color: Colors.white70,
                                        fontFamily: 'Quicksand',
                                        fontWeight: FontWeight.bold)),
                                validator: (val) {
                                  if (val!.length < 2) {
                                    return "Username must not be null";
                                  } else {
                                    return null;
                                  }
                                },
                                onChanged: (val) {
                                  setState(() {
                                    email = val;
                                  });
                                },
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              TextFormField(
                                controller: _passwordController,
                                obscureText: true,
                                style: const TextStyle(
                                  color: Colors
                                      .white, // Set the desired text color
                                ),
                                decoration: InputDecoration(
                                    prefixIcon: const Icon(Icons.key),
                                    prefixIconColor: Colors.white,
                                    filled: true,
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 10.0,
                                      horizontal: 15,
                                    ),
                                    fillColor: Colors.grey.shade800,
                                    labelText: "Password",
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade800),
                                      borderRadius: BorderRadius.circular(
                                          20.0), // Set the same border radius here
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                      borderSide: const BorderSide(
                                          color: Colors.blueAccent),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                      borderSide: const BorderSide(
                                          color: Colors.orange),
                                    ),
                                    labelStyle: const TextStyle(
                                        color: Colors.white70,
                                        fontFamily: 'Quicksand',
                                        fontWeight: FontWeight.bold)),
                                validator: (val) {
                                  if (val!.length < 6) {
                                    return "Password must be at least 6 characters";
                                  } else {
                                    return null;
                                  }
                                },
                                onChanged: (val) {
                                  setState(() {
                                    password = val;
                                  });
                                },
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: GestureDetector(
                                  onTap: login,
                                  child: Container(
                                    width:
                                        200, // Set the desired width of the button
                                    height:
                                        50, // Set the desired height of the button
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.blue.shade800,
                                          Colors.blueAccent
                                        ], // Replace with your desired gradient colors
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                          25), // Set the desired border radius
                                    ),
                                    child: const Center(
                                      child: Text(
                                        'Login',
                                        style: TextStyle(
                                          fontFamily: 'Quicksand',
                                          color: Colors
                                              .white, // Set the text color
                                          fontSize: 16, // Set the font size
                                          fontWeight: FontWeight
                                              .bold, // Set the font weight
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              const Text(
                                'Or',
                                style: TextStyle(color: Colors.white70),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Not a user? ',
                                    style: TextStyle(
                                        color: Colors.white70, fontSize: 14),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(builder: (context) => RegisterPage()));
                                    },
                                    child: const Text(
                                      'Create Account',
                                      style: TextStyle(
                                          color: Colors.blue, fontSize: 15),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              const SizedBox(
                                height: 140,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  login() async {

    if (formKey.currentState!.validate()) {
      setState(() {
        loading = true;
      });
      final response = await http.post(
        Uri.parse('http://192.168.1.4:8000/api/login/'),
        body: jsonEncode({'username': email, 'password': password}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final String accessToken = responseData['access'];
        final int userId = responseData['id'];

        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.clear();
        prefs.setString('accessToken', accessToken);
        prefs.setInt('id', userId);
        print('login success');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            elevation: 0,
            content: Stack(
              children: [
                ElasticIn(
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color(0xff279115)
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Login Successful!!', style: TextStyle(color: Colors.white, fontSize: 14),),
                        SizedBox(height: 3,),
                        Text(
                          'Welcome Back...',
                          style: const TextStyle(fontSize: 12,fontWeight: FontWeight.bold, fontFamily: 'Quicksand'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.transparent,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
          ),
        );
        Future.delayed(Duration(seconds: 3), (){
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Home()));
        });
        print(accessToken);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            elevation: 0,
            content: Stack(
              children: [
                ElasticIn(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.red
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Oops!!', style: TextStyle(color: Colors.white, fontSize: 14),),
                        SizedBox(height: 3,),
                        Text(
                          'Invalid Credentials',
                          style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold, fontFamily: 'Quicksand'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.transparent,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
          ),

        );
        Future.delayed(Duration(seconds: 2), (){
          setState(() {
            loading=false;
          });
        });
      }
    }
  }
}
