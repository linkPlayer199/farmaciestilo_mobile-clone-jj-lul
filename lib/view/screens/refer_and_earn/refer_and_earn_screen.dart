import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:share_plus/share_plus.dart';
import 'package:farmacie_stilo/controller/auth_controller.dart';
import 'package:farmacie_stilo/controller/splash_controller.dart';
import 'package:farmacie_stilo/controller/user_controller.dart';
import 'package:farmacie_stilo/helper/price_converter.dart';
import 'package:farmacie_stilo/helper/responsive_helper.dart';
import 'package:farmacie_stilo/util/dimensions.dart';
import 'package:farmacie_stilo/util/images.dart';
import 'package:farmacie_stilo/util/styles.dart';
import 'package:farmacie_stilo/view/base/custom_app_bar.dart';
import 'package:farmacie_stilo/view/base/custom_button.dart';
import 'package:farmacie_stilo/view/base/custom_snackbar.dart';
import 'package:farmacie_stilo/view/base/footer_view.dart';
import 'package:farmacie_stilo/view/base/menu_drawer.dart';
import 'package:farmacie_stilo/view/base/not_logged_in_screen.dart';

class ReferAndEarnScreen extends StatefulWidget {
  const ReferAndEarnScreen({Key? key}) : super(key: key);

  @override
  State<ReferAndEarnScreen> createState() => _ReferAndEarnScreenState();
}

class _ReferAndEarnScreenState extends State<ReferAndEarnScreen> {
  late bool _isLoggedIn;

  @override
  void initState() {
    super.initState();

    _isLoggedIn = Get.find<AuthController>().isLoggedIn();

    if (_isLoggedIn && Get.find<UserController>().userInfoModel == null) {
      Get.find<UserController>().getUserInfo();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const MenuDrawer(),
      endDrawerEnableOpenDragGesture: false,
      appBar: CustomAppBar(title: 'refer_and_earn'.tr),
      body: Center(
        child: _isLoggedIn
            ? SingleChildScrollView(
                child: FooterView(
                  child: SizedBox(
                    width: Dimensions.webMaxWidth,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.paddingSizeLarge),
                      child:
                          GetBuilder<UserController>(builder: (userController) {
                        return Column(children: [
                          const SizedBox(height: Dimensions.paddingSizeLarge),
                          Text('earn_money_on_every_referral'.tr,
                              style: robotoRegular.copyWith(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: Dimensions.fontSizeSmall)),
                          const SizedBox(
                              height: Dimensions.paddingSizeExtraSmall),
                          Text(
                            '${'one_referral'.tr}= ${PriceConverter.convertPrice(Get.find<SplashController>().configModel != null ? Get.find<SplashController>().configModel!.refEarningExchangeRate!.toDouble() : 0.0)}',
                            style: robotoBold.copyWith(
                                fontSize: Dimensions.fontSizeDefault),
                            textDirection: TextDirection.ltr,
                          ),
                          const SizedBox(height: 40),
                          Center(
                            child:
                                Row(mainAxisSize: MainAxisSize.min, children: [
                              Column(children: [
                                Image.asset(Images.referImage,
                                    width: ResponsiveHelper.isDesktop(context)
                                        ? 200
                                        : 100,
                                    height: ResponsiveHelper.isDesktop(context)
                                        ? 250
                                        : 150,
                                    fit: BoxFit.contain),
                                SizedBox(
                                  width: 120,
                                  child: Text(
                                      'refer_your_code_to_your_friend'.tr,
                                      style: robotoRegular.copyWith(
                                          fontSize: Dimensions.fontSizeSmall),
                                      textAlign: TextAlign.center),
                                ),
                              ]),
                              SizedBox(
                                  width: ResponsiveHelper.isDesktop(context)
                                      ? 150
                                      : 50),
                              Column(children: [
                                Image.asset(Images.earnMoney,
                                    width: ResponsiveHelper.isDesktop(context)
                                        ? 200
                                        : 100,
                                    height: ResponsiveHelper.isDesktop(context)
                                        ? 250
                                        : 150,
                                    fit: BoxFit.contain),
                                SizedBox(
                                  width: 120,
                                  child: Text(
                                      '${'get'.tr} ${PriceConverter.convertPrice(Get.find<SplashController>().configModel != null ? Get.find<SplashController>().configModel!.refEarningExchangeRate!.toDouble() : 0.0)} ${'on_joining'.tr}',
                                      style: robotoRegular.copyWith(
                                          fontSize: Dimensions.fontSizeSmall),
                                      textAlign: TextAlign.center,
                                      textDirection: TextDirection.ltr),
                                ),
                              ]),
                            ]),
                          ),
                          const SizedBox(
                              height: Dimensions.paddingSizeExtraLarge),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('your_referral_code'.tr,
                                    style: robotoRegular.copyWith(
                                        color: Theme.of(context).disabledColor,
                                        fontSize: Dimensions.fontSizeDefault)),
                                const SizedBox(
                                    height: Dimensions.paddingSizeSmall),
                                DottedBorder(
                                  color: Theme.of(context).primaryColor,
                                  strokeWidth: 1,
                                  strokeCap: StrokeCap.butt,
                                  dashPattern: const [8, 5],
                                  padding: const EdgeInsets.all(0),
                                  borderType: BorderType.RRect,
                                  radius: const Radius.circular(
                                      Dimensions.radiusSmall),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal:
                                            Dimensions.paddingSizeLarge),
                                    height: 50,
                                    decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .primaryColor
                                            .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(
                                            Dimensions.radiusSmall)),
                                    child: (userController.userInfoModel !=
                                            null)
                                        ? Row(children: [
                                            Expanded(
                                              child: Text(
                                                userController.userInfoModel !=
                                                        null
                                                    ? userController
                                                            .userInfoModel!
                                                            .refCode ??
                                                        ''
                                                    : '',
                                                style: robotoBlack.copyWith(
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    fontSize: Dimensions
                                                        .fontSizeExtraLarge),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                if (userController
                                                    .userInfoModel!
                                                    .refCode!
                                                    .isNotEmpty) {
                                                  Clipboard.setData(ClipboardData(
                                                      text:
                                                          '${userController.userInfoModel != null ? userController.userInfoModel!.refCode : ''}'));
                                                  showCustomSnackBar(
                                                      'referral_code_copied'.tr,
                                                      isError: false);
                                                }
                                              },
                                              child: Text('tap_to_copy'.tr,
                                                  style: robotoMedium),
                                            ),
                                          ])
                                        : const CircularProgressIndicator(),
                                  ),
                                ),
                              ]),
                          const SizedBox(height: Dimensions.paddingSizeLarge),
                          CustomButton(
                              buttonText: 'share'.tr,
                              icon: Icons.share,
                              onPressed: () => Share.share(
                                  '${'this_is_my_refer_code'.tr}: ${userController.userInfoModel!.refCode}')),
                        ]);
                      }),
                    ),
                  ),
                ),
              )
            : const NotLoggedInScreen(),
      ),
    );
  }
}
