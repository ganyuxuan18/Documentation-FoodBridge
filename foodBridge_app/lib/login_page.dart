import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_page.dart';
import 'volunteer_dashboard.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isVolunteer = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  void login() async {
    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController.text.trim());
      if (isVolunteer) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => VolunteerDashboard()));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  void signup() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
      login();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FoodBridge AI Login/Signup'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [Tab(text: 'Login'), Tab(text: 'Signup')],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: TabBarView(
          controller: _tabController,
          children: [
            buildForm(isLogin: true),
            buildForm(isLogin: false),
          ],
        ),
      ),
    );
  }

  Widget buildForm({required bool isLogin}) {
    return Column(
      children: [
        TextField(
          controller: emailController,
          decoration: InputDecoration(labelText: 'Email'),
        ),
        TextField(
          controller: passwordController,
          decoration: InputDecoration(labelText: 'Password'),
          obscureText: true,
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Checkbox(
              value: isVolunteer,
              onChanged: (v) => setState(() => isVolunteer = v!),
            ),
            Text('I am a Volunteer'),
          ],
        ),
        SizedBox(height: 12),
        ElevatedButton(
          onPressed: isLogin ? login : signup,
          child: Text(isLogin ? 'Login' : 'Signup'),
        ),
      ],
    );
  }
}