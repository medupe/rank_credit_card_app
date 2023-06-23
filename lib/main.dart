import 'package:credit_card_app/core/app_strings.dart';
import 'package:credit_card_app/src/credit_card/page/credit_card_add_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'src/credit_card/page/credit_card_page.dart';

void main() {
  runApp(
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (context) => const CreditCardPage(),
        AppString.add_credit_card_page: (context) => const CreditCardAddPage(),
      },
      theme: ThemeData(primarySwatch: Colors.cyan, useMaterial3: true),
      // home: const CreditCardPage(),
    );
  }
}
