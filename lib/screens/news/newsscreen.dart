import 'package:final_year_project/screens/news/news_models.dart';
import 'package:final_year_project/screens/news/newsdetailscreen.dart';
import 'package:final_year_project/them/color.dart';
import 'package:flutter/material.dart';

class NewsScreen extends StatelessWidget {
  static const String routename = "NewsScreen";

  // بيانات وهمية للأخبار الصحية
  final List<NewsModel> newsList = [
    NewsModel(
      id: '1',
      title: 'اكتشاف علاج جديد لمرض السكري',
      description:
          'أعلن باحثون عن اكتشاف علاج جديد لمرض السكري من النوع الثاني يعتمد على تقنية الخلايا الجذعية.',
      imageUrl:
          'https://images.unsplash.com/photo-1576091160550-2173dba999ef?w=300',
      date: DateTime.now().subtract(const Duration(hours: 2)),
      source: 'المجلة الطبية',
      category: 'أبحاث طبية',
    ),
    NewsModel(
      id: '2',
      title: 'نصائح للحفاظ على صحة القلب',
      description:
          'أصدرت جمعية القلب الأمريكية قائمة بأهم 10 نصائح للحفاظ على صحة القلب وتجنب الأمراض القلبية.',
      imageUrl:
          'https://images.unsplash.com/photo-1530026186672-2cd00ffc50fe?w=300',
      date: DateTime.now().subtract(const Duration(days: 1)),
      source: 'جمعية القلب الأمريكية',
      category: 'صحة القلب',
    ),
    NewsModel(
      id: '3',
      title: 'فوائد الصوم المتقطع للجسم',
      description:
          'دراسة جديدة تؤكد أن الصوم المتقطع لمدة 16 ساعة يومياً يساعد في تحسين وظائف الجسم وتجديد الخلايا.',
      imageUrl:
          'https://images.unsplash.com/photo-1498837167922-ddd27525d352?w=300',
      date: DateTime.now().subtract(const Duration(days: 3)),
      source: 'مركز الأبحاث الصحية',
      category: 'التغذية',
    ),
    NewsModel(
      id: '4',
      title: 'تحذير من انتشار إنفلونزا جديدة',
      description:
          'منظمة الصحة العالمية تحذر من سلالة جديدة من الإنفلونزا تنتشر بسرعة في عدة دول حول العالم.',
      imageUrl:
          'https://images.unsplash.com/photo-1584483766114-2cea6facdf57?w=300',
      date: DateTime.now().subtract(const Duration(days: 5)),
      source: 'منظمة الصحة العالمية',
      category: 'أمراض معدية',
    ),
  ];

  NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('الأخبار الصحية'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // يمكنك إضافة وظيفة البحث هنا
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: newsList.length,
        itemBuilder: (context, index) {
          final news = newsList[index];
          return NewsCard(news: news);
        },
      ),
    );
  }
}

class NewsCard extends StatelessWidget {
  final NewsModel news;

  const NewsCard({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewsDetailScreen(news: news),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12.0)),
              child: Image.network(
                news.imageUrl,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 180,
                  color: Colors.grey[300],
                  child: const Icon(Icons.medical_services,
                      size: 50, color: Colors.teal),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (news.category != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      decoration: BoxDecoration(
                        color: Colors.teal.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Text(
                        news.category!,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Colors.teal[800],
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  const SizedBox(height: 8.0),
                  Text(
                    news.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.teal[900],
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    news.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.medical_information,
                              size: 16, color: Colors.teal),
                          const SizedBox(width: 4),
                          Text(
                            news.source,
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  color: Colors.teal[700],
                                ),
                          ),
                        ],
                      ),
                      Text(
                        '${news.date.day}/${news.date.month}/${news.date.year}',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Colors.grey,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
