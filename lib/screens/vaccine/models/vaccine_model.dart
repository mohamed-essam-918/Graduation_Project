import 'package:intl/intl.dart';

class Vaccine {
  final String id;
  final String name;
  final String description;
  final Duration schedule;
  bool isTaken;
  Vaccine({
    required this.id,
    required this.name,
    required this.description,
    required this.schedule,
    required this.isTaken,
  });
  DateTime calculateDate(DateTime birthDate) {
    return birthDate.add(schedule);
  }

  Vaccine copyWith({bool? isTaken}) {
    return Vaccine(
      id: id,
      name: name,
      description: description,
      schedule: schedule,
      isTaken: isTaken ?? this.isTaken,
    );
  }
}

final List<Vaccine> defaultVaccines = [
  Vaccine(
    id: '1',
    name: 'الالتهاب الكبدي B (الجرعة الأولى)',
    description:
        'تحمي هذه الجرعة من فيروس التهاب الكبد B، الذي يصيب الكبد ويسبب التهابات مزمنة قد تؤدي إلى تليف الكبد أو سرطان الكبد. يُعطى خلال أول 24 ساعة من الولادة لتقليل فرص انتقال العدوى من الأم أو المحيط.',
    schedule: Duration(days: 0),
    isTaken: false,
  ),
  Vaccine(
    id: '2',
    name: 'الدرن (BCG)',
    description:
        'لقاح يُعطى لحماية الطفل من مرض السل (الدرن)، خاصةً الأشكال الخطيرة التي تصيب الدماغ والرئتين. يترك علامة مميزة في الذراع وغالبًا ما يُعطى خلال الأيام الأولى من الولادة.',
    schedule: Duration(days: 0),
    isTaken: false,
  ),
  Vaccine(
    id: '3',
    name: 'شلل الأطفال الفموي (الجرعة الصفرية)',
    description:
        'جرعة وقائية مبكرة تُعطى في الفم لحماية الطفل من الإصابة بفيروس شلل الأطفال، الذي قد يؤدي إلى إعاقة دائمة في الأطراف أو حتى الوفاة.',
    schedule: Duration(days: 0),
    isTaken: false,
  ),
  Vaccine(
    id: '4',
    name: 'شلل الأطفال الفموي (الجرعة الأولى)',
    description:
        'تُعطى لتعزيز مناعة الطفل ضد فيروس شلل الأطفال، وهي أول جرعة من ثلاث جرعات رئيسية. ضرورية لتكوين المناعة الفعالة.',
    schedule: Duration(days: 60),
    isTaken: false,
  ),
  Vaccine(
    id: '5',
    name: 'التطعيم الخماسي (الجرعة الأولى)',
    description:
        'تطعيم مركب يحمي من خمسة أمراض خطيرة: الدفتيريا، السعال الديكي، التيتانوس، التهاب الكبد B، والمستدمية النزلية (Hib). تُعطى كحقنة عضلية.',
    schedule: Duration(days: 60),
    isTaken: false,
  ),
  Vaccine(
    id: '6',
    name: 'شلل الأطفال الفموي (الجرعة الثانية)',
    description:
        'استمرار لبرنامج التحصين ضد شلل الأطفال. الجرعة الثانية ضرورية لبناء مناعة قوية واستكمال سلسلة اللقاح.',
    schedule: Duration(days: 120),
    isTaken: false,
  ),
  Vaccine(
    id: '7',
    name: 'التطعيم الخماسي (الجرعة الثانية)',
    description:
        'الجرعة الثانية من اللقاح الخماسي، تعمل على تعزيز المناعة المكتسبة من الجرعة الأولى، وتقليل فرصة الإصابة بالأمراض المستهدفة.',
    schedule: Duration(days: 120),
    isTaken: false,
  ),
  Vaccine(
    id: '8',
    name: 'شلل الأطفال الفموي (الجرعة الثالثة)',
    description:
        'الجرعة النهائية في السلسلة الأساسية ضد فيروس شلل الأطفال. تضمن مناعة مكتملة ضد الفيروس في أغلب الحالات.',
    schedule: Duration(days: 180),
    isTaken: false,
  ),
  Vaccine(
    id: '9',
    name: 'التطعيم الخماسي (الجرعة الثالثة)',
    description:
        'الجرعة الثالثة والأخيرة في التطعيم الخماسي الأساسي، تُكمل التحصين ضد الدفتيريا، التيتانوس، السعال الديكي، التهاب الكبد B، والمستدمية النزلية.',
    schedule: Duration(days: 180),
    isTaken: false,
  ),
  Vaccine(
    id: '10',
    name: 'الالتهاب الكبدي B (الجرعة الثالثة)',
    description:
        'تُكمل سلسلة التطعيم ضد التهاب الكبد B، وتوفر حماية طويلة الأمد من الإصابة بالفيروس ومضاعفاته الخطيرة.',
    schedule: Duration(days: 180),
    isTaken: false,
  ),
  Vaccine(
    id: '11',
    name: 'الحصبة (الجرعة الأولى)',
    description:
        'تطعيم ضد فيروس الحصبة، أحد أكثر الفيروسات عدوى، والذي يمكن أن يسبب التهاب رئوي، التهابات في الدماغ، أو الوفاة. يُعطى عند 9 شهور ويُعتبر ضروريًا جدًا.',
    schedule: Duration(days: 270),
    isTaken: false,
  ),
  Vaccine(
    id: '12',
    name: 'شلل الأطفال الفموي (الجرعة الرابعة)',
    description:
        'جرعة تنشيطية تُعطى بعد انتهاء السلسلة الأساسية، تضمن استمرار المناعة الفعالة حتى ما قبل المدرسة.',
    schedule: Duration(days: 365),
    isTaken: false,
  ),
  Vaccine(
    id: '13',
    name: 'MMR (الجرعة الأولى)',
    description:
        'لقاح ثلاثي ضد الحصبة، الحصبة الألمانية، والنكاف. يُعطى عند عمر سنة، ويحمي من أمراض فيروسية تسبب مضاعفات خطيرة على الدماغ أو الخصوبة.',
    schedule: Duration(days: 365),
    isTaken: false,
  ),
  Vaccine(
    id: '14',
    name: 'الجديري المائي (اختياري)',
    description:
        'لقاح يُعطى اختياريًا لحماية الطفل من الجديري المائي (العنقز)، وهو مرض فيروسي معدٍ يسبب بثورًا وحمى، ويمكن أن يؤدي إلى مضاعفات في بعض الحالات.',
    schedule: Duration(days: 365),
    isTaken: false,
  ),
  Vaccine(
    id: '15',
    name: 'شلل الأطفال الفموي (الجرعة الخامسة)',
    description:
        'آخر جرعة فموية من لقاح شلل الأطفال. تُعطى عند عمر سنة ونصف، وتُعد هامة لضمان استمرار المناعة المكتسبة.',
    schedule: Duration(days: 548),
    isTaken: false,
  ),
  Vaccine(
    id: '16',
    name: 'الثلاثي البكتيري DTP Booster',
    description:
        'جرعة تنشيطية ضد الدفتيريا والتيتانوس والسعال الديكي، تُعطى بعد انتهاء الجرعات الأساسية، لضمان استمرار الحماية مع التقدم في العمر.',
    schedule: Duration(days: 548),
    isTaken: false,
  ),
  Vaccine(
    id: '17',
    name: 'MMR (الجرعة الثانية)',
    description:
        'الجرعة الثانية من اللقاح الثلاثي (MMR) لتعزيز المناعة وضمان فعالية طويلة ضد الحصبة، الحصبة الألمانية، والنكاف.',
    schedule: Duration(days: 548),
    isTaken: false,
  ),
  Vaccine(
    id: '18',
    name: 'منشطات ما قبل المدرسة (شلل - ثلاثي - MMR)',
    description:
        'تُعطى هذه المنشطات قبل دخول الطفل للمدرسة، وتشمل شلل الأطفال، الثلاثي البكتيري، وMMR. الهدف منها تجديد المناعة ضد هذه الأمراض استعدادًا للتعرض المجتمعي.',
    schedule: Duration(days: 1460),
    isTaken: false,
  ),
];
