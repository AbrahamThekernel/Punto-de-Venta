import 'package:flutter/material.dart';

import '../data/caja_store.dart';
import '../data/data.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';

class CorteCajaScreen extends StatefulWidget {
  const CorteCajaScreen({super.key});

  @override
  State<CorteCajaScreen> createState() => _CorteCajaScreenState();
}

class _CorteCajaScreenState extends State<CorteCajaScreen> {
  final _caja = CajaStore.instance;
  final _fondo = TextEditingController();
  final _contado = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fondo.text = _caja.fondoInicial.toStringAsFixed(2);
  }

  @override
  void dispose() {
    _fondo.dispose();
    _contado.dispose();
    super.dispose();
  }

  double? get _montoContado => double.tryParse(_contado.text);

  String _hora(DateTime f) =>
      '${f.hour.toString().padLeft(2, '0')}:${f.minute.toString().padLeft(2, '0')}';

  Future<void> _cerrar() async {
    final contado = _montoContado;
    if (contado == null) return;

    final diferencia = contado - _caja.efectivoEsperado;
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'CERRAR CORTE',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
            color: AppColors.navy,
          ),
        ),
        content: Text(
          'Total de ventas: ${formatearMoneda(_caja.totalVentas)}\n'
          'Efectivo esperado: ${formatearMoneda(_caja.efectivoEsperado)}\n'
          'Efectivo contado: ${formatearMoneda(contado)}\n'
          'Diferencia: ${formatearMoneda(diferencia.abs())}'
          '${diferencia == 0 ? '' : diferencia > 0 ? ' (sobrante)' : ' (faltante)'}\n\n'
          'Al cerrar, los pagos del turno se reinician en cero.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('CANCELAR'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('CERRAR CORTE'),
          ),
        ],
      ),
    );

    if (confirmar != true || !mounted) return;

    _caja.cerrarCorte(contado);
    _contado.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Corte de caja cerrado.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const ScreenHeader(title: 'CORTE DE CAJA'),
            Expanded(
              child: ListenableBuilder(
                listenable: _caja,
                builder: (context, _) => ListView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                  children: [
                    _buildResumen(),
                    const SizedBox(height: 18),
                    _buildDesglose(),
                    const SizedBox(height: 18),
                    _buildArqueo(),
                    const SizedBox(height: 18),
                    _buildMovimientos(),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _montoContado == null ? null : _cerrar,
                      child: const Text('CERRAR CORTE'),
                    ),
                    if (_caja.ultimoCorte != null) ...[
                      const SizedBox(height: 16),
                      _buildUltimoCorte(_caja.ultimoCorte!),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResumen() {
    return SectionCard(
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Pagos registrados desde las ${_hora(_caja.apertura)}:',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.navy,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.coral,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '[${_caja.numPagos}]',
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                color: AppColors.navy,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesglose() {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'VENTAS POR MEDIO DE PAGO',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
              color: AppColors.navy,
            ),
          ),
          const SizedBox(height: 12),
          for (final medio in MedioPago.values)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  Icon(medio.icon, color: AppColors.blue, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '${medio.label} (${_caja.conteoPorMedio(medio)})',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.navy,
                      ),
                    ),
                  ),
                  Text(
                    formatearMoneda(_caja.totalPorMedio(medio)),
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: AppColors.navy,
                    ),
                  ),
                ],
              ),
            ),
          const Divider(height: 24),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'TOTAL DE VENTAS',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                    color: AppColors.navy,
                  ),
                ),
              ),
              Text(
                formatearMoneda(_caja.totalVentas),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: AppColors.blue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildArqueo() {
    final esperado = _caja.efectivoEsperado;
    final contado = _montoContado;
    final diferencia = contado == null ? null : contado - esperado;

    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ARQUEO DE EFECTIVO',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
              color: AppColors.navy,
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _fondo,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (valor) =>
                _caja.definirFondo(double.tryParse(valor) ?? 0),
            decoration: const InputDecoration(
              labelText: 'Fondo inicial de caja',
              prefixText: '\$ ',
            ),
          ),
          const SizedBox(height: 14),
          _FilaDato(
            etiqueta: 'Efectivo cobrado',
            valor: formatearMoneda(_caja.totalPorMedio(MedioPago.efectivo)),
          ),
          _FilaDato(
            etiqueta: 'Efectivo esperado en cajón',
            valor: formatearMoneda(esperado),
            destacado: true,
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _contado,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (_) => setState(() {}),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.navy,
            ),
            decoration: const InputDecoration(
              labelText: 'Efectivo contado',
              prefixText: '\$ ',
              hintText: '0.00',
            ),
          ),
          if (diferencia != null) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              decoration: BoxDecoration(
                color: diferencia == 0
                    ? AppColors.blue.withValues(alpha: 0.1)
                    : AppColors.coral,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    diferencia == 0
                        ? 'CAJA CUADRADA'
                        : diferencia > 0
                            ? 'SOBRANTE'
                            : 'FALTANTE',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                      color: diferencia == 0 ? AppColors.blue : AppColors.navy,
                    ),
                  ),
                  Text(
                    formatearMoneda(diferencia.abs()),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: diferencia == 0 ? AppColors.blue : AppColors.navy,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMovimientos() {
    final recientes = _caja.pagos.reversed.take(8).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Últimos movimientos',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: AppColors.navy,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 12),
        if (recientes.isEmpty)
          const SectionCard(
            child: Text(
              'Aún no hay pagos registrados en este turno.',
              style: TextStyle(color: AppColors.textMuted),
            ),
          )
        else
          for (final pago in recientes)
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Icon(pago.medio.icon, color: AppColors.blue, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '#${pago.folio} · ${_hora(pago.fecha)} · ${pago.medio.label}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                      ),
                    ),
                  ),
                  Text(
                    formatearMoneda(pago.total),
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: AppColors.blue,
                    ),
                  ),
                ],
              ),
            ),
      ],
    );
  }

  Widget _buildUltimoCorte(CorteCerrado corte) {
    final dif = corte.diferencia;
    final estado = dif == 0
        ? 'cuadrado'
        : dif > 0
            ? 'sobrante ${formatearMoneda(dif)}'
            : 'faltante ${formatearMoneda(dif.abs())}';

    return Text(
      'Último corte: ${_hora(corte.cierre)} · '
      '${formatearMoneda(corte.totalVentas)} en ventas · $estado',
      textAlign: TextAlign.center,
      style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
    );
  }
}

class _FilaDato extends StatelessWidget {
  const _FilaDato({
    required this.etiqueta,
    required this.valor,
    this.destacado = false,
  });

  final String etiqueta;
  final String valor;
  final bool destacado;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            etiqueta,
            style: TextStyle(
              fontWeight: destacado ? FontWeight.w800 : FontWeight.w600,
              color: destacado ? AppColors.navy : AppColors.textMuted,
            ),
          ),
          Text(
            valor,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: destacado ? 17 : 14,
              color: destacado ? AppColors.blue : AppColors.navy,
            ),
          ),
        ],
      ),
    );
  }
}
