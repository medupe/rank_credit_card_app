import 'package:credit_card_app/src/credit_card/application/credit_card_state.dart';
import 'package:credit_card_app/src/credit_card/model/model.dart';
import 'package:credit_card_app/src/credit_card/repository/credit_card_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreditCardNotifer extends StateNotifier<CreditCardState> {
  final Ref _ref;

  CreditCardNotifer(this._ref) : super(InitialState()) {
    getCreditCards();
  }
  void getCreditCards() async {
    state = CreditCardLoadingState();
    try {
      final List<CreditCard> list =
          await _ref.watch(creditCardRepository).getCreditCard();
      state = CreditCardLoadedState(creditCard: list);
    } catch (e) {
      state = CreditCardErrorState(e.toString());
    }
  }

  void getCountries() async {
    state = CreditCardLoadingState();
    try {
      final List<Country> list =
          await _ref.watch(creditCardRepository).getCountry();
      state = CreditCardCountryState(country: list);
    } catch (e) {
      state = CreditCardErrorState(e.toString());
    }
  }

  void saveCreditCard(CreditCard card) async {
    try {
      state = CreditCardLoadingState();
      await _ref.watch(creditCardRepository).saveCreditCard(card);

      state = CreditCardSavedState();
      getCountries();
      getCreditCards();
    } catch (e) {
      state = CreditCardErrorState(e.toString());
    }
  }
}

final creditCardStateProvider =
    StateNotifierProvider<CreditCardNotifer, CreditCardState>((ref) {
  return CreditCardNotifer(ref);
});
