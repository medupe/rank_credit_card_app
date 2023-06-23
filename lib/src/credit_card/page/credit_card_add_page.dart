import 'package:credit_card_app/src/credit_card/notifier/credit_card_notifer.dart';
import 'package:credit_card_app/src/credit_card/page/widget/credit_card_add_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreditCardAddPage extends ConsumerWidget {
  const CreditCardAddPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              ref.read(creditCardStateProvider.notifier).getCreditCards();
              Navigator.of(context).pop();
            }),
        title: const Text('Save Credit card'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          const CreditCardAddForm(),
        ],
      ),
    );
  }
}
