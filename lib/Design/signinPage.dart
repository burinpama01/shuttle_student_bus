import 'dart:async';

import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';

import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:shuttle_student_bus/Bloc/authentication/authentication_bloc.dart';

class SigninPage extends StatefulWidget {
  _signinPage createState() => new _signinPage();
}

class _signinPage extends State<SigninPage> implements AuthenticationDelegate {
  AuthenticationBloc _authenticationBloc;

  Completer<GoogleMapController> _controller = Completer();
  static const LatLng _center = const LatLng(19.0272825, 99.9002384);
  final Set<Marker> _marker = {};
  LatLng _lastMapPosition = _center;
  MapType _currentMapType = MapType.normal;

  static final  CameraPosition _position = CameraPosition(
    bearing: 192.833,
    target: LatLng(19.0272825, 99.9002384),
    tilt: 59.440,
    zoom: 15.0,
  );

  Future<void> _goToPosition1() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_position));
  }

  _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;


    });
  }

  _onAddMarkerButtonPressed() {
    setState(() {
      _marker.add(
        Marker(
          markerId: MarkerId(_lastMapPosition.toString()),
          position: _lastMapPosition,
          infoWindow: InfoWindow(
            title: 'Title Name',
            snippet: 'Snippet Name'
          ),
          icon: BitmapDescriptor.defaultMarker,
        ),
      );
    });
  }

  Widget button(Function function, IconData icon) {
    return FloatingActionButton(
      onPressed: function,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      backgroundColor: Colors.blue,
      child: Icon(
        icon,
        size: 36.0,
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);

    return BlocBuilder(
      bloc: _authenticationBloc,
      builder: (BuildContext _context, AuthenticationState _state) {
        if (_state is InitialAuthenticationState) {
          _authenticationBloc.dispatch(AppStarted(context));
          return Container(
            color: Colors.red,
          );
        }
        if (_state is AuthenticatingState) {
          print("AuthenticatingState");
          return _authenticatingPage();
        } else if (_state is UnauthenticatedState) {
          return _authenticationPage(context, _state);
        } else if (_state is AuthenticatedState) {
          return _homePage(_state);
        } else {
          return Container();
        }
      },
    );
  }

  Widget _homePage(AuthenticationState _state) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.orange,
        title: new Text(
          "Home Page",
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.exit_to_app),
              color: Colors.white,
              onPressed: () {
                _authenticationBloc.dispatch(LogOut());
              })
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: true,
        showUnselectedLabels: false,
        selectedItemColor: Colors.orange,
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
              )),
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
              zoom: 15.0,
            ),
            mapType: _currentMapType,
            markers: _marker,
            onCameraMove: _onCameraMove,
            myLocationEnabled: true,
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.topRight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[

                  button(_onMapTypeButtonPressed, Icons.map),
                  SizedBox(
                    height: 16.0,
                  ),
                  button(_onAddMarkerButtonPressed, Icons.add_location),
                  SizedBox(
                    height: 16.0,
                  ),
                  button(_goToPosition1, Icons.location_searching),
                ],
              ),
            ),
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: _state is AuthenticatedState
                  ? SizedBox(
                      height: 30,
                      width: 30,
                      child: Image.network(_state.user.photoUrl),
                    )
                  : Container(),
              decoration: BoxDecoration(
                color: Colors.orange[200],
              ),
            ),
            ListTile(
              title: Text('Item 1'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Item 2'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _authenticationPage(
      BuildContext _context, AuthenticationState _state) {
    return Scaffold(
      body: Container(
        color: Colors.orange[50],
        child: Center(
          child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                      colors: [Colors.yellow[100], Colors.orangeAccent[100]])),
              margin: EdgeInsets.all(32),
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  buildTextFieldEmail(),
                  buildTextFieldPassword(),
                  buildButtonSignIn(),
                  buildButtonGoogleSignIn(_context, _state),
                ],
              )),
        ),
      ),
    );
  }

  Container buildButtonGoogleSignIn(
      BuildContext _context, AuthenticationState _state) {
    return Container(
      child: Container(
        constraints: BoxConstraints.expand(height: 50),
        margin: EdgeInsets.only(top: 16),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16), color: Colors.red[200]),
        child: FlatButton(
            onPressed: () {
              _authenticationBloc.dispatch(GoogleLogin(_context));
            },
            child: Stack(
              children: <Widget>[
                Center(
                  child: Text("Google Sign in",
                      style: TextStyle(
                          fontFamily: 'SukhumvitSet',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white)),
                )
              ],
            )),
      ),
    );
  }

  Container buildButtonSignIn() {
    return Container(
        constraints: BoxConstraints.expand(height: 50),
        child: Text("Sign in",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.white)),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16), color: Colors.green[200]),
        margin: EdgeInsets.only(top: 16),
        padding: EdgeInsets.all(12));
  }

  Container buildTextFieldEmail() {
    return Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: Colors.yellow[50], borderRadius: BorderRadius.circular(16)),
        child: TextField(
            decoration: InputDecoration.collapsed(hintText: "Email"),
            style: TextStyle(fontSize: 18)));
  }

  Container buildTextFieldPassword() {
    return Container(
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.only(top: 12),
        decoration: BoxDecoration(
            color: Colors.yellow[50], borderRadius: BorderRadius.circular(16)),
        child: TextField(
            obscureText: true,
            decoration: InputDecoration.collapsed(hintText: "Password"),
            style: TextStyle(fontSize: 18)));
  }

  Widget _authenticatingPage() {
    return Container(
      color: Colors.orange[200],
    );
  }

  @override
  void onError(String message) {
    print("onError");
  }

  @override
  void onSucess(String message) {
    print("onSuccess");
  }

}
