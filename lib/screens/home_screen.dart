import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'corte_caja_screen.dart';
import 'inventario_screen.dart';
import 'pagos_screen.dart';
import 'proveedores_screen.dart';
import 'reportes_screen.dart';
import 'ventas_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = <_MenuOption>[
      _MenuOption(
        label: 'INVENTARIO',
        icon: Icons.inventory_2_outlined,
        builder: (_) => const InventarioScreen(),
      ),
      _MenuOption(
        label: 'VENTAS',
        icon: Icons.point_of_sale_outlined,
        builder: (_) => const VentasScreen(),
      ),
      _MenuOption(
        label: 'CORTE DE\nCAJA',
        icon: Icons.calculate_outlined,
        builder: (_) => const CorteCajaScreen(),
      ),
      _MenuOption(
        label: 'PROVEEDORES',
        icon: Icons.local_shipping_outlined,
        builder: (_) => const ProveedoresScreen(),
      ),
      _MenuOption(
        label: 'REPORTES',
        icon: Icons.bar_chart_outlined,
        builder: (_) => const ReportesScreen(),
      ),
      _MenuOption(
        label: 'PAGOS',
        icon: Icons.payments_outlined,
        builder: (_) => const PagosScreen(),
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '¡HOLA!!!',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                      color: AppColors.navy,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(Icons.logout, color: AppColors.blue),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              const Text(
                '¿QUÉ DESEA REALIZAR HOY?',
                style: TextStyle(
                  fontSize: 14,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 26),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.05,
                  children: [
                    for (final item in items) _MenuCard(item: item),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuOption {
  const _MenuOption({
    required this.label,
    required this.icon,
    required this.builder,
  });

  final String label;
  final IconData icon;
  final WidgetBuilder builder;
}

class _MenuCard extends StatelessWidget {
  const _MenuCard({required this.item});

  final _MenuOption item;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(20),
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: item.builder),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.navy.withValues(alpha: 0.07),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.blue.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(item.icon, size: 30, color: AppColors.blue),
              ),
              const SizedBox(height: 14),
              Text(
                item.label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
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
