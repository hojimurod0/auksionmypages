import 'dart:async';
import 'package:auksion/controllers/products_controller.dart';
import 'package:auksion/model/product.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final productController = ProductsController();
  final TextEditingController _priceController = TextEditingController();

  List<String> prices = [];
  int highestPrice = 900;
  bool isStarted = false;

  @override
  void initState() {
    super.initState();
    getPrice(); // Saqlangan narxlarni olish
  }

  void addText() {
    setState(() {
      if (_priceController.text.isNotEmpty) {
        int newPrice = int.tryParse(_priceController.text
                .replaceAll(',', '')
                .replaceAll(' ', '')) ??
            0;
        if (newPrice > highestPrice) {
          highestPrice = newPrice;
          prices.add(_priceController.text);
          savePrice(); // Narxni saqlash
          isStarted = true; // Kim oshdi savdosi boshlangani belgilanishi
        }
        _priceController.clear();
      }
    });
  }

  void savePrice() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList("prices", prices);
    prefs.setInt("highestPrice", highestPrice);
  }

  void getPrice() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> storedPrices = prefs.getStringList("prices") ?? [];
    int storedHighestPrice = prefs.getInt("highestPrice") ?? 900;
    setState(() {
      prices = storedPrices;
      highestPrice = storedHighestPrice;
    });
  }

  void clearHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("prices");
    prefs.remove("highestPrice");
    setState(() {
      prices.clear();
      highestPrice = 900;
    });
  }

  void showHistoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Auction History",
              style: TextStyle(color: Colors.blue)),
          content: Container(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: prices.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(prices[index],
                          style: const TextStyle(color: Colors.blue)),
                    );
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: clearHistory,
                      child: const Text('Clear History',
                          style: TextStyle(color: Colors.red)),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Close',
                          style: TextStyle(color: Colors.blue)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Auksion", style: TextStyle(color: Colors.blue)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.blue),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FutureBuilder<List<Product>>(
          future: productController.list,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}',
                    style: const TextStyle(color: Colors.blue)),
              );
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text('No products found',
                    style: TextStyle(color: Colors.blue)),
              );
            }

            final product = snapshot.data!.first;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.network(
                    "https://lionmotors.uz/wp-content/uploads/2020/11/cobalt3.jpg",
                    height: 200,
                  ),
                ),
                const SizedBox(height: 20),
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: "Nomi: ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                          fontSize: 16,
                        ),
                      ),
                      TextSpan(
                        text: product.name,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: "Tavsif: ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                          fontSize: 16,
                        ),
                      ),
                      TextSpan(
                        text: product.description,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: "Price: ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                          fontSize: 16,
                        ),
                      ),
                      TextSpan(
                        text: "\$$highestPrice",
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: prices.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: Colors.white,
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: ListTile(
                          title: Text(
                            prices[index],
                            style: const TextStyle(
                                fontSize: 16, color: Colors.blue),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                TextFormField(
                  controller: _priceController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: "Enter price",
                    labelStyle: const TextStyle(color: Colors.blue),
                    prefixIcon: IconButton(
                      onPressed: addText,
                      icon: const Icon(Icons.add, color: Colors.blue),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                Center(
                  child: ElevatedButton(
                    onPressed: addText,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Submit"),
                  ),
                ),
                const SizedBox(height: 10),
                Seconder(
                  isStarted: isStarted,
                  auctionTime: DateTime.parse(product.auksiontime),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showHistoryDialog(context);
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.history, color: Colors.white),
      ),
    );
  }
}

class Seconder extends StatefulWidget {
  Seconder({
    Key? key,
    required this.isStarted,
    required this.auctionTime,
  }) : super(key: key);

  final bool isStarted;
  final DateTime auctionTime;

  @override
  State<Seconder> createState() => _SeconderState();
}

class _SeconderState extends State<Seconder> {
  Timer? _timer;
  bool _isSold = false;
  int timeInSeconds = 0;

  @override
  void initState() {
    super.initState();
    if (widget.isStarted) {
      timeInSeconds = widget.auctionTime.difference(DateTime.now()).inSeconds;
      startTimer(); // Taymerni boshlash
    }
  }

  void startTimer() {
    const oneSecond = Duration(seconds: 1);

    _timer = Timer.periodic(oneSecond, (timer) {
      if (timeInSeconds <= 0) {
        setState(() {
          _isSold = true; // Savdo tugadi
        });
        timer.cancel();
      } else {
        setState(() {
          timeInSeconds =
              widget.auctionTime.difference(DateTime.now()).inSeconds;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _isSold
          ? const Text(
              "Sold",
              style: TextStyle(
                color: Colors.red,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            )
          : timeInSeconds > 0
              ? Text(
                  "Time left: $timeInSeconds seconds",
                  style: const TextStyle(fontSize: 18),
                )
              : Container(),
    );
  }
}
