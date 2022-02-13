import 'dart:async';
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

class AuthenticationService{
  //we instantiate the local authentication and make it globaly available using static
  static final localAuth = LocalAuthentication();
  //we instantiate an instance of storage 
  final _storage = new FlutterSecureStorage();
  //we instaniate some string controllersto get the latest status of authentication of user
  final StreamController<bool> _isEnabledController =
      StreamController<bool>.broadcast();
  final StreamController<bool> _isNewUserController =
      StreamController<bool>.broadcast();
  //our gcontrollers from controllers
  StreamController<bool> get isEnabledController => _isEnabledController;
  StreamController<bool> get isNewUserController => _isNewUserController;
  //our gcontrollers from streamers
  Stream<bool> get isEnabledStream => _isEnabledController.stream;
  Stream<bool> get isNewUserStream => _isNewUserController.stream;

  //method to handle the storage, we pass the key
  Future<String> read(String key) async {
    //try to read the key from the storage
    final val = await this._storage.read(key: key);
    //we return value otherwise an empty string
    return val != null ? jsonDecode(val) : '';
  }

  //this method clears everything regarding the storage
  Future<void> clearStorage() async {
    this._storage.delete(key: 'pin');
  }
  //we write to the storage
  Future<void> write(String key, dynamic value) async {
    await this._storage.write(key: key, value: jsonEncode(value));
  }
  //we check if the pin code that we have saved is in the local storage
  Future<void> verifyCode(String enteredCode) async {
    final pin = await this.read('pin');
    if (pin != null && pin == enteredCode) {
      this.isNewUserController.add(false);
    } else {
      this.isNewUserController.add(true);
      this.write('pin', enteredCode);
    }
    this.isEnabledController.add(true);
  }
  //we close the controllers
  dispose() {
    this._isEnabledController.close();
    this._isNewUserController.close();
  }
}
//authentication instances that can be used globally(to avaoid creating one in every class)
final AuthenticationService authService = AuthenticationService();
final localAuth = AuthenticationService.localAuth;