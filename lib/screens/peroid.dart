class Period {
  final DateTime startDate;
  final DateTime endDate;

  Period(this.startDate, this.endDate);

  Map<String, dynamic> toJson() => {
    'start_date': startDate.toString(),
    'end_date': endDate.toString(),
  };

  factory Period.fromJson(Map<String, dynamic> json) {
    return Period(
      DateTime.parse(json['start_date']),
      DateTime.parse(json['end_date']),
    );
  }
}
