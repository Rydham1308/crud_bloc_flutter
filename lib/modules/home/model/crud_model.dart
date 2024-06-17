class CrudModel {
  final bool? fav;
  final String? title;
  final String? description;
  final int? id;

  const CrudModel({this.fav, this.title, this.id, this.description});

  CrudModel copyWith({
    bool? fav,
    int? id,
    String? title,
    String? description,
  }) {
    return CrudModel(
      fav: fav ?? this.fav,
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'is_fav': fav,
      };

  CrudModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        description = json['description'],
        fav = json['is_fav'];
}
