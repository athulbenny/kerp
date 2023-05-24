import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:kerp/main.dart';
import 'package:latlong2/latlong.dart';


class OpenStreetMapSearchAndPick extends StatefulWidget {
  final String pid;final String Tdate;final int isChanged,tid;
  final LatLong center;
  final void Function(PickedData pickedData) onPicked;
  final Future<LatLng> Function() onGetCurrentLocationPressed;
  final Color buttonColor;
  final Color buttonTextColor;
  final Color locationPinIconColor;
  final String buttonText;
  final String hintText;
  static final String id= "open_street_map_sap";
  static Future<LatLng> nopFunction() {
    throw Exception("");
  }

  const OpenStreetMapSearchAndPick({
    Key? key,required this.Tdate,required this.isChanged,
    required this.center,required this.tid,
    required this.onPicked,
    required this.pid,
    this.onGetCurrentLocationPressed = nopFunction,
    this.buttonColor = Colors.blue,
    this.locationPinIconColor = Colors.red,
    this.buttonTextColor = Colors.black,
    this.buttonText = 'Set Current Location',
    this.hintText = 'Search Location',
  }) : super(key: key);

  @override
  State<OpenStreetMapSearchAndPick> createState() =>
      _OpenStreetMapSearchAndPickState(pid,Tdate,isChanged,tid);
}

class _OpenStreetMapSearchAndPickState
    extends State<OpenStreetMapSearchAndPick> {
  String pid;String Tdate;int isChanged,tid;
  _OpenStreetMapSearchAndPickState(this.pid,this.Tdate,this.isChanged,this.tid);
  MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<OSMdata> _options = <OSMdata>[];
  Timer? _debounce;
  var client = http.Client();




  void setNameCurrentPos() async {
    double latitude = _mapController.center.latitude;
    double longitude = _mapController.center.longitude;
    if (kDebugMode) {
      print(latitude);
    }
    if (kDebugMode) {
      print(longitude);
    }
    String url =
        'https://nominatim.openstreetmap.org/reverse?format=json&lat=$latitude&lon=$longitude&zoom=18&addressdetails=1';

    var response = await client.post(Uri.parse(url));
    var decodedResponse =
    jsonDecode(utf8.decode(response.bodyBytes)) as Map<dynamic, dynamic>;

    _searchController.text =
        decodedResponse['display_name'] ?? "MOVE TO CURRENT POSITION";
    setState(() {});
  }

  void setNameCurrentPosAtInit() async {
    double latitude = widget.center.latitude;
    double longitude = widget.center.longitude;
    if (kDebugMode) {
      print(latitude);
    }
    if (kDebugMode) {
      print(longitude);
    }
    String url =
        'https://nominatim.openstreetmap.org/reverse?format=json&lat=$latitude&lon=$longitude&zoom=18&addressdetails=1';

    var response = await client.post(Uri.parse(url));
    var decodedResponse =
    jsonDecode(utf8.decode(response.bodyBytes)) as Map<dynamic, dynamic>;

    _searchController.text =
        decodedResponse['display_name'] ?? "MOVE TO CURRENT POSITION";
    setState(() {});
  }

  @override
  void initState() {
    _mapController = MapController();

    setNameCurrentPosAtInit();

    _mapController.mapEventStream.listen((event) async {
      if (event is MapEventMoveEnd) {
        var client = http.Client();
        String url =
            'https://nominatim.openstreetmap.org/reverse?format=json&lat=${event.center.latitude}&lon=${event.center.longitude}&zoom=18&addressdetails=1';

        var response = await client.post(Uri.parse(url));
        var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes))
        as Map<dynamic, dynamic>;

        _searchController.text = decodedResponse['display_name'];
        setState(() {});
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double latx=0, lngx=0;
    // String? _autocompleteSelection;
    OutlineInputBorder inputBorder = OutlineInputBorder(
      borderSide: BorderSide(color: widget.buttonColor),
    );
    OutlineInputBorder inputFocusBorder = OutlineInputBorder(
      borderSide: BorderSide(color: widget.buttonColor, width: 3.0),
    );
    return SafeArea(
      child: Stack(
        children: [
          Positioned.fill(
              child: FlutterMap(
                options: MapOptions(
                  center: LatLng(widget.center.latitude, widget.center.longitude),
                  zoom: 15.0,
                  maxZoom: 18,
                  minZoom: 6,
                  // onTap: (pos,loc)async{
                  //   latx= loc.latitude;
                  //   lngx= loc.longitude;
                    // pickData().then((value) {
                    //   alert(value.latLong.latitude, value.latLong.longitude , value.address);
                    // widget.onPicked(value);setState(() {main();});
                   // });
                    //print(latx);print(pos.hashCode);
                  // },
                  // onLongPress:(pos,location){
                  //   pickData().then((value) {
                  //     alert(value.latLong.latitude, value.latLong.longitude , value.address);
                  //     widget.onPicked(value);setState(() {main();});
                  //   });
                  // },
                ),
                mapController: _mapController,
                children: [
                  TileLayer(
                    urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                    subdomains: const ['a', 'b', 'c'],
                    // attributionBuilder: (_) {
                    //   return Text("© OpenStreetMap contributors");
                    // },
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: LatLng(latx,lngx),
                        builder: (cxt)=>Icon(Icons.location_on_sharp),
                      ),
                    ],
                  ),
                ],
              )),
          Positioned(
              top: MediaQuery.of(context).size.height * 0.5,
              left: 0,
              right: 0,
              child: IgnorePointer(
                child: Center(
                  child: StatefulBuilder(builder: (context, setState) {
                    return Text(
                      _searchController.text,
                      textAlign: TextAlign.center,
                    );
                  }),
                ),
              )),
          Positioned.fill(
              child: IgnorePointer(
                child: Center(
                  child: Icon(
                    Icons.location_pin,
                    size: 50,
                    color: widget.locationPinIconColor,
                  ),
                ),
              )),
          Positioned(
              bottom: 180,
              right: 5,
              child: FloatingActionButton(
                tooltip: 'Zoom in',
                heroTag: 'btn1',
                backgroundColor: widget.buttonColor,
                onPressed: () {
                  _mapController.move(
                      _mapController.center, _mapController.zoom + 1);
                },
                child: Icon(
                  Icons.zoom_in_map,
                  color: widget.buttonTextColor,
                ),
              )),
          Positioned(
              bottom: 120,
              right: 5,
              child: FloatingActionButton(
                tooltip: 'Zoom out',
                heroTag: 'btn2',
                backgroundColor: widget.buttonColor,
                onPressed: () {
                  _mapController.move(
                      _mapController.center, _mapController.zoom - 1);
                },
                child: Icon(
                  Icons.zoom_out_map,
                  color: widget.buttonTextColor,
                ),
              )),
          Positioned(
              bottom: 60,
              right: 5,
              child: FloatingActionButton(
                tooltip: 'Go home',
                heroTag: 'btn3',
                backgroundColor: widget.buttonColor,
                onPressed: () async {
                  try {
                    LatLng position =
                    await widget.onGetCurrentLocationPressed.call();
                    _mapController.move(
                        LatLng(position.latitude, position.longitude),
                        _mapController.zoom);
                  } catch (e) {
                    _mapController.move(
                        LatLng(widget.center.latitude, widget.center.longitude),
                        _mapController.zoom);
                  } finally {
                    setNameCurrentPos();
                  }
                },
                child: Icon(
                  Icons.my_location,
                  color: widget.buttonTextColor,
                ),
              )),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              margin: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.deepOrange,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  TextFormField(
                    style: TextStyle(color: Colors.black),
                      controller: _searchController,
                      focusNode: _focusNode,
                      decoration: InputDecoration(
                        hintText: widget.hintText,
                        border: inputBorder,
                        focusedBorder: inputFocusBorder,
                      ),
                      onChanged: (String value) {
                        if (_debounce?.isActive ?? false) _debounce?.cancel();

                        _debounce =
                            Timer(const Duration(milliseconds: 2000), () async {
                              if (kDebugMode) {
                                print(value);
                              }
                              var client = http.Client();
                              try {
                                String url =
                                    'https://nominatim.openstreetmap.org/search?q=$value&format=json&polygon_geojson=1&addressdetails=1';
                                if (kDebugMode) {
                                  print(url);
                                }
                                var response = await client.post(Uri.parse(url));
                                var decodedResponse =
                                jsonDecode(utf8.decode(response.bodyBytes))
                                as List<dynamic>;
                                if (kDebugMode) {
                                  print(decodedResponse);
                                }
                                _options = decodedResponse
                                    .map((e) => OSMdata(
                                  displayname: e['display_name'],
                                  lat: double.parse(e['lat']),
                                  lon: double.parse(e['lon']),
                                ))
                                    .toList();
                                setState(() {});
                              } finally {
                                client.close();
                              }

                              setState(() {});
                            });
                      }),
                  Divider(height: 1,thickness: 2,),
                  StatefulBuilder(builder: ((context, setState) {
                    return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _options.length > 5 ? 5 : _options.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(_options[index].displayname),
                            subtitle: Text(
                                '${_options[index].lat},${_options[index].lon}'),
                            onTap: () {
                              _mapController.move(
                                  LatLng(
                                      _options[index].lat, _options[index].lon),
                                  15.0);

                              _focusNode.unfocus();
                              _options.clear();
                              setState(() {});
                            },
                          );
                        });
                  })),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: WideButton(
                  widget.buttonText,
                  onPressed: () async {
                    pickData().then((value) {
                      alert(value.latLong.latitude, value.latLong.longitude , value.address);
                      widget.onPicked(value);setState(() {main();});
                    });
                  },
                  backgroundColor: widget.buttonColor,
                  foregroundColor: widget.buttonTextColor,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<PickedData> pickData() async {
    LatLong center = LatLong(
        _mapController.center.latitude, _mapController.center.longitude);
    print(_mapController.center.latitude);
    var client = http.Client();
    String url =
        'https://nominatim.openstreetmap.org/reverse?format=json&lat=${_mapController.center.latitude}&lon=${_mapController.center.longitude}&zoom=18&addressdetails=1';

    var response = await client.post(Uri.parse(url));
    var decodedResponse =
    jsonDecode(utf8.decode(response.bodyBytes)) as Map<dynamic, dynamic>;
    String displayName = decodedResponse['display_name'];
    return PickedData(center, displayName);
  }
  Future<List> senddata(double lat, double lon,String loc,String pid,String Tdate,int isChanged,int tid) async {// function to send data
    String e="efgh";
    final response = await http.post(Uri.http(ip,"/kerp/insertlocation.php"), body: {
      "tablename":pid,
      "latitude": lat.toString(),
      "longitude": lon.toString(),
      "loc":loc,
      "Tdate":Tdate,
      "isChanged":isChanged.toString(),
      "id":tid.toString(),
    });
    print(response.body);
    return Future.error("error"+e);
  }

    Future<void> alert(latitude,longitude,address) async {
      return showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Save Location'),
            content:  SingleChildScrollView(
              child: Text('SAVE ${address.toString()} and CONTINUE',style: TextStyle(color: Colors.blue),),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),TextButton(
                child: const Text('save'),
                onPressed: () {
                  senddata(latitude,longitude ,address,pid,Tdate,isChanged,tid);
                  Navigator.of(context).pop();
          },
        ),
      ],
    );});
  }
}

class OSMdata {
  final String displayname;
  final double lat;
  final double lon;
  OSMdata({required this.displayname, required this.lat, required this.lon});
  @override
  String toString() {
    return '$displayname, $lat, $lon';
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is OSMdata && other.displayname == displayname;
  }

  @override
  int get hashCode => Object.hash(displayname, lat, lon);
}

class LatLong {
  final double latitude;
  final double longitude;
  LatLong(this.latitude, this.longitude);
}

class PickedData {
  final LatLong latLong;
  final String address;

  PickedData(this.latLong, this.address);
}

class WideButton extends StatelessWidget {
  const WideButton(
  this.text, {
  Key? key,
  required,
  this.padding = 0.0,
  this.height = 45,
  required this.onPressed,
  required this.backgroundColor,
  required this.foregroundColor,
  }) : super(key: key);

  /// Should be inside a column, row or flex widget
  final String text;
  final double padding;
  final double height;
  final Color backgroundColor;
  final Color foregroundColor;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
  return SizedBox(
  height: height,
  width: MediaQuery.of(context).size.width <= 500
  ? MediaQuery.of(context).size.width
      : 350,
  child: Padding(
  padding: EdgeInsets.symmetric(horizontal: padding),
  child: ElevatedButton(
  style: ElevatedButton.styleFrom(
  backgroundColor: backgroundColor,
  foregroundColor: foregroundColor,
  ),
  onPressed: onPressed,
  child: Text(text),
  ),
  ),
  );
  }
}

