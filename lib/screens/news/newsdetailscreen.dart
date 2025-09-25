import 'package:final_year_project/screens/news/news_models.dart';
import 'package:final_year_project/them/color.dart';
import 'package:flutter/material.dart';

class NewsDetailScreen extends StatelessWidget {
  final NewsModel news;

  const NewsDetailScreen({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(news.title),
        centerTitle: true,
        backgroundColor: Color_Them.primaryColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'news-image-${news.id}',
              child: Image.network(
                news.imageUrl,
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 250,
                  color: Color_Them.secondaryColor,
                  child: const Icon(Icons.medical_services,
                      size: 80, color: Colors.teal),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.medical_information,
                              size: 20, color: Color_Them.primaryColor),
                          const SizedBox(width: 8),
                          Text(
                            news.source,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  color: Color_Them.primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                      Text(
                        '${news.date.day}/${news.date.month}/${news.date.year}',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: Color_Them.secondaryColor,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    news.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Color_Them.secondaryColor,
                        ),
                  ),
                  const SizedBox(height: 16.0),
                  const Divider(color: Color_Them.secondaryColor),
                  const SizedBox(height: 16.0),
                  Text(
                    news.description,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          height: 1.6,
                        ),
                  ),
                  const SizedBox(height: 24.0),
                  // معلومات إضافية
                  Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: Colors.teal[50],
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: Colors.teal[100]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'نصائح طبية',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Colors.teal[800],
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '• استشر طبيبك قبل تطبيق أي معلومات طبية\n• حافظ على نظام غذائي صحي\n• مارس الرياضة بانتظام\n• احرص على الفحوصات الدورية',
                          style: TextStyle(height: 1.8),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // مشاركة الخبر
        },
        backgroundColor: Colors.teal,
        child: const Icon(Icons.share, color: Colors.white),
      ),
    );
  }
}
