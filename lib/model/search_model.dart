class SearchModel {
  List<Results>? results;
  Query? query;

  SearchModel({this.results, this.query});

  SearchModel.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = <Results>[];
      json['results'].forEach((v) {
        results!.add(Results.fromJson(v));
      });
    }
    query = json['query'] != null ? Query.fromJson(json['query']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (results != null) {
      data['results'] = results!.map((v) => v.toJson()).toList();
    }
    if (query != null) {
      data['query'] = query!.toJson();
    }
    return data;
  }
}

class Results {
  Datasource? datasource;
  var country;
  String? countryCode;
  String? state;
  var city;
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
        required this.country,
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
        ? Timezone.fromJson(json['timezone'])
        : null;
    plusCode = json['plus_code'];
    plusCodeShort = json['plus_code_short'];
    resultType = json['result_type'];
    rank = json['rank'] != null ? Rank.fromJson(json['rank']) : null;
    placeId = json['place_id'];
    bbox = json['bbox'] != null ? Bbox.fromJson(json['bbox']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (datasource != null) {
      data['datasource'] = datasource!.toJson();
    }
    data['country'] = country;
    data['country_code'] = countryCode;
    data['state'] = state;
    data['city'] = city;
    data['village'] = village;
    data['postcode'] = postcode;
    data['district'] = district;
    data['suburb'] = suburb;
    data['street'] = street;
    data['housenumber'] = housenumber;
    data['lon'] = lon;
    data['lat'] = lat;
    data['formatted'] = formatted;
    data['address_line1'] = addressLine1;
    data['address_line2'] = addressLine2;
    if (timezone != null) {
      data['timezone'] = timezone!.toJson();
    }
    data['plus_code'] = plusCode;
    data['plus_code_short'] = plusCodeShort;
    data['result_type'] = resultType;
    if (rank != null) {
      data['rank'] = rank!.toJson();
    }
    data['place_id'] = placeId;
    if (bbox != null) {
      data['bbox'] = bbox!.toJson();
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sourcename'] = sourcename;
    data['attribution'] = attribution;
    data['license'] = license;
    data['url'] = url;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['offset_STD'] = offsetSTD;
    data['offset_STD_seconds'] = offsetSTDSeconds;
    data['offset_DST'] = offsetDST;
    data['offset_DST_seconds'] = offsetDSTSeconds;
    data['abbreviation_STD'] = abbreviationSTD;
    data['abbreviation_DST'] = abbreviationDST;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['importance'] = importance;
    data['confidence'] = confidence;
    data['confidence_city_level'] = confidenceCityLevel;
    data['confidence_street_level'] = confidenceStreetLevel;
    data['match_type'] = matchType;
    return data;
  }
}

class Bbox {
  var lon1;
  var lat1;
  var lon2;
  var lat2;

  Bbox({this.lon1, this.lat1, this.lon2, this.lat2});

  Bbox.fromJson(Map<String, dynamic> json) {
    lon1 = json['lon1'];
    lat1 = json['lat1'];
    lon2 = json['lon2'];
    lat2 = json['lat2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lon1'] = lon1;
    data['lat1'] = lat1;
    data['lon2'] = lon2;
    data['lat2'] = lat2;
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
    json['parsed'] != null ? Parsed.fromJson(json['parsed']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['text'] = text;
    if (parsed != null) {
      data['parsed'] = parsed!.toJson();
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['housenumber'] = housenumber;
    data['street'] = street;
    data['city'] = city;
    data['expected_type'] = expectedType;
    return data;
  }
}
