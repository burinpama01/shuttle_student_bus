
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shuttle_student_bus/Bloc/authentication/authentication_bloc.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsPage extends StatefulWidget {
  _mapsPage createState() => new _mapsPage();

}

class _mapsPage extends State<MapsPage> {

  Completer<GoogleMapController> _controller = Completer();
  static const LatLng _center = const LatLng(45.521563, -122.677433);
  final Set<Marker> _marker = {};
  LatLng _lastMapPosition = _center;
  MapType _currentMapType = MapType.normal;

  _onMapCreated(GoogleMapController controller){
    _controller.complete(controller);
  }

  _onCameraMove(CameraPosition position){
    _lastMapPosition = position.target;
  }

  Widget button(Function function, IconData icon){
    return FloatingActionButton(
      onPressed: function,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      backgroundColor: Colors.blue,
    );
  }

  @override
  Widget Build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Home Page ndfjkdsfndsj"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.exit_to_app),
              color: Colors.white,
              onPressed: () {
//              _authenticationBloc.dispatch(LogOut());
              })
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: true,
        showUnselectedLabels: false,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.home),
            title: new Text(
              'หน้าแรก',
              style: TextStyle(fontFamily: 'SukhumvitSet', fontSize: 16),
            ),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.place),
            title: new Text(
              'แผนที่',
              style: TextStyle(fontFamily: 'SukhumvitSet', fontSize: 16),
            ),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.assignment),
              title: Text(
                'สถานะ',
                style: TextStyle(fontFamily: 'SukhumvitSet', fontSize: 16),
              )
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.person),
            title: new Text(
              'บัญชี',
              style: TextStyle(fontFamily: 'SukhumvitSet', fontSize: 16),
            ),
          ),


        ],
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 11.0,
            ),
            mapType: _currentMapType,
            markers: _marker,
            onCameraMove: _onCameraMove,
          )
        ],

      ),
//    drawer: Drawer(
//      // Add a ListView to the drawer. This ensures the user can scroll
//      // through the options in the drawer if there isn't enough vertical
//      // space to fit everything.
//      child: ListView(
//        // Important: Remove any padding from the ListView.
//        padding: EdgeInsets.zero,
//        children: <Widget>[
//          DrawerHeader(
//            child: Text('Drawer Header'),
//            decoration: BoxDecoration(
//              color: Colors.blue,
//            ),
//          ),
//          ListTile(
//            title: Text('Item 1'),
//            onTap: () {
//              // Update the state of the app
//              // ...
//              // Then close the drawer
//              Navigator.pop(context);
//            },
//          ),
//          ListTile(
//            title: Text('Item 2'),
//            onTap: () {
//              // Update the state of the app
//              // ...
//              // Then close the drawer
//              Navigator.pop(context);
//            },
//          ),
//        ],
//      ),
//    ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }
}