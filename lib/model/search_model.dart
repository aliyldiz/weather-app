class SearchModel {
  List<Results>? results;
  Query? query;

  SearchModel({this.results, this.query});

  SearchModel.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = <Results>[];
      json['results'].forEach((v) {
        results!.add(new Results.fromJson(v));
      });
    }
    query = json['query'] != null ? new Query.fromJson(json['query']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.results != null) {
      data['results'] = this.results!.map((v) => v.toJson()).toList();
    }
    if (this.query != null) {
      data['query'] = this.query!.toJson();
    }
    return data;
  }
}

class Results {
  Datasource? datasource;
  String? country;
  String? countryCode;
  String? state;
  late String city;
  String? village;
  String? postcode;
  String? district;
  String? suburb;
  String? street;
  String? housenumber;
  double? lon;
  double? lat;
  var formatted;
  String? addressLine1;
  String? addressLine2;
  Timezone? timezone;
  String? plusCode;
  String? plusCodeShort;
  String? resultType;
  Rank? rank;
  String? placeId;
  Bbox? bbox;

  Results(
      {this.datasource,
        this.country,
        this.countryCode,
        this.state,
        required this.city,
        this.village,
        this.postcode,
        this.district,
        this.suburb,
        this.street,
        this.housenumber,
        this.lon,
        this.lat,
        required this.formatted,
        this.addressLine1,
        this.addressLine2,
        this.timezone,
        this.plusCode,
        this.plusCodeShort,
        this.resultType,
        this.rank,
        this.placeId,
        this.bbox});

  Results.fromJson(Map<String, dynamic> json) {
    datasource = json['datasource'] != null
        ? Datasource.fromJson(json['datasource'])
        : null;
    country = json['country'];
    countryCode = json['country_code'];
    state = json['state'];
    city = json['city'];
    village = json['village'];
    postcode = json['postcode'];
    district = json['district'];
    suburb = json['suburb'];
    street = json['street'];
    housenumber = json['housenumber'];
    lon = json['lon'];
    lat = json['lat'];
    formatted = json['formatted'];
    addressLine1 = json['address_line1'];
    addressLine2 = json['address_line2'];
    timezone = json['timezone'] != null
        ? new Timezone.fromJson(json['timezone'])
        : null;
    plusCode = json['plus_code'];
    plusCodeShort = json['plus_code_short'];
    resultType = json['result_type'];
    rank = json['rank'] != null ? new Rank.fromJson(json['rank']) : null;
    placeId = json['place_id'];
    bbox = json['bbox'] != null ? new Bbox.fromJson(json['bbox']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.datasource != null) {
      data['datasource'] = this.datasource!.toJson();
    }
    data['country'] = this.country;
    data['country_code'] = this.countryCode;
    data['state'] = this.state;
    data['city'] = this.city;
    data['village'] = this.village;
    data['postcode'] = this.postcode;
    data['district'] = this.district;
    data['suburb'] = this.suburb;
    data['street'] = this.street;
    data['housenumber'] = this.housenumber;
    data['lon'] = this.lon;
    data['lat'] = this.lat;
    data['formatted'] = this.formatted;
    data['address_line1'] = this.addressLine1;
    data['address_line2'] = this.addressLine2;
    if (this.timezone != null) {
      data['timezone'] = this.timezone!.toJson();
    }
    data['plus_code'] = this.plusCode;
    data['plus_code_short'] = this.plusCodeShort;
    data['result_type'] = this.resultType;
    if (this.rank != null) {
      data['rank'] = this.rank!.toJson();
    }
    data['place_id'] = this.placeId;
    if (this.bbox != null) {
      data['bbox'] = this.bbox!.toJson();
    }
    return data;
  }
}

class Datasource {
  String? sourcename;
  String? attribution;
  String? license;
  String? url;

  Datasource({this.sourcename, this.attribution, this.license, this.url});

  Datasource.fromJson(Map<String, dynamic> json) {
    sourcename = json['sourcename'];
    attribution = json['attribution'];
    license = json['license'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sourcename'] = this.sourcename;
    data['attribution'] = this.attribution;
    data['license'] = this.license;
    data['url'] = this.url;
    return data;
  }
}

class Timezone {
  String? name;
  String? offsetSTD;
  int? offsetSTDSeconds;
  String? offsetDST;
  int? offsetDSTSeconds;
  String? abbreviationSTD;
  String? abbreviationDST;

  Timezone(
      {this.name,
        this.offsetSTD,
        this.offsetSTDSeconds,
        this.offsetDST,
        this.offsetDSTSeconds,
        this.abbreviationSTD,
        this.abbreviationDST});

  Timezone.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    offsetSTD = json['offset_STD'];
    offsetSTDSeconds = json['offset_STD_seconds'];
    offsetDST = json['offset_DST'];
    offsetDSTSeconds = json['offset_DST_seconds'];
    abbreviationSTD = json['abbreviation_STD'];
    abbreviationDST = json['abbreviation_DST'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['offset_STD'] = this.offsetSTD;
    data['offset_STD_seconds'] = this.offsetSTDSeconds;
    data['offset_DST'] = this.offsetDST;
    data['offset_DST_seconds'] = this.offsetDSTSeconds;
    data['abbreviation_STD'] = this.abbreviationSTD;
    data['abbreviation_DST'] = this.abbreviationDST;
    return data;
  }
}

class Rank {
  double? importance;
  int? confidence;
  int? confidenceCityLevel;
  int? confidenceStreetLevel;
  String? matchType;

  Rank(
      {this.importance,
        this.confidence,
        this.confidenceCityLevel,
        this.confidenceStreetLevel,
        this.matchType});

  Rank.fromJson(Map<String, dynamic> json) {
    importance = json['importance'];
    confidence = json['confidence'];
    confidenceCityLevel = json['confidence_city_level'];
    confidenceStreetLevel = json['confidence_street_level'];
    matchType = json['match_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['importance'] = this.importance;
    data['confidence'] = this.confidence;
    data['confidence_city_level'] = this.confidenceCityLevel;
    data['confidence_street_level'] = this.confidenceStreetLevel;
    data['match_type'] = this.matchType;
    return data;
  }
}

class Bbox {
  double? lon1;
  double? lat1;
  double? lon2;
  double? lat2;

  Bbox({this.lon1, this.lat1, this.lon2, this.lat2});

  Bbox.fromJson(Map<String, dynamic> json) {
    lon1 = json['lon1'];
    lat1 = json['lat1'];
    lon2 = json['lon2'];
    lat2 = json['lat2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lon1'] = this.lon1;
    data['lat1'] = this.lat1;
    data['lon2'] = this.lon2;
    data['lat2'] = this.lat2;
    return data;
  }
}

class Query {
  String? text;
  Parsed? parsed;

  Query({this.text, this.parsed});

  Query.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    parsed =
    json['parsed'] != null ? new Parsed.fromJson(json['parsed']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['text'] = this.text;
    if (this.parsed != null) {
      data['parsed'] = this.parsed!.toJson();
    }
    return data;
  }
}

class Parsed {
  String? housenumber;
  String? street;
  String? city;
  String? expectedType;

  Parsed({this.housenumber, this.street, this.city, this.expectedType});

  Parsed.fromJson(Map<String, dynamic> json) {
    housenumber = json['housenumber'];
    street = json['street'];
    city = json['city'];
    expectedType = json['expected_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['housenumber'] = this.housenumber;
    data['street'] = this.street;
    data['city'] = this.city;
    data['expected_type'] = this.expectedType;
    return data;
  }
}
