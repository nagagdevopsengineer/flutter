import 'dart:convert';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpapp/ColorPallete.dart';
import 'package:gpapp/Controllers/NetworkControllers/ManualCalls.dart';
import 'package:gpapp/Controllers/NetworkControllers/Models.dart';
import 'package:gpapp/Controllers/PreferenceController.dart';
import 'package:gpapp/Widgets/CommonWidgets.dart';
import 'package:gpapp/Widgets/button_preference.dart';

selectPreferences(
    {masterTags, childTags, isEditable = false, required Member user}) {
  var c = Get.put(PreferenceController());

  return Get.defaultDialog(
    titlePadding: EdgeInsets.only(top: 25),
    contentPadding: EdgeInsets.symmetric(horizontal: 20),
    title: "Select your preferences",
    titleStyle: TextStyle(fontSize: 15),
    content: Flexible(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Wrap(
          spacing: 10.0,
          children: [
            SizedBox(
              height: 5,
            ),
            for (var i = 0; i < masterTags.length; i++)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: Get.width,
                    child: Text(
                      "${masterTags[i].name}",
                      textAlign: TextAlign.left,
                      style: GoogleFonts.inter(fontSize: 13),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Wrap(
                    spacing: 10,
                    children: [
                      for (var j = 0; j < childTags.length; j++)
                        if (childTags[j].mastertagid ==
                            masterTags[i].id.toString())
                          GestureDetector(
                            onTap: () {
                              if (isEditable) {
                                if (c.selectedPreferencesTag
                                        .contains(childTags[j].id) ==
                                    false) {
                                  c.selectedPreferencesTag.add(childTags[j].id);
                                  c.deselectedPreferencesTag
                                      .remove(childTags[j].id);
                                } else {
                                  c.selectedPreferencesTag
                                      .remove(childTags[j].id);
                                  c.deselectedPreferencesTag
                                      .add(childTags[j].id);
                                }
                              }
                            },
                            child: Obx(
                              () {
                                return choiceChipCustom(
                                    "${childTags[j].name}",
                                    c.selectedPreferencesTag.value
                                            .contains(childTags[j].id)
                                        ? true
                                        : false,
                                    j,
                                    childTags[j],
                                    isEditable: isEditable);
                              },
                            ),
                          ),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    ),
    confirm: Container(
      padding: const EdgeInsets.only(top: 5, bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 110,
            height: 40,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: ColorPallete.blue)),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  primary: ColorPallete.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  side: BorderSide(
                    width: 2,
                    color: ColorPallete.blue,
                  ),
                ),
                onPressed: () {
                  if (isEditable) {
                    var user = Member.fromJson(
                      json.decode(
                        json.encode(
                          GetStorage().read("user"),
                        ),
                      ),
                    );
                    Get.showOverlay(
                        loadingWidget: Center(
                          child: CircularProgressIndicator(
                              color: ColorPallete.primary),
                        ),
                        asyncFunction: () async {
                          if (isEditable) {
                            await c.postTags(
                                user: Member.fromJson(
                                    json.decode(json.encode(user))));
                            await c.deleteTags(
                                user: Member.fromJson(
                                    json.decode(json.encode(user))));
                          }
                        });
                  }
                  // c.deselectedPreferencesTag.clear();
                  Navigator.pop(Get.context!);
                },
                child: Center(
                    child: Text(
                  isEditable ? 'Save' : "Close",
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ))),
          ),
          SizedBox(
            width: 20,
          ),
          Container(
            width: 110,
            height: 40,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: ColorPallete.blue)),
            child: PrefernceButton(
                fontColor: ColorPallete.blue,
                borderWidth: 2,
                borderRadius: 30,
                title: 'Edit',
                horizontalPadding: 20,
                fontSize: 15,
                color: Colors.white,
                verticalPadding: 10,
                onPressed: () async {
                  Navigator.pop(Get.context!);
                  VegetarianDialog(user: c.user.value);
                }),
          ),
        ],
      ),
    ),
  );
}

Widget choiceChipCustom(String text, bool isSelected, int i, ChildTag childTag,
    {isEditable = false}) {
  var c = Get.put(PreferenceController());

  return Chip(
    label: Text(text),
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    side: BorderSide(
      color: !isSelected ? ColorPallete.grey : Color(0xff003087),
    ),
    deleteIcon: Icon(
      Icons.check_circle,
      color: !isSelected ? ColorPallete.grey : Color(0xff003087),
      size: 20,
    ),
    labelPadding: const EdgeInsets.only(left: 10, right: 10),
    onDeleted: () {
      if (isEditable) {
        if (c.selectedPreferencesTag.contains(childTag.id) == false) {
          c.selectedPreferencesTag.add(childTag.id);
          c.deselectedPreferencesTag.remove(childTag.id);
        } else {
          c.selectedPreferencesTag.remove(childTag.id);
          c.deselectedPreferencesTag.add(childTag.id);
        }
      }
    },
  );
}

Widget CustomChip({text, type, isSelected, onDeleted}) {
  return Chip(
    label: Text(text),
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    side: BorderSide(
      color: !isSelected ? ColorPallete.grey : Color(0xff003087),
    ),
    deleteIcon: Icon(
      Icons.check_circle,
      color: !isSelected ? ColorPallete.grey : Color(0xff003087),
      size: 20,
    ),
    labelPadding: const EdgeInsets.only(left: 10, right: 10),
    onDeleted: () {
      onDeleted.call();
    },
  );
}

VegetarianDialog({required Member user}) {
  var c = Get.put(PreferenceController());
  var api = ManualAPICall();
  Get.defaultDialog(
    titlePadding: EdgeInsets.only(top: 25),
    contentPadding: EdgeInsets.symmetric(horizontal: 20),
    title: "Select your preferences",
    titleStyle: TextStyle(fontSize: 15),
    content: Flexible(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Wrap(
          spacing: 10.0,
          children: [
            SizedBox(
              height: 5,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Are You Vegetarian?",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(fontSize: 13),
                ),
                SizedBox(
                  height: 8,
                ),
                Wrap(
                  spacing: 10,
                  children: [
                    GestureDetector(
                      onTap: () {
                        c.isVeg.value = true;
                        c.getMasterTags(isVeg: c.isVeg.value);
                        c.getChildTags();
                      },
                      child: Obx(() => CustomChip(
                          text: "Yes",
                          isSelected: c.isVeg.value,
                          onDeleted: () {
                            c.isVeg.value = true;
                            c.getMasterTags(isVeg: c.isVeg.value);
                            c.getChildTags();
                          })),
                    ),
                    GestureDetector(
                      onTap: () {
                        c.isVeg.value = false;
                        c.getMasterTags(isVeg: c.isVeg.value);
                        c.getChildTags();
                      },
                      child: Obx(() => CustomChip(
                          text: "No",
                          isSelected: c.isVeg.value == true ? false : true,
                          onDeleted: () {
                            c.isVeg.value = false;
                            c.getMasterTags(isVeg: c.isVeg.value);
                            c.getChildTags();
                          })),
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    ),
    confirm: Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: roundedButton(
        text: "Continue",
        onPressed: () async {
          Get.showOverlay(
              loadingWidget: Center(
                child: CircularProgressIndicator(color: ColorPallete.primary),
              ),
              asyncFunction: () async {
                await api.updateIsVeg(user: user, isVeg: c.isVeg.value);
                await c.getUser(forceAPI: true);
                Navigator.pop(Get.context!);
                selectPreferences(
                    isEditable: true,
                    user: user,
                    masterTags: c.masterTags,
                    childTags: c.childTags);
              });
        },
        isIcon: false,
        color: ColorPallete.blue,
        textColor: ColorPallete.white,
      ),
    ),
  );
}
