import 'dart:async';

import 'counter_event.dart';

class CounterBloc {
  int _counter = 0;


  final _counterStateController = StreamController<int>();

  StreamSink<int> get _inCounter => _counterStateController.sink;

// for state, exposing only a stream which output a value/data
  Stream<int> get counter => _counterStateController.stream;

  final _counterEventController = StreamController<CounterEvent>();

//for event , exposing only a sink which is an input
  Sink<CounterEvent> get counterEventSink => _counterEventController.sink;

  final _isNotValidController = StreamController<bool>();
  StreamSink<bool> get _inIsValid => _isNotValidController.sink;
  Stream<bool> get isNotValid => _isNotValidController.stream;

  CounterBloc() {
    _counterEventController.stream.listen(_mapEventToState);
  }

  void _mapEventToState(CounterEvent counterEvent) {
    if(counterEvent is IncrementEvent) {
      _counter++;
    }else{
      if(_counter==0) {
        _inIsValid.add(true);
        return;
      }

      _counter--;
    }
    _inIsValid.add(false);

    _inCounter.add(_counter);

  }

//  dispose function is important, to close our stream.., to avoid memory lib
 void dispose() {
   _counterStateController.close();
   _counterEventController.close();
   _isNotValidController.close();

 }

}