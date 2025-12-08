import 'package:flutter/material.dart' hide MenuBar;
import '../core/global.dart';
import '../l10n/app_localizations.dart';
import 'ui_news.dart';
import 'service_news.dart';
import 'api_model_news.dart';

class MainNews extends StatefulWidget {
  const MainNews({super.key});

  @override
  State<MainNews> createState() => _MainNewsState();
}

class _MainNewsState extends State<MainNews> {
  final NewsService _service = NewsService();
  List<NewsItem> _news = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    appLocale.addListener(() {
      _fetchNews();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchNews();
    });
  }

  void _fetchNews() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final data = await _service.getNews(context: context);
      setState(() => _news = data);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return UiNews(
      title: AppLocalizations.of(context)!.news,
      news: _news,
      isLoading: _isLoading,
      error: _error,
    );
  }
}
