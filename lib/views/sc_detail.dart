import 'package:flutter/material.dart';
import 'package:image_network/image_network.dart';
import 'package:myplaces/model/mdl_place.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailScreen extends StatefulWidget {
  final Place place;
  const DetailScreen({super.key, required this.place});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    Place place = widget.place;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ImageNetwork(
                height: 200,
                width: 200,
                image: place.image!,
                fitWeb: BoxFitWeb.cover,
                fitAndroidIos: BoxFit.cover,
                onError: const Icon(
                  Icons.error,
                  color: Colors.red,
                ),
              ),
              Text(
                place.name!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    border: Border.all(width: 2, color: Colors.black),
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      elevation: 5,
                      color: Colors.amber,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                        child: Text(
                          place.category!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      place.description!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Divider(
                      color: Colors.black,
                      thickness: 2,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Text('Location: ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextButton(
                            style: TextButton.styleFrom(
                              shadowColor: Colors.black,
                              elevation: 1,
                              backgroundColor:
                                  const Color.fromARGB(255, 240, 240, 240),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              _toMaps();
                            },
                            child: const Text(
                              'View Location',
                              style: TextStyle(color: Colors.black),
                            )),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Contact: ${place.contact!}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: SizedBox(
                        width: 200,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 240, 240, 240),
                            ),
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Close',
                                style: TextStyle(color: Colors.black))),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _toMaps() async {
    Place place = widget.place;
    String url =
        'https://www.google.com/maps/search/?api=1&query=${place.latitude},${place.longitude}';
    try {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }
}
