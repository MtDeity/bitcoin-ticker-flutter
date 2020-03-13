import 'dart:io' show Platform;

import 'package:bitcoin_ticker/coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String realCurrency = 'USD';
  bool isWaiting = true;
  Map<String, String> coinPrices;

  void getData() async {
    try {
      Map<String, String> data = await CoinData().getCoinData(realCurrency);
      isWaiting = false;
      setState(() {
        coinPrices = data;
      });
    } catch (e) {
      print(e);
    }
  }

  Column makeCards() {
    List<CoinCard> coinCards = [];
    for (String coin in cryptoList) {
      CoinCard coinCard = CoinCard(
        coin: coin,
        value: isWaiting ? '?' : coinPrices[coin],
        realCurrency: realCurrency,
      );
      coinCards.add(coinCard);
    }

    Column column = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: coinCards,
    );
    return column;
  }

  DropdownButton androidDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String currency in currenciesList) {
      DropdownMenuItem<String> dropdownMenuItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropdownItems.add(dropdownMenuItem);
    }

    return DropdownButton(
      value: realCurrency,
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          realCurrency = value;
          getData();
        });
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Text> pickerItems = [];
    for (String currency in currenciesList) {
      pickerItems.add(Text(currency));
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        realCurrency = currenciesList[selectedIndex];
        getData();
      },
      children: pickerItems,
      scrollController: FixedExtentScrollController(initialItem: 19),
    );
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          makeCards(),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iOSPicker() : androidDropdown(),
          ),
        ],
      ),
    );
  }
}

class CoinCard extends StatelessWidget {
  CoinCard({this.coin, this.value, this.realCurrency});

  final String coin;
  final String value;
  final String realCurrency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $coin = $value $realCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
