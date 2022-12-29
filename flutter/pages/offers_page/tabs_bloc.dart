import 'dart:convert';
import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

Future getCharacters() async {
  return await http.get(Uri.parse(
      "https://mobile-json.oneplusone.solutions/api?api_token=cG5UpVdzrs8Lv8lqAqnkhVUbZDlFXylk9PQyxRxfFQdUuP18eRAL7YAt9NsHWsi3"));
}

class CharacterModel {
  int id;
  String image;
  String text;
  String endData;

  CharacterModel.fromJson(Map json)
      : id = json['id'],
        image = json['image'],
        text = json['text'],
        endData = json['endData'];

  Map toJson() {
    return {
      'id': id,
      'image': image,
      'text': text,
      'endData': endData,
    };
  }
}

class PartnersModel {
  int id;
  String logo;
  String color;

  PartnersModel.fromJson(Map json)
      : id = json['id'],
        color = json['color'],
        logo = json['logo'];

  Map toJson() {
    return {
      'id': id,
      'color': color,
      'logo': logo,
    };
  }
}

class BuildFromJsonBloc extends Cubit<List> {
  BuildFromJsonBloc(super.initialState);
  List<dynamic> suggestionsList = <dynamic>[];
  List<dynamic> partnersList = <dynamic>[];

  getSuggestionsFromApi(String from) async {
    getCharacters().then((response) {
      Map<String, dynamic> list = json.decode(response.body);
      if (from == 'partners') {
        partnersList =
            list[from].map((model) => PartnersModel.fromJson(model)).toList();
        emit(partnersList);
      } else if (from == "suggestions") {
        suggestionsList =
            list[from].map((model) => CharacterModel.fromJson(model)).toList();
        emit(suggestionsList);
      }
    });
  }
}
