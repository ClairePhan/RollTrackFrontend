import 'dart:html';

class Class {
  final String name;
  final String instructor;
  final String time;
  final String location;
  
  Class(this.name, this.instructor, this.time, this.location);
}

void main() {
  // Martial arts classes data
  final classes = [
    Class('Karate', 'Sensei Martinez', 'Mon/Wed 6:00 PM', 'Dojo A'),
    Class('Brazilian Jiu-Jitsu', 'Professor Silva', 'Tue/Thu 7:00 PM', 'Dojo B'),
    Class('Taekwondo', 'Master Kim', 'Mon/Wed/Fri 5:00 PM', 'Dojo C'),
    Class('Muay Thai', 'Kru Johnson', 'Tue/Thu 6:30 PM', 'Dojo A'),
    Class('Judo', 'Sensei Tanaka', 'Sat 10:00 AM', 'Dojo B'),
    Class('Boxing', 'Coach Williams', 'Mon/Wed/Fri 7:00 PM', 'Training Room'),
  ];
  
  final output = querySelector('#output') as DivElement;
  output.className = 'classes-page';
  
  final classesHtml = classes.map((cls) => '''
    <div class="class-card">
      <h3 class="class-name">${cls.name}</h3>
      <div class="class-details">
        <p class="class-instructor"><strong>Instructor:</strong> ${cls.instructor}</p>
        <p class="class-time"><strong>Time:</strong> ${cls.time}</p>
        <p class="class-location"><strong>Location:</strong> ${cls.location}</p>
      </div>
    </div>
  ''').join('');
  
  output.setInnerHtml('''
    <div class="classes-container">
      <h1 class="page-title">Classes</h1>
      <div class="classes-list">
        $classesHtml
      </div>
    </div>
  ''');
}

