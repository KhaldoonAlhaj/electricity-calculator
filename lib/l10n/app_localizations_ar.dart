// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'حاسبة الكهرباء';

  @override
  String get drawerHome => 'الرئيسية';

  @override
  String get drawerHomeSub => 'نظرة عامة على الفترة الحالية';

  @override
  String get drawerHistory => 'السجل';

  @override
  String get drawerHistorySub => 'جميع الفترات السابقة';

  @override
  String get drawerLegal => 'إخلاء المسؤولية القانوني';

  @override
  String get drawerLegalSub => 'الشروط وإخلاء المسؤولية';

  @override
  String get drawerAbout => 'معلومات عنا';

  @override
  String get drawerAboutSub => 'جهات الاتصال والمعلومات';

  @override
  String get drawerExit => 'خروج';

  @override
  String get version => 'الإصدار 1.0.0';

  @override
  String get currentPeriod => 'الفترة الحالية';

  @override
  String get period => 'الفترة';

  @override
  String get noPeriod => 'لا توجد فترة';

  @override
  String get kWhUsed => 'كيلوواط ساعي مستخدم';

  @override
  String get avg => 'المتوسط';

  @override
  String get perDay => 'كيلوواط ساعي/يوم';

  @override
  String get remainingBeforeTier2 => 'المتبقي قبل الشريحة الثانية';

  @override
  String get youExceeded300 => 'لقد تجاوزت 300 كيلوواط ساعي';

  @override
  String get costBreakdown => 'تفصيل التكلفة';

  @override
  String get tier1 => 'الشريحة الأولى';

  @override
  String get tier2 => 'الشريحة الثانية';

  @override
  String get tier1Range => '≤300 كيلوواط ساعي';

  @override
  String get tier2Range => '>300 كيلوواط ساعي';

  @override
  String get rate6 => '6 ل.س/كيلوواط ساعي';

  @override
  String get rate14 => '14 ل.س/كيلوواط ساعي';

  @override
  String get totalCost => 'التكلفة الإجمالية';

  @override
  String get recentReadings => 'القراءات الأخيرة';

  @override
  String get noReadingsYet => 'لا توجد قراءات بعد';

  @override
  String get addReading => 'إضافة قراءة';

  @override
  String get editReading => 'تعديل القراءة';

  @override
  String get deleteReading => 'حذف القراءة';

  @override
  String get deleteConfirm => 'هل أنت متأكد من حذف هذه القراءة؟';

  @override
  String get cancel => 'إلغاء';

  @override
  String get save => 'حفظ';

  @override
  String get delete => 'حذف';

  @override
  String get kWh => 'ك.و.س';

  @override
  String get year => 'السنة';

  @override
  String get billingPeriod => 'فترة الفاتورة';

  @override
  String get dateAndTime => 'التاريخ والوقت';

  @override
  String get newElectricityReading => 'قراءة جديدة';

  @override
  String get kilowattReading => 'قراءة الكيلوواط ساعي (كيلوواط ساعي)';

  @override
  String get required => 'مطلوب';

  @override
  String get invalidNumber => 'رقم غير صالح';

  @override
  String get readingSaved => 'تم حفظ القراءة!';

  @override
  String get readingUpdated => 'تم تحديث القراءة';

  @override
  String get readingDeleted => 'تم حذف القراءة';

  @override
  String get errorSaving => 'خطأ: ';

  @override
  String get allReadings => 'جميع القراءات';

  @override
  String get totalConsumption => 'الاستهلاك الإجمالي';

  @override
  String get tierDetails => 'تفاصيل الشرائح';

  @override
  String get legalNotice => 'إشعار قانوني';

  @override
  String get legalText =>
      'هذا التطبيق ليس مربحًا ولا تابعًا لأي جهة حكومية. تم تصميمه فقط لمساعدة الأشخاص على تتبع استهلاك الكهرباء للاستخدام الشخصي. المطور غير مسؤول عن أي مشاكل تتعلق بالمدفوعات الحكومية أو القوانين المحلية.';

  @override
  String get noLiability => 'لا قبول للمسؤولية';

  @override
  String get iUnderstand => 'أنا أفهم';

  @override
  String get aboutUs => 'معلومات عنا';

  @override
  String get developer => 'المطور';

  @override
  String get builtWith => 'تم التطوير بكل حب وبمساعدة DeepSeek';

  @override
  String get contact => 'اتصل بنا';

  @override
  String get telegram => 'تيليغرام';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get scanQR => 'امسح رمز QR للاتصال @Khaldoon_Alhaj على تيليغرام';

  @override
  String get openTelegram => 'فتح تيليغرام';

  @override
  String get showQR => 'إظهار رمز QR';

  @override
  String get close => 'إغلاق';

  @override
  String get noPeriodsFound => 'لا توجد فترات.';

  @override
  String get addFirstReading => 'أضف قراءة لإنشاء أول فترة لك.';

  @override
  String get reading => 'قراءة';

  @override
  String get readings => 'قراءات';

  @override
  String get paid => 'مدفوعة';

  @override
  String get refresh => 'تحديث';

  @override
  String get electricityPrice => 'سعر الكهرباء';

  @override
  String get totalKiloWatts => 'إجمالي الكيلوواط';

  @override
  String get trackUsage => 'تتبع استهلاكك';

  @override
  String get language => 'اللغة';

  @override
  String get next => 'التالي';

  @override
  String get skip => 'تخطي';

  @override
  String get getStarted => 'ابدأ الآن';

  @override
  String get onboardingTitle1 => 'تتبع استهلاكك';

  @override
  String get onboardingDesc1 =>
      'تتبع استهلاك الكهرباء بسهولة من خلال قراءات العداد واحصل على تفصيل واضح للتكاليف.';

  @override
  String get onboardingTitle2 => 'أضف قراءات بسرعة';

  @override
  String get onboardingDesc2 =>
      'أضف قراءات جديدة في ثوانٍ باستخدام نموذجنا البسيط. يتم تخزين بياناتك بشكل آمن على جهازك.';

  @override
  String get onboardingTitle3 => 'عرض سجلك';

  @override
  String get onboardingDesc3 =>
      'راجع الفترات السابقة، وشاهد اتجاهات استهلاكك، واحسب التكاليف بأسعار الشرائح.';

  @override
  String get welcome => 'مرحباً!';

  @override
  String get addElectricityMeter => 'إضافة عداد كهرباء';

  @override
  String get setUpFirstMeter => 'لنقم بإعداد أول عداد كهرباء لك';

  @override
  String get addNewMeter => 'أضف عداداً جديداً للتتبع بشكل منفصل';

  @override
  String get meterName => 'اسم العداد';

  @override
  String get consumptionType => 'نوع الاستهلاك';

  @override
  String get homeOfficeShop => 'مثال: منزل، مكتب، متجر';

  @override
  String get pleaseEnterName => 'الرجاء إدخال اسم';

  @override
  String get household => 'منزلي';

  @override
  String get industrial => 'صناعي';

  @override
  String get commercial => 'تجاري';

  @override
  String get startTracking => 'ابدأ التتبع';

  @override
  String get addMeter => 'إضافة عداد';

  @override
  String get consumption => 'الاستهلاك';

  @override
  String get used => 'المستخدم';

  @override
  String get oldSyp => 'ل.س قديمة';

  @override
  String get newSyp => 'ل.س جديدة';

  @override
  String get syp => 'ل.س';

  @override
  String get rateLabel => 'السعر';

  @override
  String get noMeterFound => 'لا يوجد عداد. الرجاء إنشاء واحد أولاً.';

  @override
  String get drawerMeters => 'العدادات';

  @override
  String get drawerMetersSub => 'إدارة عدادات الكهرباء الخاصة بك';

  @override
  String get metersTitle => 'العدادات';

  @override
  String get cannotDeleteDefault =>
      'لا يمكن حذف العداد الافتراضي. قم بتعيين عداد آخر كافتراضي أولاً.';

  @override
  String get deleteMeterTitle => 'حذف العداد';

  @override
  String deleteMeterContent(Object name) {
    return 'حذف \"$name\"؟ سيتم فقدان جميع الفترات والقراءات الخاصة به.';
  }

  @override
  String get noMetersYet => 'لا توجد عدادات بعد.';

  @override
  String get addFirstMeter => 'أضف أول عداد لك';

  @override
  String get defaultLabel => 'افتراضي';

  @override
  String get meterDeleted => 'تم حذف العداد';

  @override
  String get noMeterFoundTitle => 'لا يوجد عداد.';

  @override
  String get noMeterFoundSubtitle => 'الرجاء إضافة عداد من القائمة الجانبية.';

  @override
  String get totalUsage => 'إجمالي الاستهلاك';

  @override
  String get developerName => 'خلدون الحاج';

  @override
  String get tutorialTitle => 'كيفية الاستخدام';

  @override
  String get tutorialSubtitle => 'تعلم الأساسيات';

  @override
  String get tutorialOverviewTitle => 'ما هو هذا التطبيق؟';

  @override
  String get tutorialOverviewDesc =>
      'تساعدك حاسبة الكهرباء على تتبع استهلاك الكهرباء وتكاليفها لعدة عدادات، مع أسعار شرائح للمنازل وأسعار موحدة للصناعي والتجاري.';

  @override
  String get tutorialAddReadingTitle => 'إضافة قراءة';

  @override
  String get tutorialAddReadingDesc =>
      'اضغط على زر + الأخضر في الصفحة الرئيسية، أدخل قراءة الكيلوواط ساعي، حدد فترة الفاتورة والتاريخ، ثم احفظ. سيقوم التطبيق بتحديث الاستهلاك والسعر فوراً.';

  @override
  String get tutorialConsumptionTitle => 'الاستهلاك والأسعار';

  @override
  String get tutorialConsumptionDesc =>
      'تعرض الصفحة الرئيسية استهلاك الفترة الحالية، والمتبقي قبل الشريحة الثانية (للمنازل)، وتفصيل التكلفة. يتم عرض الأسعار بالليرة السورية القديمة والجديدة.';

  @override
  String get tutorialMinReadingsTitle => 'قراءتان مطلوبتان';

  @override
  String get tutorialMinReadingsDesc =>
      'يحسب التطبيق الاستهلاك كالفرق بين قراءتين للعداد. تحتاج إلى قراءتين على الأقل للفترة لرؤية الاستهلاك والتكاليف.';

  @override
  String get tutorialHistoryTitle => 'صفحة السجل';

  @override
  String get tutorialHistoryDesc =>
      'اضغط على \'السجل\' في القائمة الجانبية لعرض جميع الفترات السابقة. تعرض كل فترة إجمالي الاستهلاك، تفاصيل الشرائح، التكلفة الإجمالية، وقائمة بجميع القراءات. يمكنك توسيع أي فترة للحصول على التفاصيل الكاملة.';

  @override
  String get tutorialAddMeterTitle => 'إضافة عداد جديد';

  @override
  String get tutorialAddMeterDesc =>
      'من القائمة الجانبية، انتقل إلى \'العدادات\'، اضغط على زر +، أعطِ اسماً لعدادك واختر نوعه (منزلي، صناعي، أو تجاري). يمكنك تعيين أي عداد كافتراضي.';

  @override
  String get tutorialEditDeleteTitle => 'تعديل أو حذف قراءة';

  @override
  String get tutorialEditDeleteDesc =>
      'في الصفحة الرئيسية، كل قراءة لها قائمة من ثلاث نقاط. اضغط عليها لتعديل القيمة أو التاريخ، أو حذف القراءة بالكامل. سيقوم التطبيق بإعادة حساب الاستهلاك والتكاليف تلقائياً.';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get settingsSubtitle => 'تفضيلات التطبيق';

  @override
  String get darkMode => 'الوضع الليلي';

  @override
  String get darkModeSubtitle => 'التبديل بين الوضع الفاتح والداكن';

  @override
  String get exportData => 'تصدير البيانات';

  @override
  String get exportDataSubtitle => 'تصدير جميع الفترات والقراءات كملف CSV';

  @override
  String get languageChangeInDrawer => 'يمكنك تغيير اللغة من القائمة الجانبية.';

  @override
  String get consumptionChart => 'رسم بياني للاستهلاك';

  @override
  String get addAtLeastTwoPeriods =>
      'أضف فترتين على الأقل لمشاهدة الرسم البياني.';
}
