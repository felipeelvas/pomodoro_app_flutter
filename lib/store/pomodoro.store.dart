import 'dart:async';

import 'package:mobx/mobx.dart';

part 'pomodoro.store.g.dart';

class PomodoroStore = _PomodoroStore with _$PomodoroStore;

enum TipoIntervalo { estudo, descanso }

abstract class _PomodoroStore with Store {
  @observable
  bool iniciado = false;

  @observable
  int minutos = 25;

  @observable
  int segundos = 0;

  @observable
  int tempoEstudo = 25;

  @observable
  int tempoDescanso = 5;

  @observable
  TipoIntervalo tipoIntervalo = TipoIntervalo.estudo;

  Timer? cronometro;

  @action
  void iniciar() {
    iniciado = true;
    cronometro = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (minutos == 0 && segundos == 0) {
        _trocarTipoIntervalo();
      } else if (segundos == 0) {
        segundos = 59;
        minutos--;
      } else {
        segundos--;
      }
    });
  }

  @action
  void parar() {
    iniciado = false;
    cronometro?.cancel();
  }

  @action
  void reiniciar() {
    parar();
    minutos = estaEstudando() ? tempoEstudo : tempoDescanso;
    segundos = 0;
  }

  @action
  void incrementarTempoEstudo() {
    tempoEstudo++;
    if (estaEstudando()) {
      reiniciar();
    }
  }

  @action
  void decrementarTempoEstudo() {
    tempoEstudo--;
    if (estaEstudando()) {
      reiniciar();
    }
  }

  @action
  void incrementarTempoDescanso() {
    tempoDescanso++;
    if (estaDescansando()) {
      reiniciar();
    }
  }

  @action
  void decrementarTempoDescanso() {
    tempoDescanso--;
    if (estaDescansando()) {
      reiniciar();
    }
  }

  bool estaEstudando() {
    return tipoIntervalo == TipoIntervalo.estudo;
  }

  bool estaDescansando() {
    return tipoIntervalo == TipoIntervalo.descanso;
  }

  void _trocarTipoIntervalo() {
    if (estaEstudando()) {
      tipoIntervalo = TipoIntervalo.descanso;
      minutos = tempoDescanso;
    } else {
      tipoIntervalo = TipoIntervalo.estudo;
      minutos = tempoEstudo;
    }
    segundos = 0;
  }
}
