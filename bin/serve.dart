import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_static/shelf_static.dart';

void main(List<String> args) async {
  final port = args.isNotEmpty 
      ? (int.tryParse(args[0]) ?? 8080)
      : 8080;
  final webDir = Directory('web');
  
  if (!webDir.existsSync()) {
    print('Error: web directory not found!');
    exit(1);
  }

  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addHandler(createStaticHandler(webDir.path, defaultDocument: 'index.html'));

  final server = await shelf_io.serve(handler, InternetAddress.anyIPv4, port);
  
  print('Serving at http://${server.address.host}:${server.port}');
  print('Press Ctrl+C to stop the server');
}

