import 'package:credit_card_app/core/core.dart';
import 'package:credit_card_app/src/credit_card/application/credit_card_state.dart';
import 'package:credit_card_app/src/credit_card/credit_card.dart';
import 'package:credit_card_app/src/credit_card/notifier/credit_card_notifer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreditCardPage extends ConsumerWidget {
  const CreditCardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(creditCardStateProvider);

    ref.listen<CreditCardState>(creditCardStateProvider,
        (CreditCardState? prev, CreditCardState next) {
      if (next is CreditCardErrorState) {
        final snackBar = SnackBar(
          content: Text(next.message),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });

    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              Image.asset('assets/app_bar.jpg', fit: BoxFit.cover),
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.20,
                    left: MediaQuery.of(context).size.height * 0.06),
                child: const Text(
                  'Credit card records',
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.04,
          ),
          Expanded(
            child: state is CreditCardLoadingState
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : state is CreditCardLoadedState
                    ? state.creditCard.isEmpty
                        ? const Center(
                            child: Text("No credit card availabe"),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(8),
                            itemCount: state.creditCard.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ListTile(
                                leading: CircleAvatar(
                                  child: state.creditCard[index].cardType ==
                                          CardType.visa
                                      ? Image.asset('assets/VISA.png',
                                          fit: BoxFit.cover)
                                      : state.creditCard[index].cardType ==
                                              CardType.masterCard
                                          ? Image.asset(
                                              'assets/MASTER_CARD.png',
                                              fit: BoxFit.cover)
                                          : Image.asset('assets/OTHER.png',
                                              fit: BoxFit.cover),
                                ),
                                title: Text(
                                  state.creditCard[index].cardNumber.toString(),
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w900),
                                ),
                                subtitle: Text(
                                  "${state.creditCard[index].accountHolder} -- ${state.creditCard[index].country!.countryName}",
                                  style: const TextStyle(
                                      color: Colors.blueGrey,
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal),
                                ),
                                trailing: Text(
                                  "${state.creditCard[index].cvv}",
                                  style: const TextStyle(
                                      color: Colors.black87,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              );
                            },
                          )
                    : state is CreditCardErrorState
                        ? Text(state.message)
                        : const Text('Error occured'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(creditCardStateProvider.notifier).getCountries();
          Navigator.pushNamed(context, AppString.add_credit_card_page);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
