import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foxtrot_app/pages/offers_page/tabs_bloc.dart';
import 'package:foxtrot_app/pages/offers_page/offers_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => BuildFromJsonBloc([]),
      child: MyHomePage(),
    );
  }
}
