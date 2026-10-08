import 'package:flutter/material.dart';

import '../data/data.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';

class ProveedorFormScreen extends StatefulWidget {
  const ProveedorFormScreen({super.key});

  @override
  State<ProveedorFormScreen> createState() => _ProveedorFormScreenState();
}

class _ProveedorFormScreenState extends State<ProveedorFormScreen> {
  final _monto = TextEditingController(text: '1020.50');
  final _buscar = TextEditingController();
  String? _proveedorSeleccionado;
  final List<String> _proveedores = [...proveedoresDisponibles];

  @override
  void dispose() {
    _monto.dispose();
    _buscar.dispose();
    super.dispose();
  }

  void _agregarProveedor() {
    final nombre = _buscar.text.trim().toUpperCase();
    if (nombre.isEmpty) return;
    setState(() {
      if (!_proveedores.contains(nombre)) {
        _proveedores.add(nombre);
      }
      _proveedorSeleccionado = nombre;
      _buscar.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const ScreenHeader(title: 'PROVEEDORES'),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                children: [
                  const Text(
                    'DATOS DEL PROVEEDOR',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.4,
                      color: AppColors.navy,
                    ),
                  ),
                  const SizedBox(height: 18),
                  SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const SizedBox(
                              width: 90,
                              child: Text(
                                'Proveedor:',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.navy,
                                ),
                              ),
                            ),
                            Expanded(
                              child: TextField(
                                controller: _buscar,
                                textCapitalization:
                                    TextCapitalization.characters,
                                decoration: const InputDecoration(
                                  hintText: 'Buscar...',
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: _agregarProveedor,
                              icon: const Icon(
                                Icons.add_circle,
                                color: AppColors.blue,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        RadioGroup<String>(
                          groupValue: _proveedorSeleccionado,
                          onChanged: (valor) => setState(
                            () => _proveedorSeleccionado = valor,
                          ),
                          child: Column(
                            children: [
                              for (final proveedor in _proveedores)
                                RadioListTile<String>(
                                  value: proveedor,
                                  dense: true,
                                  contentPadding: EdgeInsets.zero,
                                  activeColor: AppColors.blue,
                                  title: Text(
                                    proveedor,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Productos a comprar:',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: AppColors.navy,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const SectionCard(
                    child: Text(
                      'Seleccione los productos del proveedor para agregarlos a la compra.',
                      style: TextStyle(color: AppColors.textMuted),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      const Text(
                        'Monto de la compra:',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: AppColors.navy,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _monto,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          textAlign: TextAlign.end,
                          decoration: const InputDecoration(hintText: '0.00'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    child: const Text('ACEPTAR'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
