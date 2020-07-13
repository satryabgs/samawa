// To parse this JSON data, do
//
//     final timeAdzan = timeAdzanFromJson(jsonString);

import 'dart:convert';

TimeAdzan timeAdzanFromJson(String str) => TimeAdzan.fromJson(jsonDecode(str));

String timeAdzanToJson(TimeAdzan data) => json.encode(data.toJson());

class TimeAdzan {
    TimeAdzan({
        this.status,
        this.query,
        this.jadwal,
    });

    String status;
    Query query;
    Jadwal jadwal;

    factory TimeAdzan.fromJson(Map<String, dynamic> json) => TimeAdzan(
        status: json["status"],
        query: Query.fromJson(json["query"]),
        jadwal: Jadwal.fromJson(json["jadwal"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "query": query.toJson(),
        "jadwal": jadwal.toJson(),
    };
}

class Jadwal {
    Jadwal({
        this.status,
        this.data,
    });

    String status;
    Data data;

    factory Jadwal.fromJson(Map<String, dynamic> json) => Jadwal(
        status: json["status"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
    };
}

class Data {
    Data({
        this.ashar,
        this.dhuha,
        this.dzuhur,
        this.imsak,
        this.isya,
        this.maghrib,
        this.subuh,
        this.tanggal,
        this.terbit,
    });

    String ashar;
    String dhuha;
    String dzuhur;
    String imsak;
    String isya;
    String maghrib;
    String subuh;
    String tanggal;
    String terbit;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        ashar: json["ashar"],
        dhuha: json["dhuha"],
        dzuhur: json["dzuhur"],
        imsak: json["imsak"],
        isya: json["isya"],
        maghrib: json["maghrib"],
        subuh: json["subuh"],
        tanggal: json["tanggal"],
        terbit: json["terbit"],
    );

    Map<String, dynamic> toJson() => {
        "ashar": ashar,
        "dhuha": dhuha,
        "dzuhur": dzuhur,
        "imsak": imsak,
        "isya": isya,
        "maghrib": maghrib,
        "subuh": subuh,
        "tanggal": tanggal,
        "terbit": terbit,
    };
}

class Query {
    Query({
        this.format,
        this.kota,
        this.tanggal,
    });

    String format;
    String kota;
    DateTime tanggal;

    factory Query.fromJson(Map<String, dynamic> json) => Query(
        format: json["format"],
        kota: json["kota"],
        tanggal: DateTime.parse(json["tanggal"]),
    );

    Map<String, dynamic> toJson() => {
        "format": format,
        "kota": kota,
        "tanggal": "${tanggal.year.toString().padLeft(4, '0')}-${tanggal.month.toString().padLeft(2, '0')}-${tanggal.day.toString().padLeft(2, '0')}",
    };
}
