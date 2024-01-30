import 'dart:convert';

import 'package:farmacie_stilo/controller/auth_controller.dart';
import 'package:farmacie_stilo/controller/banner_controller.dart';
import 'package:farmacie_stilo/controller/booking_checkout_controller.dart';
import 'package:farmacie_stilo/controller/campaign_controller.dart';
import 'package:farmacie_stilo/controller/car_selection_controller.dart';
import 'package:farmacie_stilo/controller/cart_controller.dart';
import 'package:farmacie_stilo/controller/category_controller.dart';
import 'package:farmacie_stilo/controller/chat_controller.dart';
import 'package:farmacie_stilo/controller/coupon_controller.dart';
import 'package:farmacie_stilo/controller/localization_controller.dart';
import 'package:farmacie_stilo/controller/location_controller.dart';
import 'package:farmacie_stilo/controller/notification_controller.dart';
import 'package:farmacie_stilo/controller/onboarding_controller.dart';
import 'package:farmacie_stilo/controller/order_controller.dart';
import 'package:farmacie_stilo/controller/item_controller.dart';
import 'package:farmacie_stilo/controller/parcel_controller.dart';
import 'package:farmacie_stilo/controller/rider_controller.dart';
import 'package:farmacie_stilo/controller/store_controller.dart';
import 'package:farmacie_stilo/controller/search_controller.dart';
import 'package:farmacie_stilo/controller/splash_controller.dart';
import 'package:farmacie_stilo/controller/theme_controller.dart';
import 'package:farmacie_stilo/controller/user_controller.dart';
import 'package:farmacie_stilo/controller/wallet_controller.dart';
import 'package:farmacie_stilo/controller/wishlist_controller.dart';
import 'package:farmacie_stilo/data/repository/auth_repo.dart';
import 'package:farmacie_stilo/data/repository/banner_repo.dart';
import 'package:farmacie_stilo/data/repository/campaign_repo.dart';
import 'package:farmacie_stilo/data/repository/car_selection_repo.dart';
import 'package:farmacie_stilo/data/repository/cart_repo.dart';
import 'package:farmacie_stilo/data/repository/category_repo.dart';
import 'package:farmacie_stilo/data/repository/coupon_repo.dart';
import 'package:farmacie_stilo/data/repository/language_repo.dart';
import 'package:farmacie_stilo/data/repository/location_repo.dart';
import 'package:farmacie_stilo/data/repository/notification_repo.dart';
import 'package:farmacie_stilo/data/repository/onboarding_repo.dart';
import 'package:farmacie_stilo/data/repository/order_repo.dart';
import 'package:farmacie_stilo/data/repository/item_repo.dart';
import 'package:farmacie_stilo/data/repository/parcel_repo.dart';
import 'package:farmacie_stilo/data/repository/rider_repo.dart';
import 'package:farmacie_stilo/data/repository/store_repo.dart';
import 'package:farmacie_stilo/data/repository/search_repo.dart';
import 'package:farmacie_stilo/data/repository/splash_repo.dart';
import 'package:farmacie_stilo/data/api/api_client.dart';
import 'package:farmacie_stilo/data/repository/user_repo.dart';
import 'package:farmacie_stilo/data/repository/wallet_repo.dart';
import 'package:farmacie_stilo/data/repository/wishlist_repo.dart';
import 'package:farmacie_stilo/util/app_constants.dart';
import 'package:farmacie_stilo/data/model/response/language_model.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import '../data/repository/chat_repo.dart';

Future<Map<String, Map<String, String>>> init() async {
  // Core
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.lazyPut(() => sharedPreferences);
  Get.lazyPut(() => ApiClient(
      appBaseUrl: AppConstants.baseUrl, sharedPreferences: Get.find()));

  // Repository
  Get.lazyPut(
      () => SplashRepo(sharedPreferences: Get.find(), apiClient: Get.find()));
  Get.lazyPut(() => LanguageRepo());
  Get.lazyPut(() => OnBoardingRepo());
  Get.lazyPut(
      () => AuthRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(
      () => LocationRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => UserRepo(sharedPreferences: Get.find(),  apiClient: Get.find()));
  Get.lazyPut(() => BannerRepo(apiClient: Get.find()));
  Get.lazyPut(() => CategoryRepo(apiClient: Get.find()));
  Get.lazyPut(() => StoreRepo(apiClient: Get.find()));
  Get.lazyPut(() => WishListRepo(apiClient: Get.find()));
  Get.lazyPut(() => ItemRepo(apiClient: Get.find()));
  Get.lazyPut(() => CartRepo(sharedPreferences: Get.find()));
  Get.lazyPut(
      () => SearchRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => CouponRepo(apiClient: Get.find()));
  Get.lazyPut(
      () => OrderRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() =>
      NotificationRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => CampaignRepo(apiClient: Get.find()));
  Get.lazyPut(() => ParcelRepo(apiClient: Get.find()));
  Get.lazyPut(() => WalletRepo(apiClient: Get.find()));
  Get.lazyPut(
      () => ChatRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(
      () => RiderRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => CarSelectionRepo(apiClient: Get.find()));

  // Controller
  Get.lazyPut(() => ThemeController(sharedPreferences: Get.find()));
  Get.lazyPut(() => SplashController(splashRepo: Get.find()));
  Get.lazyPut(() => LocalizationController(
      sharedPreferences: Get.find(), apiClient: Get.find()));
  Get.lazyPut(() => OnBoardingController(onboardingRepo: Get.find()));
  Get.lazyPut(() => AuthController(authRepo: Get.find()));
  Get.lazyPut(() => LocationController(locationRepo: Get.find()));
  Get.lazyPut(() => UserController(userRepo: Get.find()));
  Get.lazyPut(() => BannerController(bannerRepo: Get.find()));
  Get.lazyPut(() => CategoryController(categoryRepo: Get.find()));
  Get.lazyPut(() => ItemController(itemRepo: Get.find()));
  Get.lazyPut(() => CartController(cartRepo: Get.find()));
  Get.lazyPut(() => StoreController(storeRepo: Get.find()));
  Get.lazyPut(
      () => WishListController(wishListRepo: Get.find(), itemRepo: Get.find()));
  Get.lazyPut(() => SearchController(searchRepo: Get.find()));
  Get.lazyPut(() => CouponController(couponRepo: Get.find()));
  Get.lazyPut(() => OrderController(orderRepo: Get.find()));
  Get.lazyPut(() => NotificationController(notificationRepo: Get.find()));
  Get.lazyPut(() => CampaignController(campaignRepo: Get.find()));
  Get.lazyPut(() => ParcelController(parcelRepo: Get.find()));
  Get.lazyPut(() => WalletController(walletRepo: Get.find()));
  Get.lazyPut(() => ChatController(chatRepo: Get.find()));
  Get.lazyPut(() => RiderController(riderRepo: Get.find()));
  Get.lazyPut(() => CarSelectionController(carSelectionRepo: Get.find()));
  Get.lazyPut(() => BookingCheckoutController(riderRepo: Get.find()));

  // Retrieving localized data
  Map<String, Map<String, String>> languages = {};
  for (LanguageModel languageModel in AppConstants.languages) {
    String jsonStringValues = await rootBundle
        .loadString('assets/language/${languageModel.languageCode}.json');
    Map<String, dynamic> mappedJson = jsonDecode(jsonStringValues);
    Map<String, String> json = {};
    mappedJson.forEach((key, value) {
      json[key] = value.toString();
    });
    languages['${languageModel.languageCode}_${languageModel.countryCode}'] =
        json;
  }
  return languages;
}
