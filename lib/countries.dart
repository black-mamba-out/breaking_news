import 'package:flutter/material.dart';

class CountriesDropdownList extends StatelessWidget {
  final changeCountry;
  final Country currentCountry;
  final List<Country> countries;
  const CountriesDropdownList(
      {this.changeCountry, this.currentCountry, this.countries});

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: Center(
        child: Column(
          children: <Widget>[
            DropdownButton(
              value: currentCountry,
              items: prepareDropdownMenuItems(countries),
              onChanged: onChangeCountry,
            ),
          ],
        ),
      ),
    );
  }

  List<DropdownMenuItem<Country>> prepareDropdownMenuItems(
      List<Country> countries) {
    List<DropdownMenuItem<Country>> items = List();
    for (Country country in countries) {
      items.add(DropdownMenuItem(
        value: country,
        child: Text(country.name),
      ));
    }
    return items;
  }

  onChangeCountry(Country selectedCountry) {
    this.changeCountry(selectedCountry);
  }
}

class Country {
  String code;
  String name;

  Country(this.code, this.name);
}

List<Country> getCountries() {
  return <Country>[
    Country('tr', 'Türkiye'),
    Country('us', 'United States'),
    Country('gb', 'United Kingdom'),
    Country('ca', 'Canada'),
  ];
}
