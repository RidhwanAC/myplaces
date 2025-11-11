import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_network/image_network.dart';
import 'package:myplaces/model/mdl_place.dart';
import 'package:myplaces/views/sc_detail.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController searchController = TextEditingController();
  List<Place> allPlaces = [];
  List<Place> places = [];

  bool isLoading = false;
  String errorText = '';

  @override
  void initState() {
    super.initState();
    _fetchPlaces();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Home')),
        body: Center(
            child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: searchController,
                    onChanged: (_) => _searchPlaces(),
                    onTapOutside: (_) =>
                        FocusManager.instance.primaryFocus?.unfocus(),
                    decoration: const InputDecoration(
                      suffixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(color: Colors.grey, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(color: Colors.black, width: 2),
                      ),
                      labelText: 'Search',
                    ),
                  ),
                ),
                IconButton(
                    onPressed: _fetchPlaces, icon: const Icon(Icons.refresh))
              ]),
              const SizedBox(
                height: 20,
              ),
              isLoading
                  ? const Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 50,
                              width: 50,
                              child: CircularProgressIndicator(),
                            ),
                            SizedBox(height: 10),
                            Text('Fetching places...',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black))
                          ],
                        ),
                      ),
                    )
                  : places.isEmpty
                      ? Expanded(
                          child: Center(
                            child: Text(
                              errorText,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                      : Expanded(
                          child: ListView.builder(
                            itemCount: places.length,
                            itemBuilder: (context, index) => SizedBox(
                              height: 100,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(20),
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DetailScreen(
                                            place: places[index]))),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  margin: const EdgeInsets.all(5),
                                  child: ListTile(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      side: const BorderSide(
                                          color: Colors.black, width: 2),
                                    ),
                                    titleAlignment: ListTileTitleAlignment.top,
                                    leading: ImageNetwork(
                                        height: 100,
                                        width: 100,
                                        image: places[index].image!,
                                        fitWeb: BoxFitWeb.cover,
                                        fitAndroidIos: BoxFit.cover,
                                        onError: const SizedBox(
                                            height: 100,
                                            width: 100,
                                            child: Icon(
                                                Icons.image_not_supported))),
                                    title: Text(
                                      places[index].name!,
                                      softWrap: false,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(places[index].state!),
                                        Row(
                                          children: [
                                            Text(places[index]
                                                .rating!
                                                .toString()),
                                            const SizedBox(width: 2),
                                            const Icon(
                                              size: 15,
                                              Icons.star,
                                              color: Colors.amber,
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
            ],
          ),
        )));
  }

  void _fetchPlaces() async {
    String url =
        'https://slumberjer.com/teaching/a251/locations.php?state=&category=&name=';
    List<dynamic> result = [];
    places = [];
    setState(() => isLoading = true);

    try {
      await http.get(Uri.parse(url)).then((response) {
        if (response.statusCode == 200) {
          var data = response.body;
          result = json.decode(data);

          allPlaces = result.map((e) => Place.fromJson(e)).toList();
          allPlaces.sort((a, b) => a.name!.compareTo(b.name!));

          _searchPlaces();

          Future.delayed(const Duration(seconds: 1), () {
            setState(() => isLoading = false);
          });
        } else {
          setState(() => errorText = 'Failed to fetch places');
        }
      }).timeout(const Duration(seconds: 10), onTimeout: () {
        throw TimeoutException('Request timed out');
      });
    } on TimeoutException catch (e) {
      setState(() {
        errorText = e.message!;
        isLoading = false;
      });
    }
  }

  _searchPlaces() {
    String search = searchController.text;

    if (search.isEmpty) {
      setState(() {
        places = List.from(allPlaces);
      });
    } else {
      setState(() {
        places = allPlaces
            .where((place) =>
                place.name!.toLowerCase().contains(search.toLowerCase()))
            .toList();
        if (places.isEmpty) {
          errorText = 'No places found';
        } else {
          errorText = '';
        }
      });
    }
  }
}
