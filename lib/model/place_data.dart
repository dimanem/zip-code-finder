class PlaceData {
  String _name;
  String _zipCode;

  PlaceData(this._name, this._zipCode);

  String get name => _name;

  String get zipCode => _zipCode;

  @override
  String toString() {
    return 'ZipCodeData{_name: $_name, _zipCode: $_zipCode}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is PlaceData &&
              runtimeType == other.runtimeType &&
              _name == other._name &&
              _zipCode == other._zipCode;

  @override
  int get hashCode =>
      _name.hashCode ^
      _zipCode.hashCode;
}