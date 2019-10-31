import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';


part 'authentication_event.dart';

part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  var _firebaseAuth = FirebaseAuth.instance;

  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'https://www.googleapis.com/auth/contacts.readonly'],
  );

  signIn(){
    _firebaseAuth.signInWithEmailAndPassword().then((user) {
      //print("signed in ${user.email}");
      if(user != null){
        return user;
      }else {
        return null;
      }
    }).catchError((error) {
      print(error);
    });
  }

  @override
  AuthenticationState get initialState => InitialAuthenticationState();

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event) async* {
    if (event is GoogleLogin) {
      yield* _mapGoogleLoginToState(event);
    } else if (event is AppStarted) {
      yield* _mapLoggedInToState(event);
    } else if (event is LogOut) {
      yield* _mapLoggedOutToState();
    }
  }

  Stream<AuthenticationState> _mapAppStartedToState() async* {
    yield AuthenticatingState();
    var firebase = await _firebaseAuth.currentUser().then((onValue){
      print("TESTTTT");
      if(onValue != null){
        return onValue;
      }else {
        return null;
      }
    }).catchError((){
      return null;
    });
    if (firebase != null) {
      yield AuthenticatedState(firebase);
    }  else {
      yield UnauthenticatedState();
    }
  }

  Stream<AuthenticationState> _mapGoogleLoginToState(GoogleLogin event) async* {
    yield AuthenticatingState();

    try {
      FirebaseUser user = await _googleSignIn.signIn().then((value) async {
        if (value != null) {
          final GoogleSignInAuthentication googleAuth =
              await value.authentication;
          print(googleAuth.idToken);
          print(googleAuth.accessToken);

          var firebase = await _firebaseAuth
              .signInWithCredential(GoogleAuthProvider.getCredential(
                  idToken: googleAuth.idToken,
                  accessToken: googleAuth.accessToken))
              .then((onvalue) {
            var users = onvalue.user;
            
            return users;
          }).whenComplete(() {
            print("A0");
          }).catchError((error) {
            print("A1 : ${error.toString()}");
            return null;
          });
          return firebase;
        } else {
          print("A2");
          return null;
        }
      }).catchError((error) {
        print("A3 : ${error.toString()}");
        return null;
      });
      if (user != null) {
        print("USER : ${user.displayName}");
        yield AuthenticatedState(user);
      } else {
        print("UnauthenticatedState");
        yield UnauthenticatedState();
      }
    } catch (error) {
      print("A4 : ${error.toString()}");
      yield UnauthenticatedState();
    }
  }

  Stream<AuthenticationState> _mapLoggedInToState(AuthenticationEvent event) async* {
    yield AuthenticatingState();

    try {
      FirebaseUser firebaseUser =
          await _firebaseAuth.currentUser().then((_user) {
        return _user;
      }).catchError((error) {
        print("A5 : ${error.toString()}");
      });

      if (firebaseUser != null) {
        yield AuthenticatedState(firebaseUser);
      } else {
        yield UnauthenticatedState();
      }
    } catch (error) {
      yield UnauthenticatedState();
      print("error _mapAppStartedToState :${error.toString()}");
    }
  }

  Stream<AuthenticationState> _mapLoggedOutToState() async* {
    yield AuthenticatingState();
    try {
      await _googleSignIn.signOut();
      await _firebaseAuth.signOut();
    } catch (error) {
      print("_mapLoggedOutToState : ${error.toString()}");
    }
    yield UnauthenticatedState();
  }
}
