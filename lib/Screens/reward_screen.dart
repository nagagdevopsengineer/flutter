import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpapp/Controllers/CommonController.dart';
import 'package:gpapp/Controllers/NetworkControllers/ManualCalls.dart';
import 'package:gpapp/Widgets/CommonWidgets.dart';
import 'package:gpapp/Widgets/rewardsCard.dart';
import 'package:gpapp/models/RewardsModel.dart';
import 'package:gpapp/utils/colors.dart';
import 'package:intl/intl.dart';

import '../Controllers/NetworkControllers/Models.dart';

class RewardScreen extends StatefulWidget {
  const RewardScreen({Key? key}) : super(key: key);

  @override
  State<RewardScreen> createState() => _RewardScreenState();
}

class _RewardScreenState extends State<RewardScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  ManualAPICall api = ManualAPICall();
  var c = Get.find<CommonController>();
  GetStorage ds = GetStorage();
  List rewards = [];
  var isRewardLoading = true;
  CommonController commonControl = Get.put(CommonController());
  var use;

  getRewards({forceAPI = true}) async {
    var r = ds.read('rewards');
    if (r != null && !forceAPI) {
      for (var reward in jsonDecode(r)) {
        rewards.add(RewardsModel.fromJson(reward));
      }
      //rewards.sort((a, b) => b.rewardspoints!.compareTo(a.rewardspoints!));
    } else {
      rewards = await ManualAPICall().getRewards(userId: c.user.value.id);
    }
    //rewards.sort((a, b) => b.rewardspoints!.compareTo(a.rewardspoints!));
    //}
    // if(rewards.isNotEmpty){
    //   rewards.sort((a, b) => b.rewardspoints!.compareTo(a.rewardspoints!));
    // }

    // if (rewards.isNotEmpty) {
    //   rewards.sort(
    //     (a, b) => DateTime.parse(a.createdat).compareTo(
    //       DateTime.parse(b.createdat),
    //     ),
    //   );
    // }
    setState(() {
      isRewardLoading = false;
    });
  }

  getUser({forceAPI = true}) async {
    print("Welcome");
    var userId = await ds.read("userId");
    print("$userId IrrashaiMasheen");
    print(userId.value.rewardspoints);
    use = await api.getMemeberDetails(userId: "${userId}");
    print(use.value.rewardspoints);
    print("Welcome To The Jungle");
    return;
  }

  @override
  void initState() {
    getUser();
    c.getUser();
    getRewards(forceAPI: true);
    commonControl.getNotificationReadStatus(forceapi: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      backgroundColor: ColorPallete.backgroud,
      drawer: drawerWidget(c.user.value, context: context, key: _key),
      appBar: AppBarWidget(
        _key,
        title: " Rewards",
        isBack: true,
      ),
      body: isRewardLoading
          ? Center(
              child: CircularProgressIndicator(color: ColorPallete.primary),
            )
          : rewards.isEmpty
              ? Container(
                  height: Get.height,
                  width: Get.width,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("No Rewards Available",
                          style: TextStyle(
                              fontSize: 25,
                              color: ColorPallete.blue,
                              fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: 60,
                      )
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () async {
                    await getRewards(forceAPI: true);
                  },
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 8,
                          shadowColor: Colors.grey.shade100,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Total Rewards',
                                  style: GoogleFonts.inter(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  '${double.parse(c.user.value.rewardspoints).round()}',
                                  style: GoogleFonts.inter(
                                    fontSize: 19,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: rewards.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              RewardsCard(
                                restaurantName:
                                    "${rewards[index]!.restaurants?.name}",
                                billAmount: "${rewards[index]!.billamount}",
                                date:
                                    "${DateFormat("dd/MM/yyyy").format(DateTime.parse("${rewards[index]!.createdat}").toLocal())}",
                                points: "${rewards[index]!.rewardspoints}",
                                finalamount: "${rewards[index]!.finalamount}",
                              ),
                              SizedBox(
                                height: 20,
                              )
                            ],
                          );
                        },
                      )
                    ],
                  ),
                ),
    );
  }
}
