import 'package:credit_card_app/src/credit_card/model/model.dart';

abstract class CreditCardState {}

class InitialState extends CreditCardState {}

class SaveState extends CreditCardState {}

class CreditCardCountryState extends CreditCardState {
  final List<Country> country;
  CreditCardCountryState({required this.country});
}

class CreditCardLoadingState extends CreditCardState {}

class CreditCardSavedState extends CreditCardState {}

class CreditCardLoadedState extends CreditCardState {
  final List<CreditCard> creditCard;
  CreditCardLoadedState({required this.creditCard});
}

class CreditCardErrorState extends CreditCardState {
  final String message;
  CreditCardErrorState(this.message);
}
