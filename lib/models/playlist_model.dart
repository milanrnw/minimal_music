class Playlist {
  final String id;
  final String name;
  final List<String> songPaths;
  final DateTime createdAt;
  final DateTime modifiedAt;

  Playlist({
    required this.id,
    required this.name,
    required this.songPaths,
    required this.createdAt,
    required this.modifiedAt,
  });

  // Create a copy with updated fields
  Playlist copyWith({
    String? id,
    String? name,
    List<String>? songPaths,
    DateTime? createdAt,
    DateTime? modifiedAt,
  }) {
    return Playlist(
      id: id ?? this.id,
      name: name ?? this.name,
      songPaths: songPaths ?? this.songPaths,
      createdAt: createdAt ?? this.createdAt,
      modifiedAt: modifiedAt ?? this.modifiedAt,
    );
  }

  // Serialize to JSON for storage
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'songPaths': songPaths,
    'createdAt': createdAt.millisecondsSinceEpoch,
    'modifiedAt': modifiedAt.millisecondsSinceEpoch,
  };

  // Deserialize from JSON
  factory Playlist.fromJson(Map<String, dynamic> json) {
    return Playlist(
      id: json['id'] as String,
      name: json['name'] as String,
      songPaths: List<String>.from(json['songPaths'] as List),
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt'] as int),
      modifiedAt: DateTime.fromMillisecondsSinceEpoch(
        json['modifiedAt'] as int,
      ),
    );
  }
}
