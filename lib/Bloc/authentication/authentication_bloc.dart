import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';
import 'package:shuttle_student_bus/Design/home.dart';
import 'package:shuttle_student_bus/Design/signinPage.dart';

part 'authentication_event.dart';

part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  var _firebaseAuth = FirebaseAuth.instance;

  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'https://www.googleapis.com/auth/contacts.readonly'],
  );

  @override
  AuthenticationState get initialState => InitialAuthenticationState();

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event) async* {
    if (event is GoogleLogin) {
      yield* _mapGoogleLoginToState(event);
    } else if (event is AppStarted) {
      yield* _mapLoggedInToState();
    } else if (event is LogOut) {
      yield* _mapLoggedOutToState();
    }
  }

  Stream<AuthenticationState> _mapAppStartedToState() async* {
    yield AuthenticatingState();
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
        yield Authenticated(user);
        Navigator.push(
          event.context,
          MaterialPageRoute(builder: (BuildContext context) => HomePage()),
        );
      } else {
        print("Unauthenticated");
        yield Unauthenticated();
      }
    } catch (error) {
      print("A4 : ${error.toString()}");
      yield Unauthenticated();
    }
  }

  Stream<AuthenticationState> _mapLoggedInToState() async* {
    yield AuthenticatingState();

    try {
      FirebaseUser firebaseUser =
          await _firebaseAuth.currentUser().then((_user) {
        return _user;
      }).catchError((error) {
        print("A5 : ${error.toString()}");
      });

      if (firebaseUser != null) {
        yield Authenticated(firebaseUser);
      } else {
        yield Unauthenticated();
      }
    } catch (error) {
      yield Unauthenticated();
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
    yield Unauthenticated();
  }
}
