import 'package:contact/contact_save.dart';
import 'package:contact/firstscreen.dart';
import 'package:contact/sharepefrence.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'cantact_view.dart';
void main()
{
  runApp(Home());
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}
class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ModelTheme(),
      child: Consumer<ModelTheme>(
          builder: (context, ModelTheme themeNotifier, child) {
            return MaterialApp(
              theme: themeNotifier.isDark
                  ? ThemeData.light(
                useMaterial3: true
              )
                  : ThemeData.dark(useMaterial3: true),
              debugShowCheckedModeBanner: false,
              home:HomeScreen(),
            );
          }),
    );
  }
}