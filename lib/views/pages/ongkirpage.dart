part of "pages.dart";

class Ongkirpage extends StatefulWidget {
  const Ongkirpage({Key? key}) : super(key: key);

  @override
  _OngkirpageState createState() => _OngkirpageState();
}

class _OngkirpageState extends State<Ongkirpage> {
  String selectedkurir = "jne";
  bool isLoading = false;

  var kurir = ["jne", "pos", "tiki"];

  final ctrlBerat = TextEditingController();

  dynamic provId;
  dynamic provinceData;
  dynamic originProv;
  dynamic destinationProv;
  Future<List<Province>> getProvinces() async {
    dynamic listProvince = [];
    await MasterDataService.getProvince().then((value) {
      setState(() {
        listProvince = value;
      });
    });

    return listProvince;
  }

  dynamic cityIdOri;
  dynamic cityIdDes;
  dynamic cityDataOrigin;
  dynamic cityDataDestination;
  dynamic originCity;
  dynamic destinationCity;
  Future<List<City>> getCity(dynamic provId) async {
    dynamic listCity;
    await MasterDataService.getCity(provId).then((value) {
      setState(() {
        listCity = value;
      });
    });

    return listCity;
  }

  String ori = '';
  String des = '';

  List<Costs> listCosts = [];
  Future<dynamic> getCostsData() async {
    await RajaOngkirService.getMyOngkir(
            cityIdOri, cityIdDes, int.parse(ctrlBerat.text), selectedkurir)
        .then((value) {
      setState(() {
        listCosts = value;
      });
      print(listCosts.toString());
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    provinceData = getProvinces();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ongkir"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              children: [
                // Flexible untuk form
                Flexible(
                  flex: 3,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            DropdownButton(
                                value: selectedkurir,
                                icon: Icon(Icons.arrow_drop_down),
                                items: kurir.map((String items) {
                                  return DropdownMenuItem(
                                    value: items,
                                    child: Text(items),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedkurir = newValue!;
                                  });
                                }),
                            SizedBox(
                              width: 200,
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                controller: ctrlBerat,
                                decoration:
                                    InputDecoration(labelText: "Berat (gr)"),
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: ((value) {
                                  return value == null || value == 0
                                      ? "Berat harus diisi atau tidak boleh 0!"
                                      : null;
                                }),
                              ),
                            )
                          ],
                        ),
                      ),

                      // Origin

                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Origin :",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: FutureBuilder<List<Province>>(
                                future: provinceData,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    return DropdownButton(
                                      isExpanded: true,
                                      value: originProv,
                                      icon: Icon(Icons.arrow_drop_down),
                                      iconSize: 30,
                                      elevation: 16,
                                      style: TextStyle(color: Colors.black),
                                      hint: originProv == null
                                          ? Text("Pilih provinsi!")
                                          : Text(originProv.province),
                                      items: snapshot.data!
                                          .map<DropdownMenuItem<Province>>(
                                              (Province value) {
                                        return DropdownMenuItem(
                                            value: value,
                                            child: Text(
                                                value.province.toString()));
                                      }).toList(),
                                      onChanged: (newValue) {
                                        setState(() {
                                          originProv = newValue;
                                          provId = originProv.provinceId;
                                        });

                                        originCity = null;
                                        cityDataOrigin = getCity(provId);
                                      },
                                    );
                                  } else if (snapshot.hasError) {
                                    return Text("Tidak ada data!");
                                  }

                                  return UiLoading.loadingDD();
                                },
                              ),
                            ),
                            Expanded(
                              child: FutureBuilder<List<City>>(
                                future: cityDataOrigin,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    return DropdownButton(
                                      isExpanded: true,
                                      value: originCity == null
                                          ? originCity
                                          : null,
                                      icon: Icon(Icons.arrow_drop_down),
                                      iconSize: 30,
                                      elevation: 16,
                                      style: TextStyle(color: Colors.black),
                                      hint: originCity == null
                                          ? Text("Pilih kota !")
                                          : Text(originCity.cityName),
                                      items: snapshot.data!
                                          .map<DropdownMenuItem<City>>(
                                              (City value) {
                                        return DropdownMenuItem(
                                            value: value,
                                            child: Text(
                                                value.cityName.toString()));
                                      }).toList(),
                                      onChanged: (newValue) {
                                        setState(() {
                                          originCity = newValue;
                                          cityIdOri = originCity.cityId;
                                        });

                                        // cityData = getCity(provId);
                                      },
                                    );
                                  } else if (snapshot.hasError) {
                                    return Text("Tidak ada data!");
                                  }

                                  if (originProv == null) {
                                    return Text("Pilih Provinsi Dulu !");
                                  } else {
                                    return UiLoading.loadingDD();
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Destination

                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Destination :",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: FutureBuilder<List<Province>>(
                                future: provinceData,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    return DropdownButton(
                                      isExpanded: true,
                                      value: destinationProv,
                                      icon: Icon(Icons.arrow_drop_down),
                                      iconSize: 30,
                                      elevation: 16,
                                      style: TextStyle(color: Colors.black),
                                      hint: destinationProv == null
                                          ? Text("Pilih provinsi!")
                                          : Text(destinationProv.province),
                                      items: snapshot.data!
                                          .map<DropdownMenuItem<Province>>(
                                              (Province value) {
                                        return DropdownMenuItem(
                                            value: value,
                                            child: Text(
                                                value.province.toString()));
                                      }).toList(),
                                      onChanged: (newValue) {
                                        setState(() {
                                          destinationProv = newValue;
                                          provId = destinationProv.provinceId;
                                        });

                                        destinationCity = null;
                                        cityDataDestination = getCity(provId);
                                      },
                                    );
                                  } else if (snapshot.hasError) {
                                    return Text("Tidak ada data!");
                                  } else {
                                    return UiLoading.loadingDD();
                                  }
                                },
                              ),
                            ),
                            Expanded(
                              child: FutureBuilder<List<City>>(
                                future: cityDataDestination,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    return DropdownButton(
                                      isExpanded: true,
                                      value: destinationCity == null
                                          ? destinationCity
                                          : null,
                                      icon: Icon(Icons.arrow_drop_down),
                                      iconSize: 30,
                                      elevation: 16,
                                      style: TextStyle(color: Colors.black),
                                      hint: destinationCity == null
                                          ? Text("Pilih kota !")
                                          : Text(destinationCity.cityName),
                                      items: snapshot.data!
                                          .map<DropdownMenuItem<City>>(
                                              (City value) {
                                        return DropdownMenuItem(
                                            value: value,
                                            child: Text(
                                                value.cityName.toString()));
                                      }).toList(),
                                      onChanged: (newValue) {
                                        setState(() {
                                          destinationCity = newValue;
                                          cityIdDes = destinationCity.cityId;
                                        });

                                        // originCity = null;
                                        // cityData = getCity(provId);
                                      },
                                    );
                                  } else if (snapshot.hasError) {
                                    return Text("Tidak ada data!");
                                  }

                                  if (destinationProv == null) {
                                    return Text("Pilih Provinsi Dulu !");
                                  } else {
                                    return UiLoading.loadingDD();
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Button
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                        child: TextButton(
                          style: TextButton.styleFrom(
                              backgroundColor: Colors.blue),
                          onPressed: () {
                            // if (originCity != null && destinationCity != null) {
                            //   Fluttertoast.showToast(
                            //       msg: "Origin: " +
                            //           originCity.cityName.toString() +
                            //           ", Destination: " +
                            //           destinationCity.cityName.toString(),
                            //       backgroundColor: Colors.green);
                            // } else {
                            //   Fluttertoast.showToast(
                            //       msg:
                            //           "Origin dan atau Destination masih belum diisi!",
                            //       backgroundColor: Colors.red);
                            // }

                            if (cityIdDes.isEmpty ||
                                cityIdOri.isEmpty ||
                                selectedkurir.isEmpty ||
                                ctrlBerat.text.isEmpty) {
                              UiToast.toastErr("Semua Field Harus di isi");
                            } else {
                              getCostsData();
                            }
                          },
                          child: Text("Hitung Estimasi Harga",
                              style: TextStyle(
                                color: Colors.white,
                              )),
                        ),
                      )
                    ],
                  ),
                ),

                // Flexible untuk tampilkan data
                Flexible(
                  flex: 2,
                  child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: listCosts.isEmpty
                          ? const Align(
                              alignment: Alignment.center,
                              child: Text("Belum ada data"))
                          : ListView.builder(
                              itemCount: listCosts.length,
                              itemBuilder: (context, index) {
                                return LazyLoadingList(
                                    initialSizeOfItems: 10,
                                    loadMore: () {},
                                    child: CardOngkir(listCosts[index]),
                                    index: index,
                                    hasMore: true);
                              })),
                ),
              ],
            ),
          ),
          isLoading == true ? UiLoading.loading() : Container(),
        ],
      ),
    );
  }
}
