import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gpapp/Constants.dart';
import 'package:gpapp/Controllers/CommonController.dart';
import 'package:gpapp/Controllers/NetworkControllers/ManualCalls.dart';
import 'package:gpapp/Controllers/NetworkControllers/Models.dart';
import 'package:gpapp/Controllers/PreferenceController.dart';
import 'package:gpapp/Widgets/CameraWidget.dart';
import 'package:gpapp/utils/colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'CommonWidgets.dart';

class ProfileCard extends StatefulWidget {
  Member user;
  ProfileCard({Key? key, required this.user, required this.context})
      : super(key: key);
  final BuildContext context;
  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  List restaurants = [];
  List hotels = [];
  GetStorage ds = GetStorage();
  var api = ManualAPICall();
  List uniquelistOfHotels = [];
  List uniquelistOfRestaurants = [];
  var count = 0;
  var c = Get.find<PreferenceController>();
  var commonController = Get.find<CommonController>();

  getRestaurants({hotelId}) async {
    uniquelistOfRestaurants = [];
    restaurants = [];
    if (ds.read('restaurants') != null) {
      var e = json.decode(json.encode(ds.read("restaurants")));
      for (var i in e) {
        Restaurant rest = Restaurant.fromJson(i);
        if (rest.restaurantsGroupsId == hotelId) {
          restaurants.add(rest);
        }
      }
    } else {
      restaurants = await api.getRestaurants();
    }
    var seen = Set();
    uniquelistOfRestaurants =
        restaurants.where((restaurants) => seen.add(restaurants)).toList();

    uniquelistOfRestaurants.sort(((a, b) {
      return a.name.toUpperCase().compareTo(b.name.toUpperCase());
    }));

    setState(() {});
  }

  void getHotels({forceAPI = false}) async {
    if (ds.read('hotels') != null) {
      var e = json.decode(json.encode(ds.read("hotels")));
      for (var i in e) {
        hotels.add(Hotel.fromJson(i));
      }
    } else {
      hotels = await api.getRestaurantsGroup();
    }
    hotels = await api.getRestaurantsGroup();
    var seen = Set();
    uniquelistOfHotels = hotels.where((hotels) => seen.add(hotels)).toList();

    uniquelistOfHotels.sort(((a, b) {
      return a.name.toUpperCase().compareTo(b.name.toUpperCase());
    }));

    setState(() {});
  }

  loadHotelFromAPI() async {
    hotels = await api.getRestaurantsGroup();
    setState(() {});
  }

  getUser() async {
    widget.user = Member.fromJson(json.decode(json.encode(ds.read('user'))));
    c.getUser(forceAPI: true);
    setState(() {});
  }

  final GlobalKey hotelDropKey = GlobalKey();
  BuildContext? ProfileContext;
  File? profilePic;

  @override
  void initState() {
    ProfileContext = widget.context;
    getHotels();

    if (commonController.imageFile != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        uploadImage();
      });
    }

    profileImageUrl = widget.user.image;
    super.initState();
  }

  String? selectedState;
  String? selectedHotel;
  bool isRestaurantSelected = false;
  bool isHotelSelected = false;
  Uint8List? _file;
  var profileImageUrl;

  uploadImage() async {
    Get.showOverlay(
        asyncFunction: () async {
          try {
            // var file = await pickImage(
            //   ImageSource.camera,
            // );
            var file = await commonController.imageFile!.readAsBytes();
            if (file == null) {
              return;
            }
            final tempDir = await getTemporaryDirectory();
            profilePic = await File(
                    '${tempDir.path}/image-${DateTime.now().toString()}.png')
                .create();
            profilePic!.writeAsBytesSync(file);

            var location =
                await ManualAPICall().uploadProfilePicture(profilePic!);

            await ManualAPICall()
                .updateProfilePic(user: widget.user, imageUrl: location);

            await ManualAPICall().getMemeberDetails(
              userId: widget.user.userId,
            );

            await getUser();

            if (mounted)
              setState(() {
                _file = file;
                profileImageUrl = location;
                commonController.imageFile = null;
              });
          } catch (e) {
            print("Error: $e");
          }
        },
        loadingWidget: Center(
          child: CircularProgressIndicator(),
        ));
  }

  _selectImage(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Update Profile Pic'),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a photo'),
                onPressed: () async {
                  Get.showOverlay(
                      loadingWidget: Center(
                        child: CircularProgressIndicator(
                            color: ColorPallete.primary),
                      ),
                      asyncFunction: () async {
                        Navigator.of(context).pop();
                        if (Platform.isAndroid) {
                          Map<Permission, PermissionStatus> statuses = await [
                            Permission.camera,
                            Permission.microphone,
                          ].request();

                          if (await Permission.camera.status.isDenied ==
                                  false &&
                              await Permission.microphone.status.isDenied ==
                                  false) {
                            Get.to(() => CameraApp(
                                cameras: Get.find<CommonController>()
                                    .availableCamera));
                            return;
                          } else {
                            Get.defaultDialog(
                                title: "Allow Permission",
                                titlePadding:
                                    EdgeInsets.symmetric(vertical: 20),
                                content: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                      "Open Settings to Allow Camera Permission"),
                                ),
                                confirm: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: TextButton(
                                          onPressed: () {
                                            openAppSettings();
                                            Navigator.pop(Get.context!);
                                          },
                                          child: Text("Open Settings")),
                                    ),
                                  ],
                                ));
                          }
                        } else {
                          try {
                            var file = await pickImage(
                              ImageSource.camera,
                            );
                            if (file == null) {
                              return;
                            }
                            final tempDir = await getTemporaryDirectory();
                            profilePic = await File(
                                    '${tempDir.path}/image-${DateTime.now().toString()}.png')
                                .create();
                            profilePic!.writeAsBytesSync(file);

                            var location = await ManualAPICall()
                                .uploadProfilePicture(profilePic!);

                            await ManualAPICall().updateProfilePic(
                                user: widget.user, imageUrl: location);

                            await ManualAPICall().getMemeberDetails(
                              userId: widget.user.userId,
                            );

                            await getUser();

                            if (mounted)
                              setState(() {
                                _file = file;
                                profileImageUrl = location;
                              });
                          } catch (e) {
                            print(e);
                          }
                        }
                      });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose from Gallery'),
                onPressed: () async {
                  Get.showOverlay(
                      loadingWidget: Center(
                        child: CircularProgressIndicator(
                            color: ColorPallete.primary),
                      ),
                      asyncFunction: (() async {
                        Navigator.of(context).pop(true);
                        try {
                          var file = await pickImage(
                            ImageSource.gallery,
                          );

                          if (file == null) {
                            return;
                          }
                          final tempDir = await getTemporaryDirectory();
                          profilePic = await File(
                                  '${tempDir.path}/image-${DateTime.now().toString()}.png')
                              .create();
                          profilePic!.writeAsBytesSync(file);

                          var location = await ManualAPICall()
                              .uploadProfilePicture(profilePic!);

                          await ManualAPICall().updateProfilePic(
                              user: widget.user, imageUrl: location);

                          await ManualAPICall().getMemeberDetails(
                            userId: widget.user.userId,
                          );

                          await getUser();

                          if (mounted)
                            setState(() {
                              _file = file;
                              profileImageUrl = location;
                            });
                        } catch (e) {
                          print(e);
                        }
                      }));
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        left: 15,
        right: 15,
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.only(top: 60),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  width: Get.width,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 80),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${widget.user.firstname ?? "Name"} ${widget.user.lastname ?? ""}",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                SizedBox(
                                  width: 150,
                                  child: Text(
                                    "${widget.user.isVerified! ? widget.user.memberid ?? "Member ID" : "Not issued yet."}",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 13),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    widget.user.isVerified!
                                        ? Image.asset(
                                            "assets/images/verifiedIcon.png",
                                            height: 12,
                                            width: 12,
                                          )
                                        : Image.asset(
                                            "assets/images/notVerified.png",
                                            height: 12,
                                            width: 12,
                                            color: widget.user.image ==
                                                    Constants()
                                                        .DEFAULT_PROFILE_IMAGE
                                                ? null
                                                : Colors.yellow[900],
                                          ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    widget.user.isVerified!
                                        ? Text(
                                            "Verified",
                                            style: TextStyle(
                                                color: ColorPallete.green,
                                                fontSize: 12),
                                          )
                                        : widget.user.image ==
                                                Constants()
                                                    .DEFAULT_PROFILE_IMAGE
                                            ? Text(
                                                "Not Verified",
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 12),
                                              )
                                            : Text(
                                                "Verification Pending",
                                                style: TextStyle(
                                                    color: Colors.yellow[900],
                                                    fontSize: 12),
                                              )
                                  ],
                                )
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "Validity",
                                  style: TextStyle(
                                      color: ColorPallete.grey, fontSize: 15),
                                ),
                                Text(
                                  "${widget.user.isVerified! ? DateFormat("dd-MM-yyyy").format(DateTime.parse(widget.user.endDate!).toLocal()) : "--/--/----"}",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  height: 24,
                                )
                              ],
                            )
                          ],
                        ),
                        !widget.user.isDeleted!
                            ? SizedBox(
                                height: 20,
                              )
                            : Container(),
                        !widget.user.isDeleted!
                            ? Container(
                                height: 46,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 0),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      color: Colors.grey.shade500, width: 1.5),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: DropdownButton<String>(
                                        key: hotelDropKey,
                                        value: selectedHotel,
                                        underline: Container(),
                                        icon: Expanded(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Icon(
                                                Icons
                                                    .keyboard_arrow_down_outlined,
                                                color: ColorPallete.grey,
                                              ),
                                            ],
                                          ),
                                        ),
                                        hint: Text(
                                            selectedHotel ?? "Select Hotel"),
                                        items: uniquelistOfHotels
                                            .map(
                                              (e) => DropdownMenuItem(
                                                value: e.id.toString(),
                                                child: Text(e.name ?? ""),
                                              ),
                                            )
                                            .toList(),
                                        onChanged: (s) async {
                                          getRestaurants(hotelId: s);
                                          setState(() {
                                            selectedState = null;
                                            isRestaurantSelected = false;
                                            selectedHotel = s;
                                            isHotelSelected = true;
                                            // ds.write("selectedHotel", selectedHotel);
                                            // ds.write(
                                            //     'isHotelSelected', isHotelSelected);
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ))
                            : Container(),
                        !widget.user.isDeleted!
                            ? SizedBox(
                                height: 10,
                              )
                            : Container(),
                        !widget.user.isDeleted!
                            ? Container(
                                height: 46,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 0),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      color: Colors.grey.shade500, width: 1.5),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: DropdownButton<String>(
                                        value: selectedState,
                                        underline: Container(),
                                        icon: Expanded(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Icon(
                                                Icons
                                                    .keyboard_arrow_down_outlined,
                                                color: ColorPallete.grey,
                                              ),
                                            ],
                                          ),
                                        ),
                                        hint: Text(selectedState ??
                                            "Select Restaurant"),
                                        items: uniquelistOfRestaurants
                                            .map(
                                              (e) => DropdownMenuItem(
                                                value: e.id.toString(),
                                                child: Text(e.name ?? ""),
                                              ),
                                            )
                                            .toList(),
                                        onChanged: (s) {
                                          setState(() {
                                            selectedState = s;
                                            isRestaurantSelected = true;
                                            // ds.write(
                                            //     "selectedRestaurant", selectedState);
                                            // ds.write('isRestaurantSelected',
                                            //     isRestaurantSelected);
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Container(),
                        const SizedBox(
                          height: 20,
                        ),
                        if (isRestaurantSelected == true)
                          Column(
                            children: [
                              QRCard(
                                  user: widget.user,
                                  restaurantID: selectedState ?? ""),
                            ],
                          )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: widget.user.isVerified!
                    ? CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.transparent,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(60.0),
                          child: CachedNetworkImage(
                            imageUrl: "${widget.user.image}",
                            fit: BoxFit.cover,
                            height: 120,
                            width: 120,
                            placeholder: profilePic == null
                                ? (context, url) => Center(
                                      child: CircularProgressIndicator(
                                        color: ColorPallete.primary,
                                      ),
                                    )
                                : (context, url) => Image.file(
                                      profilePic!,
                                      height: 120,
                                      width: 120,
                                      fit: BoxFit.cover,
                                    ),
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          _selectImage(context);
                        },
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.transparent,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(60.0),
                            child: CachedNetworkImage(
                              imageUrl: "${widget.user.image}",
                              fit: BoxFit.cover,
                              height: 120,
                              width: 120,
                              placeholder: profilePic == null
                                  ? (context, url) => Center(
                                        child: CircularProgressIndicator(
                                          color: ColorPallete.primary,
                                        ),
                                      )
                                  : (context, url) => Image.file(
                                        profilePic!,
                                        height: 120,
                                        width: 120,
                                        fit: BoxFit.cover,
                                      ),
                            ),
                          ),
                          // backgroundImage: widget.user.image !=
                          //         Constants().DEFAULT_PROFILE_IMAGE
                          //     ? CachedNetworkImageProvider(
                          //         "${widget.user.image}",
                          //       )
                          //     : Image.asset("assets/images/ImageLogo.png")
                          //         .image,
                        ),
                      ),
              ),
              widget.user.isVerified!
                  ? Container()
                  : Positioned(
                      bottom: 0,
                      left: MediaQuery.of(context).size.width * 0.5,
                      child: Align(
                        //alignment: Alignment(0.2, 0.2),
                        child: GestureDetector(
                          onTap: () {
                            _selectImage(context);
                          },
                          child: const CircleAvatar(
                            backgroundColor: ColorPallete.backgroud,
                            radius: 15,
                            child: Icon(
                              Icons.camera_alt,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ],
      ),
    );
  }
}
