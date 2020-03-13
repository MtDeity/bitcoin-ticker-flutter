import 'dart:convert';

import 'package:http/http.dart' as http;

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

const coinApiUrl = 'https://rest.coinapi.io/v1/exchangerate';
const apiKey = '241D7F1B-E434-4910-BD97-EBA058D46818';

class CoinData {
  Future<Map<String, String>> getCoinData(String realCurrency) async {
    Map<String, String> coinPrices = {};
    for (String coin in cryptoList) {
      http.Response response =
          await http.get('$coinApiUrl/$coin/$realCurrency?apikey=$apiKey');
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        double rate = data['rate'];
        coinPrices[coin] = rate.toStringAsFixed(0);
      } else {
        print(response.statusCode);
        throw 'Problem with the get request';
      }
    }
    return coinPrices;
  }
}
