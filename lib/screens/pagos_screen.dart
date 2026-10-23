import 'package:flutter/material.dart';

import '../data/caja_store.dart';
import '../data/data.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';

class PagosScreen extends StatefulWidget {
  /// Total a cobrar. Por ahora es un valor de ejemplo; cuando conectes
  /// la pantalla de ventas, pásalo desde ahí: PagosScreen(total: venta.total).
  const PagosScreen({super.key, this.total = 485.50});

  final double total;

  @override
  State<PagosScreen> createState() => _PagosScreenState();
}

class _PagosScreenState extends State<PagosScreen> {
  final _recibido = TextEditingController();
  final _referencia = TextEditingController();

  MedioPago? _medio;
  bool _esCredito = false;
  bool _pagado = false;
  bool _procesando = false;

  @override
  void dispose() {
    _recibido.dispose();
    _referencia.dispose();
    super.dispose();
  }

  double get _montoRecibido => double.tryParse(_recibido.text) ?? 0;

  double get _cambio {
    final diferencia = _montoRecibido - widget.total;
    return diferencia > 0 ? diferencia : 0;
  }

  bool get _puedeCobrar {
    if (_procesando) return false;
    switch (_medio) {
      case null:
        return false;
      case MedioPago.efectivo:
        return _montoRecibido >= widget.total;
      case MedioPago.transferencia:
        return _referencia.text.trim().length >= 4;
      case MedioPago.tarjeta:
      case MedioPago.cartera:
        return true;
    }
  }

  void _seleccionar(MedioPago medio) {
    setState(() {
      _medio = medio;
      _recibido.clear();
      _referencia.clear();
      _esCredito = false;
    });
  }

  void _fijarRecibido(double valor) {
    setState(() => _recibido.text = valor.toStringAsFixed(2));
  }

  Future<void> _cobrar() async {
    setState(() => _procesando = true);
    // Aquí iría la llamada real a la terminal / servicio de pagos
    // y el guardado de la venta.
    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;

    final referencia = _referencia.text.trim();
    CajaStore.instance.registrarPago(
      medio: _medio!,
      total: widget.total,
      recibido: _medio == MedioPago.efectivo ? _montoRecibido : null,
      referencia: referencia.isEmpty ? null : referencia,
      esCredito: _medio == MedioPago.tarjeta && _esCredito,
    );

    setState(() {
      _procesando = false;
      _pagado = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const ScreenHeader(title: 'MENÚ DE PAGOS'),
            Expanded(child: _pagado ? _buildExito() : _buildCobro()),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Cobro
  // ---------------------------------------------------------------------------

  Widget _buildCobro() {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            children: [
              _TotalCard(total: widget.total),
              const SizedBox(height: 22),
              const Text(
                'ESCOJA EL MEDIO DE PAGO',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                  color: AppColors.navy,
                ),
              ),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.7,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  for (final medio in MedioPago.values)
                    _MedioPagoCard(
                      medio: medio,
                      seleccionado: _medio == medio,
                      onTap: () => _seleccionar(medio),
                    ),
                ],
              ),
              const SizedBox(height: 22),
              if (_medio != null) _buildDetalle(_medio!),
            ],
          ),
        ),
        _buildBarraCobrar(),
      ],
    );
  }

  Widget _buildDetalle(MedioPago medio) {
    switch (medio) {
      case MedioPago.efectivo:
        return _buildEfectivo();
      case MedioPago.tarjeta:
        return _buildTarjeta();
      case MedioPago.cartera:
        return _buildReferencia(
          titulo: 'PAGO CON CARTERA DIGITAL',
          ayuda: 'Pida al cliente que escanee el QR o muestre su comprobante. '
              'La referencia es opcional.',
          etiqueta: 'Referencia (opcional)',
        );
      case MedioPago.transferencia:
        return _buildReferencia(
          titulo: 'PAGO POR TRANSFERENCIA',
          ayuda: 'Capture la clave de rastreo o referencia del comprobante.',
          etiqueta: 'Clave de rastreo / referencia',
        );
    }
  }

  Widget _buildEfectivo() {
    final recibido = _montoRecibido;
    final falta = widget.total - recibido;

    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'PAGO CON EFECTIVO',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
              color: AppColors.navy,
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _recibido,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (_) => setState(() {}),
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.navy,
            ),
            decoration: const InputDecoration(
              labelText: 'Monto recibido',
              prefixText: '\$ ',
              hintText: '0.00',
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _ChipMonto(
                label: 'EXACTO',
                onTap: () => _fijarRecibido(widget.total),
              ),
              for (final billete in const [50.0, 100.0, 200.0, 500.0])
                _ChipMonto(
                  label: '\$${billete.toStringAsFixed(0)}',
                  onTap: () => _fijarRecibido(billete),
                ),
            ],
          ),
          const SizedBox(height: 18),
          if (recibido > 0 && falta > 0)
            _FilaResultado(
              etiqueta: 'FALTAN',
              valor: formatearMoneda(falta),
              color: AppColors.textMuted,
              fondo: AppColors.border.withValues(alpha: 0.5),
            )
          else if (recibido >= widget.total)
            _FilaResultado(
              etiqueta: 'CAMBIO',
              valor: formatearMoneda(_cambio),
              color: AppColors.navy,
              fondo: AppColors.coral,
            ),
        ],
      ),
    );
  }

  Widget _buildTarjeta() {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'PAGO CON TARJETA',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
              color: AppColors.navy,
            ),
          ),
          const SizedBox(height: 14),
          SegmentedButton<bool>(
            segments: const [
              ButtonSegment(value: false, label: Text('DÉBITO')),
              ButtonSegment(value: true, label: Text('CRÉDITO')),
            ],
            selected: {_esCredito},
            showSelectedIcon: false,
            onSelectionChanged: (valor) =>
                setState(() => _esCredito = valor.first),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _referencia,
            keyboardType: TextInputType.number,
            maxLength: 6,
            decoration: const InputDecoration(
              labelText: 'Autorización / últimos 4 dígitos (opcional)',
              counterText: '',
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Cobre en la terminal y confirme aquí cuando sea aprobado. '
            'Nunca capture el número completo de la tarjeta.',
            style: TextStyle(color: AppColors.textMuted, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildReferencia({
    required String titulo,
    required String ayuda,
    required String etiqueta,
  }) {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
              color: AppColors.navy,
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _referencia,
            onChanged: (_) => setState(() {}),
            textCapitalization: TextCapitalization.characters,
            decoration: InputDecoration(labelText: etiqueta),
          ),
          const SizedBox(height: 10),
          Text(
            ayuda,
            style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildBarraCobrar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.navy.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed:
                  _procesando ? null : () => Navigator.of(context).maybePop(),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.navy,
                side: const BorderSide(color: AppColors.navy),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'CANCELAR',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _puedeCobrar ? _cobrar : null,
              child: _procesando
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.4,
                        color: Colors.white,
                      ),
                    )
                  : Text('COBRAR ${formatearMoneda(widget.total)}'),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Éxito
  // ---------------------------------------------------------------------------

  Widget _buildExito() {
    final medio = _medio!;
    final esEfectivo = medio == MedioPago.efectivo;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
      child: Column(
        children: [
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: AppColors.blue.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_rounded,
              size: 56,
              color: AppColors.blue,
            ),
          ),
          const SizedBox(height: 22),
          const Text(
            'PAGO REGISTRADO',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.4,
              color: AppColors.navy,
            ),
          ),
          const SizedBox(height: 22),
          SectionCard(
            child: Column(
              children: [
                _FilaResumen(etiqueta: 'Medio', valor: medio.label),
                _FilaResumen(
                  etiqueta: 'Total',
                  valor: formatearMoneda(widget.total),
                ),
                if (esEfectivo) ...[
                  _FilaResumen(
                    etiqueta: 'Recibido',
                    valor: formatearMoneda(_montoRecibido),
                  ),
                  _FilaResumen(
                    etiqueta: 'Cambio',
                    valor: formatearMoneda(_cambio),
                    destacado: true,
                  ),
                ],
              ],
            ),
          ),
          const Spacer(),
          OutlinedButton.icon(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Imprimiendo ticket...')),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.blue,
              side: const BorderSide(color: AppColors.blue),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            icon: const Icon(Icons.print_outlined),
            label: const Text(
              'IMPRIMIR TICKET',
              style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: 1.2),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).maybePop(),
              child: const Text('NUEVA VENTA'),
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Widgets de apoyo
// -----------------------------------------------------------------------------

class _TotalCard extends StatelessWidget {
  const _TotalCard({required this.total});

  final double total;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 24),
      decoration: BoxDecoration(
        color: AppColors.navy,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.navy.withValues(alpha: 0.18),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'TOTAL A COBRAR',
            style: TextStyle(
              color: AppColors.blueLight,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.6,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            formatearMoneda(total),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 38,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _MedioPagoCard extends StatelessWidget {
  const _MedioPagoCard({
    required this.medio,
    required this.seleccionado,
    required this.onTap,
  });

  final MedioPago medio;
  final bool seleccionado;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: seleccionado
          ? AppColors.blue.withValues(alpha: 0.1)
          : AppColors.surface,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: seleccionado ? AppColors.blue : AppColors.border,
              width: seleccionado ? 1.8 : 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(medio.icon, color: AppColors.blue, size: 26),
              const SizedBox(height: 6),
              Text(
                medio.label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                  color: AppColors.navy,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChipMonto extends StatelessWidget {
  const _ChipMonto({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.blue,
        side: const BorderSide(color: AppColors.blue),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
      ),
    );
  }
}

class _FilaResultado extends StatelessWidget {
  const _FilaResultado({
    required this.etiqueta,
    required this.valor,
    required this.color,
    required this.fondo,
  });

  final String etiqueta;
  final String valor;
  final Color color;
  final Color fondo;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: fondo,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            etiqueta,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
              color: color,
            ),
          ),
          Text(
            valor,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _FilaResumen extends StatelessWidget {
  const _FilaResumen({
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
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            etiqueta,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.textMuted,
            ),
          ),
          Text(
            valor,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: destacado ? 18 : 14,
              color: destacado ? AppColors.blue : AppColors.navy,
            ),
          ),
        ],
      ),
    );
  }
}
