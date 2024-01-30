import 'package:farmacie_stilo/data/api/api_client.dart';
import 'package:farmacie_stilo/data/model/response/userinfo_model.dart';
import 'package:farmacie_stilo/util/app_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepo {
  final SharedPreferences sharedPreferences;
  final ApiClient apiClient;

  UserRepo({required this.apiClient,required this.sharedPreferences});

  Future<Response> getUserInfo() async {
    return await apiClient.getData(AppConstants.customerInfoUri);
  }

 void saveId(int id)  {
    try {
      sharedPreferences.setInt("user_id", id);
      final get = sharedPreferences?.getInt("user_id");


    if (kDebugMode) {
      print(get);
    }
    } catch (e) {
      rethrow;
    }
  }


  Future<Response> updateProfile(
      UserInfoModel userInfoModel, XFile? data, String token) async {
    Map<String, String> body = {
      'f_name': userInfoModel.fName!,
      'l_name': userInfoModel.lName!,
      'email': userInfoModel.email!,
    };
    return await apiClient.postMultipartData(
        AppConstants.updateProfileUri, body, [MultipartBody('image', data)]);
  }

  Future<Response> changePassword(UserInfoModel userInfoModel) async {
    return await apiClient.postData(AppConstants.updateProfileUri, {
      'f_name': userInfoModel.fName,
      'l_name': userInfoModel.lName,
      'email': userInfoModel.email,
      'password': userInfoModel.password,
    });
  }

  Future<Response> deleteUser() async {
    return await apiClient.deleteData(AppConstants.customerRemoveUri);
  }
}
