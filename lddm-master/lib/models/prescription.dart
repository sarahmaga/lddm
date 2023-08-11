class Prescription {

  late final String medicine;
  late final String dosage;
  late final DateTime timeToTake;
  late final String note;

  Prescription({
    required this.medicine,
    required this.dosage,
    required this.timeToTake,
    required this.note
  });
}