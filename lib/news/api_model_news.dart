class NewsItem {
  final String title;
  final String description;
  final String url;
  final String imageUrl;
  final String source;

  NewsItem({
    required this.title,
    required this.description,
    required this.url,
    required this.imageUrl,
    required this.source,
  });

  factory NewsItem.fromJson(Map<String, dynamic> json) {
    return NewsItem(
      title: json['name'] ?? '',
      description: json['description'] ?? '',
      url: json['url'] ?? '',
      imageUrl: json['image'] ?? '',
      source: json['source'] ?? '',
    );
  }
}
