import 'dart:developer';

import 'package:bloc/bloc.dart';

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log('${bloc.runtimeType} error', error: error, stackTrace: stackTrace);
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onTransition(
    Bloc<dynamic, dynamic> bloc,
    Transition<dynamic, dynamic> transition,
  ) {
    // Blocs log the event that caused each change - the audit trail that is
    // one of the reasons to pick a Bloc over a Cubit (see AGENTS.md).
    log('${bloc.runtimeType} ${transition.event.runtimeType}');
    super.onTransition(bloc, transition);
  }
}
