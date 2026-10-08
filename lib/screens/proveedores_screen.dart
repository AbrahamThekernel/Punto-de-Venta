import 'package:flutter/material.dart';

import '../data/data.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import 'proveedor_form_screen.dart';

class ProveedoresScreen extends StatelessWidget {
  const ProveedoresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.blue,
        foregroundColor: Colors.white,
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const ProveedorFormScreen()),
        ),
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const ScreenHeader(title: 'MENÚ DE PROVEEDORES'),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 96),
                children: [
                  SectionCard(
                    child: Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Cantidad de proveedores asistidos este día:',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppColors.navy,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.coral,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '[${entregasDelDia.length}]',
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              color: AppColors.navy,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  for (final entrega in entregasDelDia) ...[
                    SectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${entrega.nombre} - ${entrega.fecha}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              color: AppColors.navy,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Productos recibidos: .................................',
                            style: TextStyle(color: AppColors.textMuted),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Total del surtido: ${formatearMoneda(entrega.total)}',
                            style: const TextStyle(
                              color: AppColors.blue,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
