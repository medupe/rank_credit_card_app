import 'package:credit_card_app/src/credit_card/credit_card.dart';

class CreditCard {
  String? cardNumber;
  CardType? cardType;
  int? cvv;
  Country? country;
  String? accountHolder;

  CreditCard(
      {this.cardNumber,
      this.cardType,
      this.cvv,
      this.country,
      this.accountHolder});

  CreditCard.fromJson(Map<String, dynamic> json) {
    cardNumber = json['cardNumber'];
    accountHolder = json['accountHolder'];
    cardType = enumFromString(json['cardType']);
    cvv = json['CVV'];
    country = json['issuingCountry'] != null
        ? Country.fromJson(json['issuingCountry'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['cardNumber'] = cardNumber;
    data['cardType'] = cardType.toString();
    data['accountHolder'] = accountHolder.toString();

    data['CVV'] = cvv;
    if (country != null) {
      data['issuingCountry'] = country!.toJson();
    }
    return data;
  }

  CardType enumFromString(String value) {
    try {
      // ignore: unnecessary_brace_in_string_interps
      return CardType.values.firstWhere((e) => e.toString() == value);
    } catch (error) {
      throw Exception('Invalid value for enum MyEnum: $value');
    }
  }
}
