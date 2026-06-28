import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Electricity Calculator'**
  String get appTitle;

  /// No description provided for @drawerHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get drawerHome;

  /// No description provided for @drawerHomeSub.
  ///
  /// In en, this message translates to:
  /// **'Current period overview'**
  String get drawerHomeSub;

  /// No description provided for @drawerHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get drawerHistory;

  /// No description provided for @drawerHistorySub.
  ///
  /// In en, this message translates to:
  /// **'All previous periods'**
  String get drawerHistorySub;

  /// No description provided for @drawerLegal.
  ///
  /// In en, this message translates to:
  /// **'Legal & Disclaimer'**
  String get drawerLegal;

  /// No description provided for @drawerLegalSub.
  ///
  /// In en, this message translates to:
  /// **'Terms and liability notice'**
  String get drawerLegalSub;

  /// No description provided for @drawerAbout.
  ///
  /// In en, this message translates to:
  /// **'About Us'**
  String get drawerAbout;

  /// No description provided for @drawerAboutSub.
  ///
  /// In en, this message translates to:
  /// **'Contact & info'**
  String get drawerAboutSub;

  /// No description provided for @drawerExit.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get drawerExit;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version 1.0.0'**
  String get version;

  /// No description provided for @currentPeriod.
  ///
  /// In en, this message translates to:
  /// **'Current Period'**
  String get currentPeriod;

  /// No description provided for @period.
  ///
  /// In en, this message translates to:
  /// **'Period'**
  String get period;

  /// No description provided for @noPeriod.
  ///
  /// In en, this message translates to:
  /// **'No period'**
  String get noPeriod;

  /// No description provided for @kWhUsed.
  ///
  /// In en, this message translates to:
  /// **'kWh used'**
  String get kWhUsed;

  /// No description provided for @avg.
  ///
  /// In en, this message translates to:
  /// **'Avg'**
  String get avg;

  /// No description provided for @perDay.
  ///
  /// In en, this message translates to:
  /// **'kWh/day'**
  String get perDay;

  /// No description provided for @remainingBeforeTier2.
  ///
  /// In en, this message translates to:
  /// **'Remaining before Tier 2'**
  String get remainingBeforeTier2;

  /// No description provided for @youExceeded300.
  ///
  /// In en, this message translates to:
  /// **'You exceeded 300 kWh'**
  String get youExceeded300;

  /// No description provided for @costBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Cost Breakdown'**
  String get costBreakdown;

  /// No description provided for @tier1.
  ///
  /// In en, this message translates to:
  /// **'Tier 1'**
  String get tier1;

  /// No description provided for @tier2.
  ///
  /// In en, this message translates to:
  /// **'Tier 2'**
  String get tier2;

  /// No description provided for @tier1Range.
  ///
  /// In en, this message translates to:
  /// **'≤300 kWh'**
  String get tier1Range;

  /// No description provided for @tier2Range.
  ///
  /// In en, this message translates to:
  /// **'>300 kWh'**
  String get tier2Range;

  /// No description provided for @rate6.
  ///
  /// In en, this message translates to:
  /// **'6 SYP/kWh'**
  String get rate6;

  /// No description provided for @rate14.
  ///
  /// In en, this message translates to:
  /// **'14 SYP/kWh'**
  String get rate14;

  /// No description provided for @totalCost.
  ///
  /// In en, this message translates to:
  /// **'Total cost'**
  String get totalCost;

  /// No description provided for @recentReadings.
  ///
  /// In en, this message translates to:
  /// **'Recent Readings'**
  String get recentReadings;

  /// No description provided for @noReadingsYet.
  ///
  /// In en, this message translates to:
  /// **'No readings yet'**
  String get noReadingsYet;

  /// No description provided for @addReading.
  ///
  /// In en, this message translates to:
  /// **'Add Reading'**
  String get addReading;

  /// No description provided for @editReading.
  ///
  /// In en, this message translates to:
  /// **'Edit Reading'**
  String get editReading;

  /// No description provided for @deleteReading.
  ///
  /// In en, this message translates to:
  /// **'Delete Reading'**
  String get deleteReading;

  /// No description provided for @deleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this reading?'**
  String get deleteConfirm;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @kWh.
  ///
  /// In en, this message translates to:
  /// **'kWh'**
  String get kWh;

  /// No description provided for @year.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get year;

  /// No description provided for @billingPeriod.
  ///
  /// In en, this message translates to:
  /// **'Billing period'**
  String get billingPeriod;

  /// No description provided for @dateAndTime.
  ///
  /// In en, this message translates to:
  /// **'Date & time'**
  String get dateAndTime;

  /// No description provided for @newElectricityReading.
  ///
  /// In en, this message translates to:
  /// **'New electricity reading'**
  String get newElectricityReading;

  /// No description provided for @kilowattReading.
  ///
  /// In en, this message translates to:
  /// **'Kilowatt reading (kWh)'**
  String get kilowattReading;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @invalidNumber.
  ///
  /// In en, this message translates to:
  /// **'Invalid number'**
  String get invalidNumber;

  /// No description provided for @readingSaved.
  ///
  /// In en, this message translates to:
  /// **'Reading saved!'**
  String get readingSaved;

  /// No description provided for @readingUpdated.
  ///
  /// In en, this message translates to:
  /// **'Reading updated'**
  String get readingUpdated;

  /// No description provided for @readingDeleted.
  ///
  /// In en, this message translates to:
  /// **'Reading deleted'**
  String get readingDeleted;

  /// No description provided for @errorSaving.
  ///
  /// In en, this message translates to:
  /// **'Error: '**
  String get errorSaving;

  /// No description provided for @allReadings.
  ///
  /// In en, this message translates to:
  /// **'All readings'**
  String get allReadings;

  /// No description provided for @totalConsumption.
  ///
  /// In en, this message translates to:
  /// **'Total consumption'**
  String get totalConsumption;

  /// No description provided for @tierDetails.
  ///
  /// In en, this message translates to:
  /// **'Tier details'**
  String get tierDetails;

  /// No description provided for @legalNotice.
  ///
  /// In en, this message translates to:
  /// **'LEGAL NOTICE'**
  String get legalNotice;

  /// No description provided for @legalText.
  ///
  /// In en, this message translates to:
  /// **'This app is not profitable and is not affiliated with any government entity. It is designed solely to help people track their electricity usage for personal reference. The developer is not accountable for any issues related to government payments or local laws.'**
  String get legalText;

  /// No description provided for @noLiability.
  ///
  /// In en, this message translates to:
  /// **'No liability accepted'**
  String get noLiability;

  /// No description provided for @iUnderstand.
  ///
  /// In en, this message translates to:
  /// **'I Understand'**
  String get iUnderstand;

  /// No description provided for @aboutUs.
  ///
  /// In en, this message translates to:
  /// **'About Us'**
  String get aboutUs;

  /// No description provided for @developer.
  ///
  /// In en, this message translates to:
  /// **'Developer'**
  String get developer;

  /// No description provided for @builtWith.
  ///
  /// In en, this message translates to:
  /// **'Built with ❤️ and DeepSeek'**
  String get builtWith;

  /// No description provided for @contact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contact;

  /// No description provided for @telegram.
  ///
  /// In en, this message translates to:
  /// **'Telegram'**
  String get telegram;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @scanQR.
  ///
  /// In en, this message translates to:
  /// **'Scan to contact @Khaldoon_Alhaj on Telegram'**
  String get scanQR;

  /// No description provided for @openTelegram.
  ///
  /// In en, this message translates to:
  /// **'Open Telegram'**
  String get openTelegram;

  /// No description provided for @showQR.
  ///
  /// In en, this message translates to:
  /// **'Show QR'**
  String get showQR;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @noPeriodsFound.
  ///
  /// In en, this message translates to:
  /// **'No periods found.'**
  String get noPeriodsFound;

  /// No description provided for @addFirstReading.
  ///
  /// In en, this message translates to:
  /// **'Add a reading to create your first period.'**
  String get addFirstReading;

  /// No description provided for @reading.
  ///
  /// In en, this message translates to:
  /// **'reading'**
  String get reading;

  /// No description provided for @readings.
  ///
  /// In en, this message translates to:
  /// **'readings'**
  String get readings;

  /// No description provided for @paid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get paid;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @electricityPrice.
  ///
  /// In en, this message translates to:
  /// **'Electricity Price'**
  String get electricityPrice;

  /// No description provided for @totalKiloWatts.
  ///
  /// In en, this message translates to:
  /// **'Total Kilo Watts'**
  String get totalKiloWatts;

  /// No description provided for @trackUsage.
  ///
  /// In en, this message translates to:
  /// **'Track your usage'**
  String get trackUsage;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'Track Your Usage'**
  String get onboardingTitle1;

  /// No description provided for @onboardingDesc1.
  ///
  /// In en, this message translates to:
  /// **'Easily track your electricity consumption with meter readings and get clear cost breakdowns.'**
  String get onboardingDesc1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'Add Readings Quickly'**
  String get onboardingTitle2;

  /// No description provided for @onboardingDesc2.
  ///
  /// In en, this message translates to:
  /// **'Add new meter readings in seconds with our simple form. Your data is stored securely on your device.'**
  String get onboardingDesc2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'View Your History'**
  String get onboardingTitle3;

  /// No description provided for @onboardingDesc3.
  ///
  /// In en, this message translates to:
  /// **'Review past periods, see your consumption trends, and calculate costs with tiered pricing.'**
  String get onboardingDesc3;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome!'**
  String get welcome;

  /// No description provided for @addElectricityMeter.
  ///
  /// In en, this message translates to:
  /// **'Add an Electricity Meter'**
  String get addElectricityMeter;

  /// No description provided for @setUpFirstMeter.
  ///
  /// In en, this message translates to:
  /// **'Let’s set up your first electricity meter'**
  String get setUpFirstMeter;

  /// No description provided for @addNewMeter.
  ///
  /// In en, this message translates to:
  /// **'Add a new meter to track separately'**
  String get addNewMeter;

  /// No description provided for @meterName.
  ///
  /// In en, this message translates to:
  /// **'Meter Name'**
  String get meterName;

  /// No description provided for @consumptionType.
  ///
  /// In en, this message translates to:
  /// **'Consumption Type'**
  String get consumptionType;

  /// No description provided for @homeOfficeShop.
  ///
  /// In en, this message translates to:
  /// **'e.g., Home, Office, Shop'**
  String get homeOfficeShop;

  /// No description provided for @pleaseEnterName.
  ///
  /// In en, this message translates to:
  /// **'Please enter a name'**
  String get pleaseEnterName;

  /// No description provided for @household.
  ///
  /// In en, this message translates to:
  /// **'Household'**
  String get household;

  /// No description provided for @industrial.
  ///
  /// In en, this message translates to:
  /// **'Industrial'**
  String get industrial;

  /// No description provided for @commercial.
  ///
  /// In en, this message translates to:
  /// **'Commercial'**
  String get commercial;

  /// No description provided for @startTracking.
  ///
  /// In en, this message translates to:
  /// **'Start Tracking'**
  String get startTracking;

  /// No description provided for @addMeter.
  ///
  /// In en, this message translates to:
  /// **'Add Meter'**
  String get addMeter;

  /// No description provided for @consumption.
  ///
  /// In en, this message translates to:
  /// **'Consumption'**
  String get consumption;

  /// No description provided for @used.
  ///
  /// In en, this message translates to:
  /// **'Used'**
  String get used;

  /// No description provided for @oldSyp.
  ///
  /// In en, this message translates to:
  /// **'old SYP'**
  String get oldSyp;

  /// No description provided for @newSyp.
  ///
  /// In en, this message translates to:
  /// **'new SYP'**
  String get newSyp;

  /// No description provided for @syp.
  ///
  /// In en, this message translates to:
  /// **'SYP'**
  String get syp;

  /// No description provided for @rateLabel.
  ///
  /// In en, this message translates to:
  /// **'Rate'**
  String get rateLabel;

  /// No description provided for @noMeterFound.
  ///
  /// In en, this message translates to:
  /// **'No meter found. Please create one first.'**
  String get noMeterFound;

  /// No description provided for @drawerMeters.
  ///
  /// In en, this message translates to:
  /// **'Meters'**
  String get drawerMeters;

  /// No description provided for @drawerMetersSub.
  ///
  /// In en, this message translates to:
  /// **'Manage your electricity meters'**
  String get drawerMetersSub;

  /// No description provided for @metersTitle.
  ///
  /// In en, this message translates to:
  /// **'Meters'**
  String get metersTitle;

  /// No description provided for @cannotDeleteDefault.
  ///
  /// In en, this message translates to:
  /// **'Cannot delete the default meter. Set another as default first.'**
  String get cannotDeleteDefault;

  /// No description provided for @deleteMeterTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Meter'**
  String get deleteMeterTitle;

  /// No description provided for @deleteMeterContent.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{name}\"? All its periods and readings will be lost.'**
  String deleteMeterContent(Object name);

  /// No description provided for @noMetersYet.
  ///
  /// In en, this message translates to:
  /// **'No meters yet.'**
  String get noMetersYet;

  /// No description provided for @addFirstMeter.
  ///
  /// In en, this message translates to:
  /// **'Add your first meter'**
  String get addFirstMeter;

  /// No description provided for @defaultLabel.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get defaultLabel;

  /// No description provided for @meterDeleted.
  ///
  /// In en, this message translates to:
  /// **'Meter deleted'**
  String get meterDeleted;

  /// No description provided for @noMeterFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'No meter found.'**
  String get noMeterFoundTitle;

  /// No description provided for @noMeterFoundSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please add a meter from the drawer.'**
  String get noMeterFoundSubtitle;

  /// No description provided for @totalUsage.
  ///
  /// In en, this message translates to:
  /// **'Total usage'**
  String get totalUsage;

  /// No description provided for @developerName.
  ///
  /// In en, this message translates to:
  /// **'Khaldoun Alhaj'**
  String get developerName;

  /// No description provided for @tutorialTitle.
  ///
  /// In en, this message translates to:
  /// **'How to use'**
  String get tutorialTitle;

  /// No description provided for @tutorialSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Learn the basics'**
  String get tutorialSubtitle;

  /// No description provided for @tutorialOverviewTitle.
  ///
  /// In en, this message translates to:
  /// **'What is this app?'**
  String get tutorialOverviewTitle;

  /// No description provided for @tutorialOverviewDesc.
  ///
  /// In en, this message translates to:
  /// **'Electricity Calculator helps you track electricity consumption and costs for multiple meters, with tiered pricing for household and flat rates for industrial/commercial.'**
  String get tutorialOverviewDesc;

  /// No description provided for @tutorialAddReadingTitle.
  ///
  /// In en, this message translates to:
  /// **'Add a reading'**
  String get tutorialAddReadingTitle;

  /// No description provided for @tutorialAddReadingDesc.
  ///
  /// In en, this message translates to:
  /// **'Tap the green + button on the main page, enter the kWh reading, select the billing period and date, then save. The app will instantly update your consumption and price.'**
  String get tutorialAddReadingDesc;

  /// No description provided for @tutorialConsumptionTitle.
  ///
  /// In en, this message translates to:
  /// **'Consumption & prices'**
  String get tutorialConsumptionTitle;

  /// No description provided for @tutorialConsumptionDesc.
  ///
  /// In en, this message translates to:
  /// **'The home page shows your current period\'s usage, remaining tier (for household), and a detailed cost breakdown. Both old and new SYP prices are displayed.'**
  String get tutorialConsumptionDesc;

  /// No description provided for @tutorialMinReadingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Two readings needed'**
  String get tutorialMinReadingsTitle;

  /// No description provided for @tutorialMinReadingsDesc.
  ///
  /// In en, this message translates to:
  /// **'The app calculates consumption as the difference between two meter readings. You need at least two readings for a period to see usage and costs.'**
  String get tutorialMinReadingsDesc;

  /// No description provided for @tutorialHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'History page'**
  String get tutorialHistoryTitle;

  /// No description provided for @tutorialHistoryDesc.
  ///
  /// In en, this message translates to:
  /// **'Tap \'History\' in the drawer to see all past periods. Each period shows total consumption, tier details, total cost, and a list of all readings. You can expand any period for full details.'**
  String get tutorialHistoryDesc;

  /// No description provided for @tutorialAddMeterTitle.
  ///
  /// In en, this message translates to:
  /// **'Add a new meter'**
  String get tutorialAddMeterTitle;

  /// No description provided for @tutorialAddMeterDesc.
  ///
  /// In en, this message translates to:
  /// **'From the drawer, go to \'Meters\', tap the + button, give your meter a name and choose its type (household, industrial, or commercial). You can set any meter as default.'**
  String get tutorialAddMeterDesc;

  /// No description provided for @tutorialEditDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit or delete a reading'**
  String get tutorialEditDeleteTitle;

  /// No description provided for @tutorialEditDeleteDesc.
  ///
  /// In en, this message translates to:
  /// **'On the main page, each reading has a three‑dot menu. Tap it to edit the value or date, or delete the reading entirely. The app will recalculate consumption and costs automatically.'**
  String get tutorialEditDeleteDesc;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'App preferences'**
  String get settingsSubtitle;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @darkModeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Switch between light and dark theme'**
  String get darkModeSubtitle;

  /// No description provided for @exportData.
  ///
  /// In en, this message translates to:
  /// **'Export Data'**
  String get exportData;

  /// No description provided for @exportDataSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Export all periods and readings as CSV'**
  String get exportDataSubtitle;

  /// No description provided for @languageChangeInDrawer.
  ///
  /// In en, this message translates to:
  /// **'You can change the language from the drawer.'**
  String get languageChangeInDrawer;

  /// No description provided for @consumptionChart.
  ///
  /// In en, this message translates to:
  /// **'Consumption Chart'**
  String get consumptionChart;

  /// No description provided for @addAtLeastTwoPeriods.
  ///
  /// In en, this message translates to:
  /// **'Add at least two periods to see a chart.'**
  String get addAtLeastTwoPeriods;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
