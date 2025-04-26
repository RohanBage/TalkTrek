class ScheduleItemModel {
  final String id;
  final String title;
  final String dayOfWeek;
  final String time;
  final int duration;

  ScheduleItemModel({
    required this.id,
    required this.title,
    required this.dayOfWeek,
    required this.time,
    required this.duration,
  });
}
