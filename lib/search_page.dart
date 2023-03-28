import 'package:dart_twitter_api/twitter_api.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:trenifyv1/settings.dart';

class SearchPage extends StatefulWidget {
  String tweetItself = "";

  SearchPage(this.tweetItself, {Key? key}) : super(key: key);

  static List twitterList = [];

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  static String consumerApiKey = "3CSWEz90VoTSuHHQjc7DQgvwQ";
  static String consumerApiSecret =
      "gTwuNxcnThwDchRZ6cq3nS9VX5Hja8iAWkF6OMnXQaSWza6QdE";
  static String accessToken =
      "1284682835559944193-tF0gpkzODSpQiJnjevgumsB2i0R40E";
  static String accessTokenSecret =
      "pUsnhepYa6cRywfFkdNcmgxLPZTXvyXhndp26cTdUIcb9";

  bool isLoading = false;

  final twitterApi = TwitterApi(
      client: TwitterClient(
          consumerKey: consumerApiKey,
          consumerSecret: consumerApiSecret,
          token: accessToken,
          secret: accessTokenSecret));

  @override
  void initState() {
    searchTweets(widget.tweetItself);
    super.initState();
  }

  Future<void> searchTweets(String query) async {
    setState(() {
      isLoading = true;
    });
    final homeTimeline = await twitterApi.tweetSearchService
        .searchTweets(q: query, count: 30, tweetMode: "extended");
    // int p = 0;
    for (var tweet in homeTimeline.statuses!) {
      setState(() {
        //MyApp.tweetList.add(tweet.fullText!);

        SearchPage.twitterList.add(tweet);
        if (SearchPage.twitterList.length > 20) {
          SearchPage.twitterList.removeLast();
        }
        //.user.location  tweet.,
      });
      //print(SearchPage.twitterList[p].fullText);
      // p++;
    }
    // print(SearchPage.twitterList[3].fullText);
    setState(() {
      isLoading = false;
    });
    getList();
  }

  List getList() {
    return SearchPage.twitterList;
  }

  final List<int> items = [
    3,
    5,
    10,
    15,
    20,
  ];
  int selectedValue = 20;

  @override
  Widget build(BuildContext context) {
    //searchTweets(widget.tweetItself);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.tweetItself, textAlign: TextAlign.start),
          actions: [
            // Center(
            //   child: Icon(
            //     Icons.format_list_numbered_outlined
            //   )
            // ),
            // Align(
            //     alignment: Alignment.centerRight,
            //     child: Text('Recent',textAlign: TextAlign.center,)),
            DropdownButtonHideUnderline(
              child: DropdownButton2(
                isExpanded: true,
                items: items
                    .map((item) => DropdownMenuItem<int>(
                          value: item,
                          child: Text(
                            '$item',
                            style: SettingsPage.isDark
                                ? const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)
                                : const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ))
                    .toList(),
                value: selectedValue,
                onChanged: (value) {
                  setState(() {
                    selectedValue = value as int;
                  });
                },
                icon: const Icon(
                  //   Icons.arrow_forward_ios_outlined,

                  Icons.format_list_numbered_outlined, color: Colors.white,
                ),
                iconSize: 20,
                // iconEnabledColor: Colors.yellow,
                // iconDisabledColor: Colors.grey,
                buttonWidth: 70,
                buttonPadding: const EdgeInsets.only(left: 14, right: 14),
                // buttonDecoration: BoxDecoration(
                //   borderRadius: BorderRadius.circular(14),
                //   // border: Border.all(
                //   // color: Colors.black26,
                //   // ),
                //   color: Color(0xFFFFFF).withOpacity(0.13),
                // ),
                buttonElevation: 2,
                itemHeight: 40,
                itemPadding: const EdgeInsets.only(left: 14, right: 14),
                dropdownMaxHeight: 200,
                dropdownWidth: 200,
                dropdownPadding: null,
                dropdownDecoration: SettingsPage.isDark
                    ? BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [ Colors.lightBlueAccent,Colors.white,],
                        ),
                        borderRadius: BorderRadius.circular(14),
                        // color: Colors.blue.shade100
                        //color: Colors.grey.shade400.withOpacity(0.5)
                        // color: SettingsPage.isDark ? Color(0xFFFFFF).withOpacity(0.3): Color(0xFFFFFF).withOpacity(0.30) ,
                      )
                    : BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        // color: Colors.blue.shade100
                        //color: Colors.grey.shade400.withOpacity(0.5)
                        // color: SettingsPage.isDark ? Color(0xFFFFFF).withOpacity(0.3): Color(0xFFFFFF).withOpacity(0.30) ,
                      ),
                dropdownElevation: 8,
                scrollbarRadius: const Radius.circular(40),
                scrollbarThickness: 6,
                scrollbarAlwaysShow: true,
                offset: const Offset(-20, 0),
              ),
            ),
          ],
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                children: List.generate(
                  selectedValue,
                  (index) => ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(SearchPage
                          .twitterList[index].user?.profileImageUrlHttps),
                    ),
                    title: Text(
                      '${SearchPage.twitterList[index].user?.name}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        (SearchPage.twitterList[index].user.location)
                                .toString()
                                .isNotEmpty
                            ? Row(
                                children: [
                                  const Icon(Icons.place_outlined, size: 20),
                                  Text(
                                    ' ${SearchPage.twitterList[index].user.location}',
                                    textAlign: TextAlign.start,
                                  ),
                                ],
                              )
                            : const Text(''),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          SearchPage.twitterList[index].fullText,
                          overflow: TextOverflow.clip,
                          style: SettingsPage.isDark
                              ? const TextStyle(color: Colors.black)
                              : const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.search_off,
                                  color: Colors.cyan,
                                ),
                                Text(widget.tweetItself.length > 27 ? widget.tweetItself.substring(0, 10)+'...' : widget.tweetItself,
                                  //
                                  // widget.tweetItself,
                                  style: SettingsPage.isDark
                                      ? const TextStyle(color: Colors.black)
                                      : const TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.repeat,
                                  color: Colors.cyan,
                                ),
                                Text(
                                  '${SearchPage.twitterList[index].retweetCount}',
                                  style: SettingsPage.isDark
                                      ? const TextStyle(color: Colors.black)
                                      : const TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                            // Row(
                            //   children: [
                            //     Icon(Icons.favorite_border),
                            //     Text(
                            //         '${SearchPage.twitterList[index].favoriteCount}'),
                            //   ],
                            // ),
                          ],
                        ),
                        const Divider(thickness: 3),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
