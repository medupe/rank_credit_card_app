// ignore_for_file: public_member_api_docs, sort_constructors_first

class Country {
  final String countryName;
  final bool bannedCountry;
  Country({
    required this.countryName,
    required this.bannedCountry,
  });

  Country copyWith({
    String? countryName,
    bool? bannedCountry,
  }) {
    return Country(
      countryName: countryName ?? this.countryName,
      bannedCountry: bannedCountry ?? this.bannedCountry,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'countryName': countryName,
      'bannedCountry': bannedCountry,
    };
  }

  factory Country.fromJson(Map<String, dynamic> map) {
    return Country(
      countryName: map['countryName'] as String,
      bannedCountry: map['bannedCountry'] as bool,
    );
  }

  @override
  String toString() =>
      'Country(countryName: $countryName, bannedCountry: $bannedCountry)';

  @override
  bool operator ==(covariant Country other) {
    if (identical(this, other)) return true;

    return other.countryName == countryName &&
        other.bannedCountry == bannedCountry;
  }

  @override
  int get hashCode => countryName.hashCode ^ bannedCountry.hashCode;
}
