import 'package:algolia/algolia.dart';

class AlgoliaApplication{
  static final Algolia algolia = Algolia.init(
    applicationId: 'YOUR KEY', //ApplicationID
    apiKey: 'YOUR KEY', //search-only api key in flutter code
  );
}