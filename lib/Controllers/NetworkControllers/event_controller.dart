// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:gpapp/Controllers/NetworkControllers/ManualCalls.dart';
// import 'package:gpapp/Controllers/NetworkControllers/Models.dart';

// class EventController extends GetxController {
//   int page = 0;
//   var firstTask = List<dynamic>.empty(growable: true).obs;
//   List<Event> events = [];
//   ScrollController controller = ScrollController();
//   late int listLength;
//   ScrollController scrollController = ScrollController();
//   var isMoreDataAvailable = true.obs;
//   var isDataProcessing = false.obs;

//   @override
//   void onInit() {
//     // TODO: implement onInit
//     super.onInit();
//     getEvents(page);
//     paginateTask();
//   }

//   void getEvents(var page) {
//     try {
//       isMoreDataAvailable(false);
//       isDataProcessing(true);
//       ManualAPICall().getEvents(page).then((resp) {
//         isDataProcessing(false);
//         firstTask.addAll(resp);
//       }, onError: (err) {
//         isDataProcessing(false);
//         // print('failed to get events');
//       });
//     } catch (exception) {
//       isDataProcessing(false);
//       // print('failed to get events');
//     }
//   }

//   void paginateTask() {
//     scrollController.addListener(() {
//       if (scrollController.position.pixels ==
//           scrollController.position.maxScrollExtent) {
//         // print("Reached end");
//         getMoreEvents(page);
//         page++;
//         firstTask.addAll(events);
//       }
//     });
//   }

//   void getMoreEvents(var page) {
//     try {
//       ManualAPICall().getEvents(page).then((resp) {
//         if (resp.length > 0) {
//           isMoreDataAvailable(true);
//         } else {
//           isMoreDataAvailable(false);
//         }
//         firstTask.addAll(resp);
//       }, onError: (err) {
//         isMoreDataAvailable(false);
//       });
//     } catch (exception) {
//       isMoreDataAvailable(false);
//     }
//   }

//   // Refresh List
//   void refreshList() async {
//     page = 0;
//     getEvents(page);
//   }
// }
