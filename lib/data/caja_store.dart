import 'package:flutter/material.dart';

enum MedioPago { efectivo, tarjeta, cartera, transferencia }

extension MedioPagoInfo on MedioPago {
  String get label => switch (this) {
        MedioPago.efectivo => 'EFECTIVO',
        MedioPago.tarjeta => 'TARJETA',
        MedioPago.cartera => 'CARTERA DIGITAL',
        MedioPago.transferencia => 'TRANSFERENCIA',
      };

  IconData get icon => switch (this) {
        MedioPago.efectivo => Icons.payments_outlined,
        MedioPago.tarjeta => Icons.credit_card,
        MedioPago.cartera => Icons.account_balance_wallet_outlined,
        MedioPago.transferencia => Icons.swap_horiz,
      };
}

/// Un cobro ya confirmado.
class PagoRegistrado {
  const PagoRegistrado({
    required this.folio,
    required this.fecha,
    required this.medio,
    required this.total,
    this.recibido,
    this.referencia,
    this.esCredito = false,
  });

  final int folio;
  final DateTime fecha;
  final MedioPago medio;

  /// Lo que se cobró (lo que realmente entra a caja).
  final double total;

  /// Solo efectivo: lo que entregó el cliente.
  final double? recibido;
  final String? referencia;
  final bool esCredito;

  double get cambio {
    final r = recibido;
    if (r == null) return 0;
    return r > total ? r - total : 0;
  }
}

/// Resultado de un corte ya cerrado.
class CorteCerrado {
  const CorteCerrado({
    required this.apertura,
    required this.cierre,
    required this.fondoInicial,
    required this.totalesPorMedio,
    required this.numPagos,
    required this.efectivoEsperado,
    required this.efectivoContado,
  });

  final DateTime apertura;
  final DateTime cierre;
  final double fondoInicial;
  final Map<MedioPago, double> totalesPorMedio;
  final int numPagos;
  final double efectivoEsperado;
  final double efectivoContado;

  double get totalVentas =>
      totalesPorMedio.values.fold(0.0, (suma, v) => suma + v);

  /// Positivo = sobrante, negativo = faltante.
  double get diferencia => efectivoContado - efectivoEsperado;
}

/// Estado de la caja en memoria, compartido entre Pagos y Corte de caja.
///
/// Es un singleton simple: se pierde al cerrar la app. Cuando agregues
/// base de datos (SQLite/Drift/Isar), solo hay que persistir `_pagos`
/// y `_cortes` aquí; las pantallas no cambian.
class CajaStore extends ChangeNotifier {
  CajaStore._();

  static final CajaStore instance = CajaStore._();

  double _fondoInicial = 500;
  DateTime _apertura = DateTime.now();
  int _folio = 0;
  final List<PagoRegistrado> _pagos = [];
  final List<CorteCerrado> _cortes = [];

  double get fondoInicial => _fondoInicial;
  DateTime get apertura => _apertura;
  List<PagoRegistrado> get pagos => List.unmodifiable(_pagos);
  CorteCerrado? get ultimoCorte => _cortes.isEmpty ? null : _cortes.last;

  int get numPagos => _pagos.length;

  double totalPorMedio(MedioPago medio) => _pagos
      .where((p) => p.medio == medio)
      .fold(0.0, (suma, p) => suma + p.total);

  int conteoPorMedio(MedioPago medio) =>
      _pagos.where((p) => p.medio == medio).length;

  double get totalVentas => _pagos.fold(0.0, (suma, p) => suma + p.total);

  /// Efectivo que debería haber físicamente en el cajón.
  double get efectivoEsperado =>
      _fondoInicial + totalPorMedio(MedioPago.efectivo);

  void definirFondo(double valor) {
    _fondoInicial = valor < 0 ? 0 : valor;
    notifyListeners();
  }

  PagoRegistrado registrarPago({
    required MedioPago medio,
    required double total,
    double? recibido,
    String? referencia,
    bool esCredito = false,
  }) {
    final pago = PagoRegistrado(
      folio: ++_folio,
      fecha: DateTime.now(),
      medio: medio,
      total: total,
      recibido: recibido,
      referencia: referencia,
      esCredito: esCredito,
    );
    _pagos.add(pago);
    notifyListeners();
    return pago;
  }

  CorteCerrado cerrarCorte(double efectivoContado) {
    final ahora = DateTime.now();
    final corte = CorteCerrado(
      apertura: _apertura,
      cierre: ahora,
      fondoInicial: _fondoInicial,
      totalesPorMedio: {
        for (final medio in MedioPago.values) medio: totalPorMedio(medio),
      },
      numPagos: _pagos.length,
      efectivoEsperado: efectivoEsperado,
      efectivoContado: efectivoContado,
    );
    _cortes.add(corte);
    _pagos.clear();
    _apertura = ahora;
    notifyListeners();
    return corte;
  }
}
