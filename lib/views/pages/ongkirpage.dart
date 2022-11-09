part of 'pages.dart';

class Ongkirpage extends StatefulWidget {
  const Ongkirpage({Key? key}) : super(key: key);

  @override
  _OngkirpageState createState() => _OngkirpageState();
}

class _OngkirpageState extends State<Ongkirpage> {
  bool isloading = true;
  String dropdowndefault = 'jne';
  var kurir = ['jne', 'pos', 'tiki'];

  final ctrlBerat = TextEditingController();

  dynamic provId;
  dynamic provinceData;
  dynamic selectedProv;

  Future<List<Province>> getProvinces() async {
    dynamic listProvince;
    await MasterDataService.getProvince().then((value) {
      setState(() {
        listProvince = value;
      });
    });

    return listProvince;
  }

  dynamic cityId;
  dynamic cityData;
  dynamic selectedCity;

  Future<List<City>> getCity(provID) async {
    dynamic listCity;
    await MasterDataService.getCity(provId).then((value) {
      setState(() {
        listCity = value;
      });
    });

    return listCity;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hitung Ongkir'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
              width: double.infinity,
              height: double.infinity,
              child: Column(
                children: [
                  //nampilin data
                  Flexible(
                    flex: 2,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              DropdownButton(
                                  value: dropdowndefault,
                                  icon: const Icon(Icons.arrow_drop_down),
                                  items: kurir.map((String items) {
                                    return DropdownMenuItem(
                                      value: items,
                                      child: Text(items),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      dropdowndefault = newValue!;
                                    });
                                  }),
                              SizedBox(
                                width: 200,
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  controller: ctrlBerat,
                                  decoration: const InputDecoration(
                                      labelText: "Berat(gr)"),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    return value == null || value == 0
                                        ? 'Berat harus diisi atau tidak boleh 0'
                                        : null;
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Origin",
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
                              Container(
                                child: FutureBuilder<List<Province>>(
                                    builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return DropdownButton(
                                        isExpanded: true,
                                        value: selectedProv,
                                        icon: Icon(Icons.arrow_drop_down),
                                        iconSize: 30,
                                        elevation: 16,
                                        hint: selectedProv == null
                                            ? Text("Pilih Provinsi")
                                            : Text(selectedProv.province),
                                        style: TextStyle(color: Colors.black),
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
                                            selectedProv = newValue;
                                            provId = selectedProv.provinceId;
                                          });
                                          selectedCity = null;
                                          cityData = getCity(provId);
                                        });
                                  } else if (snapshot.hasError) {
                                    return Text("Tidak ada data");
                                  }
                                  return UiLoading.loadingDD();
                                }),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),

                  //untuk form
                  Flexible(
                    flex: 2,
                    child: Container(),
                  )
                ],
              )),
          isloading == true ? UiLoading.loading() : Container()
        ],
      ),
    );
  }
}
