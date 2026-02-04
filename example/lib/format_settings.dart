import 'package:flutter/material.dart';

import 'extension.dart';

class Timezone {
  final String name;
  final int offsetHours;
  final int offsetMinutes;
  final String displayName;

  const Timezone({
    required this.name,
    required this.offsetHours,
    this.offsetMinutes = 0,
    required this.displayName,
  });

  String get formattedOffset {
    final sign = offsetHours >= 0 ? '+' : '';
    final minStr = offsetMinutes == 0 ? '' : ':${offsetMinutes.toString().padLeft(2, '0')}';
    return 'UTC$sign${offsetHours.toString().padLeft(2, '0')}$minStr';
  }

  /// Get the current time in this timezone
  DateTime getCurrentTime() {
    final utcNow = DateTime.now().toUtc();
    final offsetDuration = Duration(
      hours: offsetHours,
      minutes: offsetMinutes,
    );
    return utcNow.add(offsetDuration);
  }

  /// Get formatted current time string
  String getCurrentTimeString() {
    final time = getCurrentTime();
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  String toString() => '$formattedOffset $displayName';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Timezone &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          offsetHours == other.offsetHours &&
          offsetMinutes == other.offsetMinutes;

  @override
  int get hashCode =>
      name.hashCode ^ offsetHours.hashCode ^ offsetMinutes.hashCode;
}

class TimezoneDatabase {
  static const List<Timezone> allTimezones = [
    // UTC-12
    Timezone(name: 'Baker Island', offsetHours: -12, displayName: 'Baker Island'),
    
    // UTC-11
    Timezone(name: 'Samoa', offsetHours: -11, displayName: 'Samoa'),
    Timezone(name: 'American Samoa', offsetHours: -11, displayName: 'American Samoa'),
    Timezone(name: 'Niue', offsetHours: -11, displayName: 'Niue'),
    
    // UTC-10
    Timezone(name: 'Hawaii', offsetHours: -10, displayName: 'Hawaii, United States'),
    Timezone(name: 'Cook Islands', offsetHours: -10, displayName: 'Cook Islands'),
    
    // UTC-9:30
    Timezone(name: 'Marquesas Islands', offsetHours: -9, offsetMinutes: -30, displayName: 'Marquesas Islands, French Polynesia'),
    
    // UTC-9
    Timezone(name: 'Alaska', offsetHours: -9, displayName: 'Alaska, United States'),
    Timezone(name: 'Palau', offsetHours: -9, displayName: 'Palau'),
    
    // UTC-8
    Timezone(name: 'Los Angeles', offsetHours: -8, displayName: 'Los Angeles, United States'),
    Timezone(name: 'Vancouver', offsetHours: -8, displayName: 'Vancouver, Canada'),
    Timezone(name: 'Baja California', offsetHours: -8, displayName: 'Baja California, Mexico'),
    Timezone(name: 'Tijuana', offsetHours: -8, displayName: 'Tijuana, Mexico'),
    
    // UTC-7
    Timezone(name: 'Denver', offsetHours: -7, displayName: 'Denver, United States'),
    Timezone(name: 'Phoenix', offsetHours: -7, displayName: 'Phoenix, United States'),
    Timezone(name: 'Calgary', offsetHours: -7, displayName: 'Calgary, Canada'),
    Timezone(name: 'Mexico City', offsetHours: -7, displayName: 'Mexico City, Mexico'),
    
    // UTC-6
    Timezone(name: 'Chicago', offsetHours: -6, displayName: 'Chicago, United States'),
    Timezone(name: 'Houston', offsetHours: -6, displayName: 'Houston, United States'),
    Timezone(name: 'Toronto', offsetHours: -6, displayName: 'Toronto, Canada'),
    Timezone(name: 'Guatemala City', offsetHours: -6, displayName: 'Guatemala City, Guatemala'),
    Timezone(name: 'Costa Rica', offsetHours: -6, displayName: 'Costa Rica'),
    
    // UTC-5
    Timezone(name: 'New York', offsetHours: -5, displayName: 'New York, United States'),
    Timezone(name: 'Miami', offsetHours: -5, displayName: 'Miami, United States'),
    Timezone(name: 'Montreal', offsetHours: -5, displayName: 'Montreal, Canada'),
    Timezone(name: 'Bogota', offsetHours: -5, displayName: 'Bogota, Colombia'),
    Timezone(name: 'Panama', offsetHours: -5, displayName: 'Panama'),
    Timezone(name: 'Peru', offsetHours: -5, displayName: 'Peru'),
    Timezone(name: 'Ecuador', offsetHours: -5, displayName: 'Ecuador'),
    Timezone(name: 'Jamaica', offsetHours: -5, displayName: 'Jamaica'),
    
    // UTC-4
    Timezone(name: 'Caracas', offsetHours: -4, displayName: 'Caracas, Venezuela'),
    Timezone(name: 'La Paz', offsetHours: -4, displayName: 'La Paz, Bolivia'),
    Timezone(name: 'Guyana', offsetHours: -4, displayName: 'Guyana'),
    Timezone(name: 'Suriname', offsetHours: -4, displayName: 'Suriname'),
    Timezone(name: 'Brazil Brasília', offsetHours: -4, displayName: 'Brasília, Brazil'),
    Timezone(name: 'Barbados', offsetHours: -4, displayName: 'Barbados'),
    Timezone(name: 'Trinidad and Tobago', offsetHours: -4, displayName: 'Trinidad and Tobago'),
    
    // UTC-3:30
    Timezone(name: 'St Johns', offsetHours: -3, offsetMinutes: -30, displayName: 'St. John\'s, Canada'),
    
    // UTC-3
    Timezone(name: 'São Paulo', offsetHours: -3, displayName: 'São Paulo, Brazil'),
    Timezone(name: 'Rio de Janeiro', offsetHours: -3, displayName: 'Rio de Janeiro, Brazil'),
    Timezone(name: 'Buenos Aires', offsetHours: -3, displayName: 'Buenos Aires, Argentina'),
    Timezone(name: 'Montevideo', offsetHours: -3, displayName: 'Montevideo, Uruguay'),
    Timezone(name: 'Cayenne', offsetHours: -3, displayName: 'Cayenne, French Guiana'),
    Timezone(name: 'Bahia', offsetHours: -3, displayName: 'Salvador, Brazil'),
    
    // UTC-2
    Timezone(name: 'Mid-Atlantic', offsetHours: -2, displayName: 'Mid-Atlantic'),
    Timezone(name: 'South Georgia', offsetHours: -2, displayName: 'South Georgia and South Sandwich Islands'),
    
    // UTC-1
    Timezone(name: 'Azores', offsetHours: -1, displayName: 'Azores, Portugal'),
    Timezone(name: 'Cape Verde', offsetHours: -1, displayName: 'Cape Verde'),
    
    // UTC
    Timezone(name: 'London', offsetHours: 0, displayName: 'London, United Kingdom'),
    Timezone(name: 'Dublin', offsetHours: 0, displayName: 'Dublin, Ireland'),
    Timezone(name: 'Lisbon', offsetHours: 0, displayName: 'Lisbon, Portugal'),
    Timezone(name: 'Casablanca', offsetHours: 0, displayName: 'Casablanca, Morocco'),
    Timezone(name: 'Dakar', offsetHours: 0, displayName: 'Dakar, Senegal'),
    Timezone(name: 'Ghana', offsetHours: 0, displayName: 'Ghana'),
    Timezone(name: 'Ivory Coast', offsetHours: 0, displayName: 'Ivory Coast'),
    Timezone(name: 'Gambia', offsetHours: 0, displayName: 'Gambia'),
    
    // UTC+1
    Timezone(name: 'Paris', offsetHours: 1, displayName: 'Paris, France'),
    Timezone(name: 'Berlin', offsetHours: 1, displayName: 'Berlin, Germany'),
    Timezone(name: 'Madrid', offsetHours: 1, displayName: 'Madrid, Spain'),
    Timezone(name: 'Rome', offsetHours: 1, displayName: 'Rome, Italy'),
    Timezone(name: 'Amsterdam', offsetHours: 1, displayName: 'Amsterdam, Netherlands'),
    Timezone(name: 'Brussels', offsetHours: 1, displayName: 'Brussels, Belgium'),
    Timezone(name: 'Vienna', offsetHours: 1, displayName: 'Vienna, Austria'),
    Timezone(name: 'Prague', offsetHours: 1, displayName: 'Prague, Czech Republic'),
    Timezone(name: 'Warsaw', offsetHours: 1, displayName: 'Warsaw, Poland'),
    Timezone(name: 'Budapest', offsetHours: 1, displayName: 'Budapest, Hungary'),
    Timezone(name: 'Belgrade', offsetHours: 1, displayName: 'Belgrade, Serbia'),
    Timezone(name: 'Stockholm', offsetHours: 1, displayName: 'Stockholm, Sweden'),
    Timezone(name: 'Oslo', offsetHours: 1, displayName: 'Oslo, Norway'),
    Timezone(name: 'Copenhagen', offsetHours: 1, displayName: 'Copenhagen, Denmark'),
    Timezone(name: 'Zurich', offsetHours: 1, displayName: 'Zurich, Switzerland'),
    Timezone(name: 'Johannesburg', offsetHours: 1, displayName: 'Johannesburg, South Africa'),
    Timezone(name: 'Lagos', offsetHours: 1, displayName: 'Lagos, Nigeria'),
    Timezone(name: 'Cameroon', offsetHours: 1, displayName: 'Cameroon'),
    
    // UTC+2
    Timezone(name: 'Cairo', offsetHours: 2, displayName: 'Cairo, Egypt'),
    Timezone(name: 'Athens', offsetHours: 2, displayName: 'Athens, Greece'),
    Timezone(name: 'Helsinki', offsetHours: 2, displayName: 'Helsinki, Finland'),
    Timezone(name: 'Istanbul', offsetHours: 2, displayName: 'Istanbul, Turkey'),
    Timezone(name: 'Jerusalem', offsetHours: 2, displayName: 'Jerusalem, Israel'),
    Timezone(name: 'Beirut', offsetHours: 2, displayName: 'Beirut, Lebanon'),
    Timezone(name: 'Amman', offsetHours: 2, displayName: 'Amman, Jordan'),
    Timezone(name: 'Addis Ababa', offsetHours: 2, displayName: 'Addis Ababa, Ethiopia'),
    Timezone(name: 'Nairobi', offsetHours: 2, displayName: 'Nairobi, Kenya'),
    Timezone(name: 'Harare', offsetHours: 2, displayName: 'Harare, Zimbabwe'),
    Timezone(name: 'Cape Town', offsetHours: 2, displayName: 'Cape Town, South Africa'),
    
    // UTC+3
    Timezone(name: 'Moscow', offsetHours: 3, displayName: 'Moscow, Russia'),
    Timezone(name: 'Baghdad', offsetHours: 3, displayName: 'Baghdad, Iraq'),
    Timezone(name: 'Tbilisi', offsetHours: 3, displayName: 'Tbilisi, Georgia'),
    Timezone(name: 'Baku', offsetHours: 3, displayName: 'Baku, Azerbaijan'),
    Timezone(name: 'Kuwait', offsetHours: 3, displayName: 'Kuwait'),
    Timezone(name: 'Riyadh', offsetHours: 3, displayName: 'Riyadh, Saudi Arabia'),
    Timezone(name: 'Doha', offsetHours: 3, displayName: 'Doha, Qatar'),
    Timezone(name: 'Dar es Salaam', offsetHours: 3, displayName: 'Dar es Salaam, Tanzania'),
    Timezone(name: 'Khartoum', offsetHours: 3, displayName: 'Khartoum, Sudan'),
    
    // UTC+3:30
    Timezone(name: 'Tehran', offsetHours: 3, offsetMinutes: 30, displayName: 'Tehran, Iran'),
    
    // UTC+4
    Timezone(name: 'Dubai', offsetHours: 4, displayName: 'Dubai, United Arab Emirates'),
    Timezone(name: 'Abu Dhabi', offsetHours: 4, displayName: 'Abu Dhabi, United Arab Emirates'),
    Timezone(name: 'Muscat', offsetHours: 4, displayName: 'Muscat, Oman'),
    Timezone(name: 'Baku', offsetHours: 4, displayName: 'Baku, Azerbaijan'),
    Timezone(name: 'Tbilisi', offsetHours: 4, displayName: 'Tbilisi, Georgia'),
    Timezone(name: 'Yerevan', offsetHours: 4, displayName: 'Yerevan, Armenia'),
    Timezone(name: 'Mauritius', offsetHours: 4, displayName: 'Mauritius'),
    Timezone(name: 'Seychelles', offsetHours: 4, displayName: 'Seychelles'),
    
    // UTC+4:30
    Timezone(name: 'Kabul', offsetHours: 4, offsetMinutes: 30, displayName: 'Kabul, Afghanistan'),
    
    // UTC+5
    Timezone(name: 'Karachi', offsetHours: 5, displayName: 'Karachi, Pakistan'),
    Timezone(name: 'Islamabad', offsetHours: 5, displayName: 'Islamabad, Pakistan'),
    Timezone(name: 'Tashkent', offsetHours: 5, displayName: 'Tashkent, Uzbekistan'),
    Timezone(name: 'Samarkand', offsetHours: 5, displayName: 'Samarkand, Uzbekistan'),
    Timezone(name: 'Tajikistan', offsetHours: 5, displayName: 'Tajikistan'),
    Timezone(name: 'Turkmenistan', offsetHours: 5, displayName: 'Turkmenistan'),
    
    // UTC+5:30
    Timezone(name: 'India', offsetHours: 5, offsetMinutes: 30, displayName: 'New Delhi, India'),
    Timezone(name: 'Mumbai', offsetHours: 5, offsetMinutes: 30, displayName: 'Mumbai, India'),
    Timezone(name: 'Bangalore', offsetHours: 5, offsetMinutes: 30, displayName: 'Bangalore, India'),
    Timezone(name: 'Sri Lanka', offsetHours: 5, offsetMinutes: 30, displayName: 'Sri Lanka'),
    
    // UTC+5:45
    Timezone(name: 'Nepal', offsetHours: 5, offsetMinutes: 45, displayName: 'Kathmandu, Nepal'),
    
    // UTC+6
    Timezone(name: 'Dhaka', offsetHours: 6, displayName: 'Dhaka, Bangladesh'),
    Timezone(name: 'Almaty', offsetHours: 6, displayName: 'Almaty, Kazakhstan'),
    Timezone(name: 'Astana', offsetHours: 6, displayName: 'Astana, Kazakhstan'),
    Timezone(name: 'Kyrgyzstan', offsetHours: 6, displayName: 'Kyrgyzstan'),
    
    // UTC+6:30
    Timezone(name: 'Yangon', offsetHours: 6, offsetMinutes: 30, displayName: 'Yangon, Myanmar'),
    Timezone(name: 'Naypyidaw', offsetHours: 6, offsetMinutes: 30, displayName: 'Naypyidaw, Myanmar'),
    
    // UTC+7
    Timezone(name: 'Bangkok', offsetHours: 7, displayName: 'Bangkok, Thailand'),
    Timezone(name: 'Jakarta', offsetHours: 7, displayName: 'Jakarta, Indonesia'),
    Timezone(name: 'Hanoi', offsetHours: 7, displayName: 'Hanoi, Vietnam'),
    Timezone(name: 'Ho Chi Minh', offsetHours: 7, displayName: 'Ho Chi Minh City, Vietnam'),
    Timezone(name: 'Phnom Penh', offsetHours: 7, displayName: 'Phnom Penh, Cambodia'),
    Timezone(name: 'Vientiane', offsetHours: 7, displayName: 'Vientiane, Laos'),
    Timezone(name: 'Kuala Lumpur', offsetHours: 7, displayName: 'Kuala Lumpur, Malaysia'),
    
    // UTC+8
    Timezone(name: 'Beijing', offsetHours: 8, displayName: 'Beijing, China'),
    Timezone(name: 'Shanghai', offsetHours: 8, displayName: 'Shanghai, China'),
    Timezone(name: 'Hong Kong', offsetHours: 8, displayName: 'Hong Kong'),
    Timezone(name: 'Singapore', offsetHours: 8, displayName: 'Singapore'),
    Timezone(name: 'Manila', offsetHours: 8, displayName: 'Manila, Philippines'),
    Timezone(name: 'Taipei', offsetHours: 8, displayName: 'Taipei, Taiwan'),
    Timezone(name: 'Perth', offsetHours: 8, displayName: 'Perth, Australia'),
    Timezone(name: 'Brunei', offsetHours: 8, displayName: 'Brunei'),
    Timezone(name: 'Malaysia', offsetHours: 8, displayName: 'Malaysia'),
    
    // UTC+8:45
    Timezone(name: 'Eucla', offsetHours: 8, offsetMinutes: 45, displayName: 'Eucla, Australia'),
    
    // UTC+9
    Timezone(name: 'Tokyo', offsetHours: 9, displayName: 'Tokyo, Japan'),
    Timezone(name: 'Seoul', offsetHours: 9, displayName: 'Seoul, South Korea'),
    Timezone(name: 'Pyongyang', offsetHours: 9, displayName: 'Pyongyang, North Korea'),
    Timezone(name: 'Melbourne', offsetHours: 9, displayName: 'Melbourne, Australia'),
    
    // UTC+9:30
    Timezone(name: 'Adelaide', offsetHours: 9, offsetMinutes: 30, displayName: 'Adelaide, Australia'),
    Timezone(name: 'Darwin', offsetHours: 9, offsetMinutes: 30, displayName: 'Darwin, Australia'),
    
    // UTC+10
    Timezone(name: 'Sydney', offsetHours: 10, displayName: 'Sydney, Australia'),
    Timezone(name: 'Brisbane', offsetHours: 10, displayName: 'Brisbane, Australia'),
    Timezone(name: 'Canberra', offsetHours: 10, displayName: 'Canberra, Australia'),
    Timezone(name: 'Guam', offsetHours: 10, displayName: 'Guam'),
    Timezone(name: 'Vladivostok', offsetHours: 10, displayName: 'Vladivostok, Russia'),
    Timezone(name: 'Port Moresby', offsetHours: 10, displayName: 'Port Moresby, Papua New Guinea'),
    
    // UTC+10:30
    Timezone(name: 'Lord Howe Island', offsetHours: 10, offsetMinutes: 30, displayName: 'Lord Howe Island, Australia'),
    
    // UTC+11
    Timezone(name: 'Solomon Islands', offsetHours: 11, displayName: 'Solomon Islands'),
    Timezone(name: 'Vanuatu', offsetHours: 11, displayName: 'Vanuatu'),
    Timezone(name: 'Magadan', offsetHours: 11, displayName: 'Magadan, Russia'),
    
    // UTC+12
    Timezone(name: 'New Zealand', offsetHours: 12, displayName: 'Auckland, New Zealand'),
    Timezone(name: 'Wellington', offsetHours: 12, displayName: 'Wellington, New Zealand'),
    Timezone(name: 'Fiji', offsetHours: 12, displayName: 'Fiji'),
    Timezone(name: 'Kiribati', offsetHours: 12, displayName: 'Kiribati'),
    Timezone(name: 'Nauru', offsetHours: 12, displayName: 'Nauru'),
    Timezone(name: 'Tuvalu', offsetHours: 12, displayName: 'Tuvalu'),
    Timezone(name: 'Kamchatka', offsetHours: 12, displayName: 'Kamchatka, Russia'),
    
    // UTC+12:45
    Timezone(name: 'Chatham', offsetHours: 12, offsetMinutes: 45, displayName: 'Chatham Islands, New Zealand'),
    
    // UTC+13
    Timezone(name: 'Tonga', offsetHours: 13, displayName: 'Tonga'),
    Timezone(name: 'Samoa', offsetHours: 13, displayName: 'Samoa - Summer'),
    Timezone(name: 'Phoenix Islands', offsetHours: 13, displayName: 'Phoenix Islands, Kiribati'),
    
    // UTC+14
    Timezone(name: 'Line Islands', offsetHours: 14, displayName: 'Line Islands, Kiribati'),
  ];
}

enum CalendarViewType {
  day,
  week,
  multiDay,
  month,
}

class FormatSettings {
  DateStampFormat dateFormat;
  TimeStampFormat timeFormat;
  Timezone timezone;
  CalendarViewType viewType;

  FormatSettings({
    this.dateFormat = DateStampFormat.yy_mm_dd,
    this.timeFormat = TimeStampFormat.parse_24,
    Timezone? timezone,
    this.viewType = CalendarViewType.month,
  }) : timezone = timezone ?? TimezoneDatabase.allTimezones[14]; // Default to UTC (index 14)
}

class FormatSettingsController {
  static final ValueNotifier<FormatSettings> notifier =
      ValueNotifier<FormatSettings>(FormatSettings());

  static DateTime applyTimezone(DateTime dateTime) {
    final settings = notifier.value;
    final tz = settings.timezone;
    
    // Convert to UTC first
    final utcDateTime = dateTime.toUtc();
    
    // Apply the offset
    final offsetDuration = Duration(
      hours: tz.offsetHours,
      minutes: tz.offsetMinutes,
    );
    
    return utcDateTime.add(offsetDuration);
  }
}
