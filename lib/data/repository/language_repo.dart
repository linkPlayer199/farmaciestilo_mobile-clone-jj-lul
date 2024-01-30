import 'package:farmacie_stilo/data/model/response/language_model.dart';
import 'package:farmacie_stilo/util/app_constants.dart';
import 'package:flutter/material.dart';

class LanguageRepo {
  List<LanguageModel> getAllLanguages({BuildContext? context}) {
    return AppConstants.languages;
  }
}
