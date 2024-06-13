import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/model/place_details.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:my_app/data/api/api_checker.dart';
import 'package:my_app/data/repository/location_repo.dart';
import 'package:my_app/models/address_model.dart';
import 'package:my_app/models/response_model.dart';

class LocationController extends GetxController implements GetxService {
  LocationRepo locationRepo;

  LocationController({required this.locationRepo});
  late Position _position;
  late Position _pickPosition;

  bool _loading = false;
  Placemark _placemark = Placemark();
  Placemark _pickPlacemark = Placemark();
  Placemark get placemark => _placemark;
  Placemark get pickPlacemark => _pickPlacemark;
  List<AddressModel> _addressList = [];
  List<AddressModel> get addressList => _addressList;
  late List<AddressModel> _allAddressList;
  List<AddressModel> get allAddressList => _allAddressList;
  final List<String> _addressTypeList = ["home", "office", "others"];
  List<String> get addressTypeList => _addressTypeList;
  int _addressTypeIndex = 0;
  int get addressTypeIndex => _addressTypeIndex;

  late GoogleMapController _mapController;
  GoogleMapController get mapController => _mapController;
  bool _updateAddressData = true;
  bool _changeAddress = true;

  bool get loading => _loading;
  Position get position => _position;
  Position get pickPosition => _pickPosition;
  bool _isLoading = false;
  bool get isLading => _isLoading;

  bool _inZone = false;
  bool get inZone => _inZone;

  bool _buttonDisabled = true;
  bool get buttonDisabled => _buttonDisabled;

  List<Prediction> _predictionList = [];
  Future<void> getCurrentLocation(bool fromAddress,
      {required GoogleMapController mapController,
      LatLng? defaultLatLng,
      bool notify = true}) async {
    _loading = true;
    if (notify) {
      update();
    }
    AddressModel _addressModel;
    late Position _myPosition;
    Position _test;
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) async {
      _myPosition = position;
      if (fromAddress) {
        _position = _myPosition;
      } else {
        _pickPosition = _myPosition;
      }
      mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(_myPosition.latitude, _myPosition.longitude),
          zoom: 17)));
      Placemark _myPlaceMark;
      Future<Placemark> handleAddressRetrievalError(Position position) async {
        String _address = await getAddressfromGeocode(
            LatLng(position.latitude, position.longitude));
        return Placemark(
            name: _address, locality: '', postalCode: '', country: '');
      }

      try {
        if (!GetPlatform.isWeb) {
          List<Placemark> placeMarks = await placemarkFromCoordinates(
              _myPosition.latitude, _myPosition.longitude);
          _myPlaceMark = placeMarks.first;
        } else {
          String _address = await getAddressfromGeocode(
              LatLng(_myPosition.latitude, _myPosition.longitude));
          _myPlaceMark = Placemark(
              name: _address, locality: '', postalCode: '', country: '');
        }
      } catch (e) {
        _myPlaceMark = await handleAddressRetrievalError(_myPosition);
      }

      fromAddress ? _placemark = _myPlaceMark : _pickPlacemark = _myPlaceMark;
      _addressModel = AddressModel(
          latitude: _myPosition.latitude.toString(),
          longitude: _myPosition.longitude.toString(),
          address: '${_myPlaceMark.name ?? ''}'
              '${_myPlaceMark.locality ?? ''}'
              '${_myPlaceMark.postalCode ?? ''}'
              '${_myPlaceMark.country ?? ''}',
          addressType: null);
      _loading = false;
      update();
    }).catchError((e) {
      _myPosition = Position(
          longitude: defaultLatLng != null
              ? defaultLatLng.longitude
              : double.parse('0'),
          latitude: defaultLatLng != null
              ? defaultLatLng.latitude
              : double.parse('0'),
          timestamp: DateTime.now(),
          accuracy: 1,
          altitude: 1,
          altitudeAccuracy: 0,
          heading: 1,
          headingAccuracy: 0,
          speed: 1,
          speedAccuracy: 0);
    });
  }

  void setMapController(GoogleMapController mapController) {
    _mapController = mapController;
  }

  void updatePosition(CameraPosition position, bool fromAddress) async {
    if (_updateAddressData) {
      _loading = true;
      update();
      try {
        if (fromAddress) {
          _position = Position(
              latitude: position.target.latitude,
              longitude: position.target.longitude,
              timestamp: DateTime.now(),
              heading: 1,
              accuracy: 1,
              altitude: 1,
              speedAccuracy: 1,
              speed: 1,
              altitudeAccuracy: 0,
              headingAccuracy: 0);
        } else {
          _pickPosition = Position(
              latitude: position.target.latitude,
              longitude: position.target.longitude,
              timestamp: DateTime.now(),
              heading: 1,
              accuracy: 1,
              altitude: 1,
              speedAccuracy: 1,
              speed: 1,
              altitudeAccuracy: 0,
              headingAccuracy: 0);
        }
        ResponseModel _reponseModel = await getZone(
            position.target.latitude.toString(),
            position.target.longitude.toString(),
            false);
        _buttonDisabled = !_reponseModel.isSuccess;
        if (_changeAddress) {
          //TODO(thanhbt): uncomment when call api get address
          // String _address = await getAddressfromGeocode(
          //     LatLng(position.target.latitude,
          //         position.target.longitude));
          List<Placemark> placemarks = await placemarkFromCoordinates(
            _pickPosition.latitude,
            _pickPosition.longitude,
          );
          if (placemarks.isNotEmpty) {
            Placemark placemark = placemarks.first;
            String address =
                "${placemark.street}, ${placemark.locality}, ${placemark.administrativeArea} ${placemark.postalCode}, ${placemark.country}";
            print("ThanhBT: $address");
            fromAddress
                ? _placemark = Placemark(name: address)
                : _pickPlacemark = Placemark(name: address);
          } else {
            print("Address not found");
          }

          //TODO(thanhbt): uncomment when check api response
          // fromAddress
          //     ? _placemark = Placemark(name: _address)
          //     : _pickPlacemark = Placemark(name: _address);
        }
      } catch (e) {
        print(e);
      }
      _loading = false;
      update();
    } else {
      _updateAddressData = true;
    }
  }

  Future<String> getAddressfromGeocode(LatLng latlng) async {
    String _address = "Unkown Location Found";
    Response response = await locationRepo.getAddressfromGeocode(latlng);
    if (response.body["status"] == 'OK') {
      _address = response.body['results'][0]['formatted_address'].toString();
      //print("printing address"+_address);
    } else {
      print("Error getting the google api");
    }
    update();
    return _address;
  }

  late Map<String, dynamic> _getAddress;
  Map<String, dynamic> get getAddress => _getAddress;
  AddressModel getUserAddress() {
    late AddressModel _addressModel;
    _getAddress = jsonDecode(locationRepo.getUserAddress());
    try {
      _addressModel =
          AddressModel.fromJson(jsonDecode(locationRepo.getUserAddress()));
    } catch (e) {
      print(e);
    }
    return _addressModel;
  }

  void setAddressTypeIndex(int index) {
    _addressTypeIndex = index;
    update();
  }

  Future<ResponseModel> addAddress(AddressModel addressModel) async {
    _loading = true;
    update();
    Response response = await locationRepo.addAddress(addressModel);
    ResponseModel responseModel;

    if (response.statusCode == 200) {
      await getAddressList();
      String message = response.body["message"];
      responseModel = ResponseModel(true, message);
      await saveUserAddress(addressModel);
    } else {
      print("couldn't save the address");
      responseModel = ResponseModel(false, response.statusText!);
    }
    update();
    return responseModel;
  }

  Future<void> getAddressList() async {
    Response response = await locationRepo.getAllAddress();
    if (response.statusCode == 200) {
      _addressList = [];
      _allAddressList = [];
      print("body: ${response.body}");

      response.body.forEach((address) {
        _addressList.add(AddressModel.fromJson(address));
        _allAddressList.add(AddressModel.fromJson(address));
      });
    } else {
      _addressList = [];
      _allAddressList = [];
    }
    update();
  }

  Future<bool> saveUserAddress(AddressModel addressModel) async {
    String userAddress = jsonEncode(addressModel.toJson());
    return await locationRepo.saveUserAddress(userAddress);
  }

  void clearAddressList() {
    _addressList = [];
    _allAddressList = [];
    update();
  }

  String getUserAddressFromLocalStorage() {
    return locationRepo.getUserAddress();
  }

  void setAddAddressData() {
    _position = _pickPosition;
    _placemark = _pickPlacemark;
    _updateAddressData = false;
    update();
  }

  Future<ResponseModel> getZone(String lat, String lng, bool markerLoad) async {
    late ResponseModel _reponseModel;

    if (markerLoad) {
      _loading = true;
    } else {
      _isLoading = true;
    }
    update();
    Response response = await locationRepo.getZone(lat, lng);
    if (response.statusCode == 200) {
      _inZone = true;
      _reponseModel = ResponseModel(true, response.body["zone_id"].toString());
    } else {
      _inZone = false;
      _reponseModel = ResponseModel(true, response.statusText!);
    }
    if (markerLoad) {
      _loading = false;
    } else {
      _isLoading = false;
    }
    update();
    return _reponseModel;
  }

  Future<List<Prediction>> searchLocation(
      BuildContext context, String text) async {
    if (text.isNotEmpty) {
      Response response = await locationRepo.searchLocation(text);
      if (response.statusCode == 200 && response.body['status'] == 'OK') {
        _predictionList = [];
        response.body['predictions'].forEach((prediction) =>
            _predictionList.add(Prediction.fromJson(prediction)));
      } else {
        ApiChecker.checkApi(response);
      }
    }
    return _predictionList;
  }

  setLocation(
      String placeID, String address, GoogleMapController mapController) async {
    _loading = true;
    update();
    PlaceDetails detail;
    Response response = await locationRepo.setLocation(String, placeID);
    detail = PlaceDetails.fromJson(response.body);
  }
}
