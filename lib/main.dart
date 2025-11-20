import 'dart:html';

void main() {
  final output = querySelector('#output') as DivElement;
  
  output.setInnerHtml('''
    <h1>Welcome to RollTrack</h1>
    <p>Your Dart frontend is ready to go!</p>
    <p>Edit <code>lib/main.dart</code> to start building your application.</p>
  ''');
  
  // Example: Add a button
  final button = ButtonElement()
    ..text = 'Click me!'
    ..style.cssText = '''
      padding: 10px 20px;
      background: #667eea;
      color: white;
      border: none;
      border-radius: 6px;
      cursor: pointer;
      font-size: 16px;
      margin-top: 1rem;
    '''
    ..onClick.listen((_) {
      window.alert('Hello from Dart!');
    });
  
  output.children.add(button);
}

