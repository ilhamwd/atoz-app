import 'dart:async';

import 'package:atoz/models/initial_data.dart';

class InitialDataState {
  final _initialData = StreamController<InitialData>.broadcast();

  Stream<InitialData> getStream() => _initialData.stream;
  StreamSink<InitialData> getSink() => _initialData.sink;

  dispose() => getSink().close();
}
