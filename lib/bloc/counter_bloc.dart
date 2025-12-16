import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hudle/bloc/counter_event.dart';

class CounterBloc extends Bloc<CounterEvent, int> {
  CounterBloc() : super(0) {
    on<CounterIncrease>((event, emit) => emit(state + 1));
    on<CounterDecrease>((event, emit) => emit(state - 1));
  }
}
