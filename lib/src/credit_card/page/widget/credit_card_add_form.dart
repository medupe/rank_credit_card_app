import 'dart:developer';

import 'package:credit_card_app/core/app_helpers.dart';
import 'package:credit_card_app/core/app_strings.dart';
import 'package:credit_card_app/src/credit_card/application/credit_card_state.dart';
import 'package:credit_card_app/src/credit_card/credit_card.dart';
import 'package:credit_card_app/src/credit_card/enum/enum.dart';
import 'package:credit_card_app/src/credit_card/notifier/credit_card_notifer.dart';
import 'package:credit_card_scanner/credit_card_scanner.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreditCardAddForm extends ConsumerStatefulWidget {
  const CreditCardAddForm({super.key});

  @override
  CreditCardAddFormState createState() => CreditCardAddFormState();
}

class CreditCardAddFormState extends ConsumerState<CreditCardAddForm> {
  final _formKey = GlobalKey<FormState>();
  CardType? cardType;
  final _cardNumber = TextEditingController();
  List<Country> countryList = [
    Country(countryName: "South Africa", bannedCountry: false)
  ];
  final _cardAccountHolderName = TextEditingController();
  final _cvv = TextEditingController();
  Country _country = Country(countryName: "South Africa", bannedCountry: false);
  @override
  void initState() {
    cardType = CardType.Others;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(creditCardStateProvider);
    ref.listen<CreditCardState>(creditCardStateProvider,
        (CreditCardState? prev, CreditCardState next) {
      if (next is CreditCardErrorState) {
        final snackBar = SnackBar(
          content: Text(next.message),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else if (next is CreditCardLoadedState) {
        const snackBar = SnackBar(
          content: Text("fetching credit cards......"),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);

        Navigator.pushNamed(context, AppString.home);
      } else if (next is CreditCardSavedState) {
        const snackBar = SnackBar(
          content: Text("saved credit cards......"),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.of(context).pop();
      }
    });

    return Form(
      key: _formKey,
      child: Container(
        margin: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.07,
            right: MediaQuery.of(context).size.width * 0.07),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              controller: _cardNumber,
              onChanged: (String? value) {
                setState(() {
                  cardType = AppHelpers.getCardTypeFrmNumber(value ?? '');
                });
              },
              decoration: InputDecoration(
                labelText: 'Card number',
                // this is a workaround for async validations

                suffixIcon: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.credit_card_rounded),
                ),
              ),
              validator: (value) {
                if (value == null ||
                    value.isEmpty ||
                    !AppHelpers.isNumeric(value)) {
                  return 'Please enter valid  card number';
                }
                return null;
              },
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            const Text('Card Type'),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: DropdownButton<CardType>(
                value: cardType,
                style: TextStyle(
                    color: cardType == CardType.Invalid
                        ? Colors.red
                        : Colors.black),
                elevation: 16,
                onChanged: (CardType? value) {
                  // This is called when the user selects an item.
                  setState(() {
                    cardType = value!;
                    log(value.name);
                  });
                },
                items: CardType.values
                    .map<DropdownMenuItem<CardType>>((CardType value) {
                  return DropdownMenuItem<CardType>(
                    value: value,
                    child: Text(value.name),
                  );
                }).toList(),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            TextFormField(
              controller: _cardAccountHolderName,
              decoration: InputDecoration(
                labelText: 'Account holder name',
                // this is a workaround for async validations

                suffixIcon: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.person),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter account holder name';
                }
                return null;
              },
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: state is CreditCardCountryState
                      ? DropdownButton<Country>(
                          isExpanded: true,
                          value: _country,
                          style: const TextStyle(color: Colors.black),
                          elevation: 1,
                          onChanged: (Country? value) {
                            // This is called when the user selects an item.
                            setState(() {
                              _country = value!;
                              log(value.countryName);
                            });
                          },
                          items: state.country
                              .map<DropdownMenuItem<Country>>((Country value) {
                            return DropdownMenuItem<Country>(
                              alignment: AlignmentDirectional.centerStart,
                              value: value,
                              child: Text(value.countryName),
                            );
                          }).toList(),
                        )
                      : Container(
                          height: 0,
                        ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.height * 0.04,
                ),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: _cvv,
                    decoration: InputDecoration(
                      labelText: 'CVV',
                      suffixIcon: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.account_balance),
                      ),
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          !AppHelpers.isNumeric(value)) {
                        return 'Please enter valid cvv digit';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.04,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.05,
              child: ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    if (cardType == CardType.Invalid) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('card type is invalid')),
                      );
                      return;
                    }
                    final creditCard = CreditCard(
                        cardNumber: _cardNumber.text,
                        cardType: cardType ?? CardType.Others,
                        cvv: int.parse(_cvv.text),
                        accountHolder: _cardAccountHolderName.text,
                        country: _country);
                    ref
                        .watch(creditCardStateProvider.notifier)
                        .saveCreditCard(creditCard);

                    /*   ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Processing Data')),
                    );*/
                  }
                },
                child: const Text('Save'),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.05,
              child: OutlinedButton(
                onPressed: () async {
                  var cardDetails;
                  cardDetails = null;
                  cardDetails = await CardScanner.scanCard();

                  if (cardDetails != null) {
                    _cardNumber.text = cardDetails.cardNumber;
                    if (cardDetails.cardIssuer == 'CardIssuer.visa') {
                      setState(() {
                        cardType = CardType.visa;
                      });
                    } else if (cardDetails.cardIssuer ==
                        'CardIssuer.mastercard') {
                      setState(
                        () {
                          cardType = CardType.masterCard;
                        },
                      );
                    } else {
                      setState(() {
                        cardType = CardType.Others;
                      });
                    }
                  } else {
                    const snackBar = SnackBar(
                      content: Text("Could not detect card......"),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
                child: const Text('Scan card'),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
          ],
        ),
      ),
    );
  }
}
