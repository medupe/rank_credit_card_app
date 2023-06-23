import 'dart:convert';

import 'package:credit_card_app/core/core.dart';
import 'package:credit_card_app/src/credit_card/model/model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class ICreditCardRepsoitory {
  Future<void> saveCreditCard(CreditCard card);
  Future<List<CreditCard>> getCreditCard();
  Future<List<Country>> getCountry();
}

class CreditCardRepository implements ICreditCardRepsoitory {
  final _localStorageDb = LocalStorageDb();

  @override
  Future<List<Country>> getCountry() async {
    List<Country> countries = [
      Country(countryName: "Afghanistan", bannedCountry: false),
      Country(countryName: "Albania", bannedCountry: false),
      Country(countryName: "Algeria", bannedCountry: false),
      Country(countryName: "Andorra", bannedCountry: false),
      Country(countryName: "Angola", bannedCountry: false),
      Country(countryName: "Antigua and Barbuda", bannedCountry: false),
      Country(countryName: "Argentina", bannedCountry: false),
      Country(countryName: "Armenia", bannedCountry: false),
      Country(countryName: "Australia", bannedCountry: false),
      Country(countryName: "Austria", bannedCountry: false),
      Country(countryName: "Azerbaijan", bannedCountry: false),
      Country(countryName: "Bahamas", bannedCountry: false),
      Country(countryName: "Bahrain", bannedCountry: false),
      Country(countryName: "Bangladesh", bannedCountry: false),
      Country(countryName: "Barbados", bannedCountry: false),
      Country(countryName: "Belarus", bannedCountry: false),
      Country(countryName: "Belgium", bannedCountry: false),
      Country(countryName: "Belize", bannedCountry: false),
      Country(countryName: "Benin", bannedCountry: false),
      Country(countryName: "Bhutan", bannedCountry: false),
      Country(
          countryName: "Bolivia (Plurinational State of)",
          bannedCountry: false),
      Country(countryName: "Bosnia and Herzegovina", bannedCountry: false),
      Country(countryName: "Botswana", bannedCountry: false),
      Country(countryName: "Brazil", bannedCountry: false),
      Country(countryName: "Brunei Darussalam", bannedCountry: false),
      Country(countryName: "Bulgaria", bannedCountry: false),
      Country(countryName: "Burkina Faso", bannedCountry: false),
      Country(countryName: "Burundi", bannedCountry: false),
      Country(countryName: "Cabo Verde", bannedCountry: false),
      Country(countryName: "Cambodia", bannedCountry: false),
      Country(countryName: "Cameroon", bannedCountry: false),
      Country(countryName: "Canada", bannedCountry: false),
      Country(countryName: "Central African Republic", bannedCountry: false),
      Country(countryName: "Chad", bannedCountry: false),
      Country(countryName: "Chile", bannedCountry: false),
      Country(countryName: "China", bannedCountry: false),
      Country(countryName: "Colombia", bannedCountry: false),
      Country(countryName: "Comoros", bannedCountry: false),
      Country(countryName: "Congo", bannedCountry: false),
      Country(countryName: "Costa Rica", bannedCountry: false),
      Country(countryName: "Côte d'Ivoire", bannedCountry: false),
      Country(countryName: "Croatia", bannedCountry: false),
      Country(countryName: "Cuba", bannedCountry: true),
      Country(countryName: "Cyprus", bannedCountry: false),
      Country(countryName: "Czechia", bannedCountry: false),
      Country(
          countryName: "Democratic People's Republic of Korea",
          bannedCountry: true),
      Country(
          countryName: "Democratic Republic of the Congo",
          bannedCountry: false),
      Country(countryName: "Denmark", bannedCountry: false),
      Country(countryName: "Djibouti", bannedCountry: false),
      Country(countryName: "Dominica", bannedCountry: false),
      Country(countryName: "Dominican Republic", bannedCountry: false),
      Country(countryName: "Ecuador", bannedCountry: false),
      Country(countryName: "Egypt", bannedCountry: false),
      Country(countryName: "El Salvador", bannedCountry: false),
      Country(countryName: "Equatorial Guinea", bannedCountry: false),
      Country(countryName: "Eritrea", bannedCountry: false),
      Country(countryName: "Estonia", bannedCountry: false),
      Country(countryName: "Eswatini", bannedCountry: false),
      Country(countryName: "Ethiopia", bannedCountry: false),
      Country(countryName: "Fiji", bannedCountry: false),
      Country(countryName: "Finland", bannedCountry: false),
      Country(countryName: "France", bannedCountry: false),
      Country(countryName: "Gabon", bannedCountry: false),
      Country(countryName: "Gambia", bannedCountry: false),
      Country(countryName: "Georgia", bannedCountry: false),
      Country(countryName: "Germany", bannedCountry: false),
      Country(countryName: "Ghana", bannedCountry: false),
      Country(countryName: "Greece", bannedCountry: false),
      Country(countryName: "Grenada", bannedCountry: false),
      Country(countryName: "Guatemala", bannedCountry: false),
      Country(countryName: "Guinea", bannedCountry: false),
      Country(countryName: "South Africa", bannedCountry: false),
    ];
    return countries
        .where((element) => element.bannedCountry == false)
        .toList();
  }

  @override
  Future<List<CreditCard>> getCreditCard() async {
    final creditCard = await _localStorageDb
        .getLocalStringDb(AppString.localStorageSaveCreditCardKey);
    // await _localStorageDb.removeKey(AppString.localStorageSaveCreditCardKey);
    if (creditCard == null) return [];

    List<CreditCard> array = [];

    var tagObjsJson = jsonDecode(creditCard) as List;
    List<CreditCard> tagObjs =
        tagObjsJson.map((tagJson) => CreditCard.fromJson(tagJson)).toList();

    return tagObjs;
  }

  @override
  Future<void> saveCreditCard(CreditCard card) async {
    final list = await getCreditCard();

    int count = list
        .where((element) => element.cardNumber == card.cardNumber)
        .toList()
        .length;
    if (count == 0) {
      list.add(card);
      await _localStorageDb.setLocalListDb(
          AppString.localStorageSaveCreditCardKey, jsonEncode(list));
    } else {
      throw Exception("Credit card already exist ");
    }
  }
}

final creditCardRepository =
    Provider<CreditCardRepository>((ref) => CreditCardRepository());
