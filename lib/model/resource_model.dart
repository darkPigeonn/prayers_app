class ResourceModel {
  String? title;
  String? content;
  String? excerpt;
  String? publishDate;
  String? author;

  ResourceModel({this.title, this.content, this.excerpt, this.publishDate, this.author});

  ResourceModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    content = json['content'];
    excerpt = json['excerpt'];
    publishDate = json['publishDate'];
    author = json['author'];
   
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['content'] = this.content;
    data['excerpt'] = this.excerpt;
    data['publishDate'] = this.publishDate;
    data['author'] = this.author;

    return data;
  }
}

