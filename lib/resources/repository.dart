import 'package:glug_app/models/blog_response.dart';
import 'package:glug_app/models/carousel_response.dart';
import 'package:glug_app/models/event_response.dart';
import 'package:glug_app/models/linit_response.dart';
import 'package:glug_app/models/notice_model.dart';
import 'package:glug_app/models/profile_response.dart';
import 'package:glug_app/models/timeline_response.dart';
import 'package:glug_app/resources/api_provider.dart';
import 'package:connectivity/connectivity.dart';
import 'package:glug_app/resources/database_provider.dart';

class Repository {
  final _apiProvider = ApiProvider();

  Future<bool> _isConnected() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      print("Connected to Mobile Network");
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      print("Connected to WiFi");
      return true;
    } else {
      print("Unable to connect. Please Check Internet Connection");
      return false;
    }
  }

  bool localDBContains(List listItems, itemToBeSearched) {
    for (var item in listItems) {
      if (item.id == itemToBeSearched.id) return true;
    }
    return false;
  }

  Future<EventResponse> fetchAllEvents() async {
    bool connected = await _isConnected();

    if (connected) {
      EventResponse localDB =
          await DatabaseProvider.databaseProvider.fetchEventData();
      EventResponse apiData = await _apiProvider.fetchEventData();

      apiData.events.forEach((event) {
        if (!localDBContains(localDB.events, event)) {
          DatabaseProvider.databaseProvider.insertEvent(event);
        }
      });
      return _apiProvider.fetchEventData();
    } else {
      return DatabaseProvider.databaseProvider.fetchEventData();
    }
  }

  Future<BlogResponse> fetchAllBlogPosts() async {
    bool connected = await _isConnected();

    if (connected) {
      BlogResponse localDB =
          await DatabaseProvider.databaseProvider.fetchBlogData();
      BlogResponse apiData = await _apiProvider.fetchBlogData();

      apiData.blogPosts.forEach((blogPost) {
        if (!localDBContains(localDB.blogPosts, blogPost)) {
          DatabaseProvider.databaseProvider.insertBlog(blogPost);
        }
      });
      return _apiProvider.fetchBlogData();
    } else {
      return DatabaseProvider.databaseProvider.fetchBlogData();
    }
  }

  Future<LinitResponse> fetchAllLinitMagazines() async =>
      _apiProvider.fetchLinitData();

  Future<CarouselResponse> fetchAllCarouselData() async =>
      _apiProvider.fetchCarouselData();

  Future<ProfileResponse> fetchAllProfiles() async =>
      _apiProvider.fetchProfileData();

  Future<TimelineResponse> fetchAllTimelineData() async =>
      _apiProvider.fetchTimelineData();

  Future<Notice> fetchAllNotices() async => _apiProvider.fetchNoticeData();
}
