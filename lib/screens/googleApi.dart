
import 'package:google_vision/google_vision.dart' ;
import 'package:google_vision/src/model/image.dart' as img;

Future<String> googleApi(String path) async
{
  String parsed="";
  final googleVision =
      await GoogleVision.withJwt("assests/auth.json");

  final painter = Painter.fromFilePath(path);

  final requests = AnnotationRequests(requests: [
    AnnotationRequest(image: img.Image(painter: painter), features: [
      Feature(maxResults: 10, type: 'TEXT_DETECTION')
    ])
  ]);

  print('checking...');

  AnnotatedResponses annotatedResponses =
      await googleVision.annotate(requests: requests);

  print('done.\n');

  for (var annotatedResponse in annotatedResponses.responses) {
    for (var textAnnotation in annotatedResponse.textAnnotations) {
      parsed+=textAnnotation.description+" ";
      GoogleVision.drawText(
          painter,
          textAnnotation.boundingPoly!.vertices.first.x + 2,
          textAnnotation.boundingPoly!.vertices.first.y + 2,
          textAnnotation.description);

      GoogleVision.drawAnnotations(
          painter, textAnnotation.boundingPoly!.vertices);
    }
  }

  await painter.writeAsJpeg('assests/debugImage.jpg');
  return parsed;
}
