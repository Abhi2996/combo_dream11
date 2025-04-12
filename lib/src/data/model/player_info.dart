import 'package:combo_dream11/src/data/model/career_stats.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class PlayerInfo extends Equatable {
  final String id;
  final String name;
  final DateTime? birthDate;
  final String? birthPlace;
  final String? nickname;
  final String? role;
  final String? battingStyle;
  final String? bowlingStyle;
  final String? internationalTeam;
  final String? iplTeam;
  final List<CareerStats>? cricketStats;

  static const Uuid _uuid = Uuid();

  PlayerInfo({
    String? id,
    required this.name,
    this.birthDate,
    this.birthPlace,
    this.nickname,
    this.role,
    this.battingStyle,
    this.bowlingStyle,
    this.internationalTeam,
    this.iplTeam,
    this.cricketStats,
  }) : id = id ?? _generateId(name);

  static String _generateId(String name) {
    String uuid = _uuid.v4();
    String formattedName = name.toLowerCase().replaceAll(" ", "_");
    return "$formattedName-$uuid";
  }

  /// 📅 Weekday of birth
  String? get dayOfWeek =>
      birthDate != null ? _weekdayNames[birthDate!.weekday] : null;

  /// 📆 Week number of the year from birthDate
  String? get birthWeek =>
      birthDate != null
          ? "Week ${int.parse(DateFormat('w').format(birthDate!))}"
          : null;

  static const Map<int, String> _weekdayNames = {
    1: "Monday",
    2: "Tuesday",
    3: "Wednesday",
    4: "Thursday",
    5: "Friday",
    6: "Saturday",
    7: "Sunday",
  };

  factory PlayerInfo.fromJson(Map<String, dynamic> json) {
    return PlayerInfo(
      id: json['id'],
      name: json['name'],
      birthDate:
          json['birthDate'] != null ? DateTime.parse(json['birthDate']) : null,
      birthPlace: json['birthPlace'],
      nickname: json['nickname'],
      role: json['role'],
      battingStyle: json['battingStyle'],
      bowlingStyle: json['bowlingStyle'],
      internationalTeam: json['internationalTeam'],
      iplTeam: json['iplTeam'],
      cricketStats:
          json['cricketStats'] != null
              ? (json['cricketStats'] as List)
                  .map((item) => CareerStats.fromJson(item))
                  .toList()
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'birthDate': birthDate?.toIso8601String(),
      'birthPlace': birthPlace,
      'nickname': nickname,
      'role': role,
      'battingStyle': battingStyle,
      'bowlingStyle': bowlingStyle,
      'internationalTeam': internationalTeam,
      'iplTeam': iplTeam,
      'cricketStats': cricketStats?.map((e) => e.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [
    id,
    name,
    birthDate,
    birthPlace,
    nickname,
    role,
    battingStyle,
    bowlingStyle,
    internationalTeam,
    iplTeam,
    cricketStats,
  ];
}
