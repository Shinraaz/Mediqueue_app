enum AppointmentStatus { upcoming, completed, cancelled }

class Doctor {
  final String id, name, specialty, emoji, hospital, about;
  final double rating;
  final int reviewCount;
  final List<String> availableDays, availableTimes;
  const Doctor({required this.id, required this.name, required this.specialty,
    required this.emoji, required this.rating, required this.reviewCount,
    required this.hospital, required this.availableDays,
    required this.availableTimes, required this.about});
}

class Appointment {
  final String id, time, patientName;
  final Doctor doctor;
  final DateTime date;
  final AppointmentStatus status;
  final String? notes;
  Appointment({required this.id, required this.doctor, required this.date,
    required this.time, required this.status, this.notes, required this.patientName});
  Appointment copyWith({AppointmentStatus? status, DateTime? date, String? time}) =>
    Appointment(id: id, doctor: doctor, date: date ?? this.date,
      time: time ?? this.time, status: status ?? this.status,
      notes: notes, patientName: patientName);
}

// Seed doctors
final List<Doctor> seedDoctors = [
  const Doctor(id:'d1', name:'Dr. Maria Reyes', specialty:'General Medicine', emoji:'🩺',
    rating:4.9, reviewCount:312, hospital:'Cebu City Medical Center',
    availableDays:['Mon','Tue','Wed','Fri'],
    availableTimes:['08:00 AM','09:00 AM','10:00 AM','11:00 AM','02:00 PM','03:00 PM'],
    about:'Preventive care and chronic disease management with 15+ years of experience.'),
  const Doctor(id:'d2', name:'Dr. Carlos Flores', specialty:'Cardiology', emoji:'❤️',
    rating:4.8, reviewCount:198, hospital:'Chong Hua Hospital',
    availableDays:['Mon','Wed','Thu'],
    availableTimes:['09:00 AM','10:00 AM','01:00 PM','02:00 PM','04:00 PM'],
    about:'Board-certified cardiologist focusing on heart disease prevention.'),
  const Doctor(id:'d3', name:'Dr. Ana Santos', specialty:'Pediatrics', emoji:'👶',
    rating:4.9, reviewCount:445, hospital:'Cebu City Medical Center',
    availableDays:['Tue','Wed','Thu','Fri'],
    availableTimes:['08:00 AM','09:00 AM','10:00 AM','11:00 AM','03:00 PM'],
    about:'Dedicated pediatrician with a gentle approach to child health care.'),
  const Doctor(id:'d4', name:'Dr. Jose Cruz', specialty:'Orthopedics', emoji:'🦴',
    rating:4.7, reviewCount:134, hospital:'Perpetual Succour Hospital',
    availableDays:['Mon','Tue','Fri'],
    availableTimes:['10:00 AM','11:00 AM','02:00 PM','03:00 PM','04:00 PM'],
    about:'Orthopedic surgeon specializing in sports injuries and joint replacement.'),
  const Doctor(id:'d5', name:'Dr. Lena Garcia', specialty:'Dermatology', emoji:'🔬',
    rating:4.8, reviewCount:267, hospital:'Chong Hua Hospital',
    availableDays:['Tue','Thu','Fri'],
    availableTimes:['09:00 AM','10:00 AM','11:00 AM','01:00 PM','02:00 PM'],
    about:'Dermatologist experienced in medical and cosmetic skin conditions.'),
  const Doctor(id:'d6', name:'Dr. Ramon Lim', specialty:'Ophthalmology', emoji:'👁️',
    rating:4.9, reviewCount:189, hospital:'Perpetual Succour Hospital',
    availableDays:['Mon','Wed','Fri'],
    availableTimes:['08:00 AM','09:00 AM','10:00 AM','02:00 PM','03:00 PM'],
    about:'Eye specialist with expertise in cataract surgery and glaucoma management.'),
];
