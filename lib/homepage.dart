import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wallpaper/fullscreen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List images = [];
  int page = 1;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    fetchapi();
  }

  fetchapi() async {
    try {
      final response = await http.get(
          Uri.parse("https://api.pexels.com/v1/curated?per_page=80"),
          headers: {
            'Authorization':
                'YnRlDpNy14jKEbFCXL3TAzQGaLtxyAfvEEG3Sp247JCD7d310VwCvR4m'
          });

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        setState(() {
          images = result["photos"];
          isLoading = false; // Set loading status to false once data is fetched
        });
      } else {
        // Handle API error here
        print('API Error: ${response.statusCode}');
        isLoading = false;
      }
    } catch (e) {
      // Handle network or other errors
      print('Error: $e');
      isLoading = false;
    }
  }

  loadMore() async {
    setState(() {
      page = page + 1;
    });
    String url =
        "https://api.pexels.com/v1/curated?per_page=80&page=" + page.toString();

    await http.get(Uri.parse(url), headers: {
      'Authorization':
          'YnRlDpNy14jKEbFCXL3TAzQGaLtxyAfvEEG3Sp247JCD7d310VwCvR4m'
    }).then((value) {
      Map result = jsonDecode(value.body);
      setState(() {
        images.addAll(result["photos"]);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              child: GridView.builder(
                itemCount:images.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 2 / 3,
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 2),
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.all(4),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>FullScreen(imageUrl:images[index]["src"]["large"])));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: const Color.fromARGB(255, 234, 236, 232)),
                      child: Image.network(images[index]["src"]["tiny"],
                          fit: BoxFit.cover),
                    ),
                  ),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              loadMore();
            },
            child: Container(
              width: double.infinity,
              height: 60,
              color: Colors.black,
              child: Center(
                  child: Text(
                "Load more",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 24),
              )),
            ),
          )
        ],
      ),
    );
  }
}
