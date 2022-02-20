import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'location_provider.dart';

class LocateAddress extends StatefulWidget {
  const LocateAddress({Key? key}) : super(key: key);

  @override
  _LocateAddressState createState() => _LocateAddressState();
}

class _LocateAddressState extends State<LocateAddress> {
  GoogleMapController? _controller;
  List addressList = [];

  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          title: const Text(
            'Locate Me on Map',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: SafeArea(
          child: Column(children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width,
              child: Consumer<LocationProvider>(
                builder: (context, locationProvider, child) => Stack(
                  clipBehavior: Clip.none,
                  children: [
                    GoogleMap(
                      mapType: MapType.normal,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(locationProvider.position.latitude,
                            locationProvider.position.longitude),
                        zoom: 16,
                      ),
                      zoomGesturesEnabled: true,
                      zoomControlsEnabled: false,
                      compassEnabled: false,
                      indoorViewEnabled: true,
                      mapToolbarEnabled: true,
                      onCameraIdle: () {
                        locationProvider.dragableAddress();

                        //saving details when map is in idle state,
                        // you can store location detail in any variable also.
                        setState(() {
                          addressList.add(locationProvider.address.name! +
                              ", " +
                              locationProvider.address.locality! +
                              " - " +
                              locationProvider.address.postalCode! +
                              ", " +
                              locationProvider.address.country!);
                          addressList.add("\nLatitude: " +
                              locationProvider.position.latitude.toString());
                          addressList.add("Longitude: " +
                              locationProvider.position.longitude.toString());
                        });
                      },
                      onCameraMove: ((_position) {
                        addressList.clear();

                        //updating location when change in the marker
                        locationProvider.updatePosition(_position);
                      }),
                      onMapCreated: (GoogleMapController controller) {
                        _controller = controller;
                        if (_controller != null) {
                          //getting current location when map is initially displayed
                          locationProvider.getCurrentLocation(
                              mapController: _controller);
                        }
                      },
                    ),
                    Positioned(
                      bottom: 16,
                      right: 0,
                      left: 0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {
                              locationProvider.getCurrentLocation(
                                  mapController: _controller);
                            },
                            child: Container(
                              width: 35,
                              height: 35,
                              margin: const EdgeInsets.only(right: 20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white,
                              ),
                              child: const Icon(
                                Icons.my_location,
                                size: 30,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    //location marker surrounded with the loader
                    Container(
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height,
                        child: Image.asset(
                          'images/loc_marker.png',
                          width: 40,
                          height: 40,
                          color: Colors.redAccent,
                        )),
                    locationProvider.loading
                        ? const Center(
                            child: SizedBox(
                            width: 50,
                            height: 50,
                            child: CircularProgressIndicator(),
                          ))
                        : Container(),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                shrinkWrap: true,
                children: [
                  const Text(
                    'Map Location',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 8,
                  ),

                  //displaying location details
                  for (int i = 0; i < addressList.length; i++)
                    Text(addressList[i].toString()),
                ],
              ),
            ),
          ]),
        ));
  }
}
