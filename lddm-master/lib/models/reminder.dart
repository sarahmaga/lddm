class Reminder {
  late final String title;
  late final DateTime timeToRemind;
  late final bool isRecurrent;
  late final String note;

  Reminder({required this.timeToRemind, required this.isRecurrent, required this.note});
}