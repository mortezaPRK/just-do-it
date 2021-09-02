class BloodPressure {
  final int id;
  final DateTime createdAt;
  final int min;
  final int max;

  BloodPressure({this.id, this.min, this.max, createdAt})
      : createdAt = createdAt ?? DateTime.now();

  BloodPressure replaceWith({int min, int max}) {
    return BloodPressure(min: min ?? this.min, max: max ?? this.max);
  }

  BloodPressure validate() =>
      min > max ? replaceWith(min: max, max: min) : this;

  Map<String, dynamic> toMap() {
    var map = {
      'min': min,
      'max': max,
      'created_at': (createdAt.millisecondsSinceEpoch / 1000).round()
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  static BloodPressure fromMap(Map<String, dynamic> input) {
    return BloodPressure(
      id: input['id'],
      max: input['max'],
      min: input['min'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        input['created_at'] * 1000,
      ),
    );
  }

  String toString() =>
      "id: $id, min: $min, max: $max, createdAt: ${createdAt.toIso8601String()}";
}
