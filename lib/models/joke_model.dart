class Joke {
  final int id;
  final String type;
  final String setup;
  final String punchline;
  final int? displayedAt;

  Joke({
    required this.id,
    required this.type,
    required this.setup,
    required this.punchline,
    int? displayedAt,
  }) : displayedAt = displayedAt ?? DateTime.now().millisecondsSinceEpoch;

  // Convert from Map (e.g. from sqflite or JSON)
  factory Joke.fromMap(Map<String, dynamic> map) {
    return Joke(
      id: map['id'] as int,
      type: map['type'] as String,
      setup: map['setup'] as String,
      punchline: map['punchline'] as String,
      displayedAt: map['displayedAt'] ?? DateTime.now().millisecondsSinceEpoch,
    );
  }

  // Convert to Map (e.g. for inserting into database)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'setup': setup,
      'punchline': punchline,
      'displayedAt': displayedAt,
    };
  }
}
