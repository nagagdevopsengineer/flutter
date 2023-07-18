import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gpapp/Controllers/NetworkControllers/ManualCalls.dart';
import 'package:gpapp/Controllers/NetworkControllers/Models.dart';
import 'package:gpapp/Screens/home_screen.dart';

class PreferenceController extends GetxController {
  var user = Member(
          firstname: "Member",
          lastname: "Name",
          userId: "Member ID",
          endDate: "${DateTime.now().year + 1}-01-01",
          isVeg: true,
          isVerified: false)
      .obs;
  var api = ManualAPICall();
  GetStorage ds = GetStorage();
  var isLoadingPreferences = true.obs;
  var isVeg = true.obs;
  var isEditClicked = false.obs;
  var masterTags = [].obs;
  var childTags = [].obs;
  RxList selectedChildTags = [].obs;
  RxList deselectedChildTags = [].obs;
  RxList selectedPreferencesTag = [].obs;
  RxList deselectedPreferencesTag = [].obs;
  RxBool isExpanded = false.obs;

  @override
  void onInit() async {
    await getUser(forceAPI: false);
    getSelectedMasterTags();
    getMasterTags(isVeg: isVeg);
    getChildTags();
    super.onInit();
  }

  checkIfContains(SelectedChildTag tag) {
    var contains = true;
    if (selectedChildTags.isEmpty) {
      contains = false;
      return contains;
    } else {
      for (var t in selectedChildTags) {
        if (tag.id! == t.id) {
          return contains;
        }
      }
      contains = false;
      return contains;
    }
  }

  removeSelectedTag(tagId) {
    for (var tag in selectedChildTags) {
      if (tag.childtagsid == tagId.toString()) {
        deselectedChildTags.add(tag);
      }
    }
  }

  Future<void> getUser({forceAPI = false}) async {
    if (ds.read('user') != null && !forceAPI) {
      user.value = Member.fromJson(jsonDecode(jsonEncode(ds.read('user'))));
    } else {
      var userId = await ds.read("userId");
      print("UID: $userId");
      user.value = await api.getMemeberDetails(userId: "${userId}");
    }

    isVeg.value = user.value.isVeg!;
    await getMasterTags(isVeg: isVeg);
    await getChildTags();
  }

  updateContinuosly() async {
    Timer.periodic(Duration(minutes: 1), (timer) async {
      if (!user.value.isVerified!) {
        var userId = await ds.read("userId");
        user.value = await api.getMemeberDetails(userId: "${userId}");
      }
    });
  }

  getMasterTags({isVeg}) async {
    masterTags.clear();
    masterTags.value = await api.getMasterTags(isVeg: isVeg);
  }

  getChildTags() async {
    childTags.clear();
    childTags.value = await api.getChildTags();
  }

  getSelectedMasterTags() async {
    await api.getSelectedMasterTags(user.value.id);
    if (isLoadingPreferences.value) {
      isLoadingPreferences.value = false;
    }
  }

  postTags({user}) async {
    var api = ManualAPICall();

    for (var i in selectedPreferencesTag) {
      await api.postMasterTags(i, user.id);
    }
  }

  deleteTags({user}) async {
    var api = ManualAPICall();
    for (var i = 0; i < deselectedPreferencesTag.length; i++) {
      await api.deleteMasterTags(deselectedPreferencesTag[i], user.id);
    }
  }
}
