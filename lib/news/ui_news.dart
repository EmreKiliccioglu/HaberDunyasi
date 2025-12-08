import 'package:flutter/material.dart' hide MenuBar;
import 'package:untitled5/core/menu.dart';
import '../l10n/app_localizations.dart';
import 'api_model_news.dart';
import 'package:url_launcher/url_launcher.dart';

class UiNews extends StatelessWidget {
  final String title;
  final List<NewsItem> news;
  final bool isLoading;
  final String? error;

  const UiNews({
    required this.title,
    required this.news,
    required this.isLoading,
    this.error,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MenuBar.build(title: title, context: context),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
          ? Center(child: Text('${AppLocalizations.of(context)!.error}: $error'))
          : news.isEmpty
          ? Center(
        child: Text(
          AppLocalizations.of(context)!.noData,
          style: TextStyle(fontSize: 20),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: news.length,
        itemBuilder: (context, index) {
          final item = news[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: InkWell(
              onTap: () async {
                final uri = Uri.parse(item.url.trim());
                final snackBarMessage = AppLocalizations.of(context)!.linkNotOpen;
                final scaffoldMessenger = ScaffoldMessenger.of(context);
                final success = await launchUrl(
                  uri,
                  mode: LaunchMode.externalApplication,
                );
                if (!success) {
                  scaffoldMessenger.showSnackBar(
                    SnackBar(content: Text(snackBarMessage)),
                  );
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.black26
                          : Colors.black12,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (item.imageUrl.isNotEmpty)
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                        child: Image.network(
                          item.imageUrl,
                          width: double.infinity,
                          height: 180,
                          fit: BoxFit.cover,
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            item.description,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${AppLocalizations.of(context)!.source}: ${item.source}',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: Theme.of(context).textTheme.bodySmall!.color),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
