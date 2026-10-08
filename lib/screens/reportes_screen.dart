import 'package:flutter/material.dart';

import '../data/data.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';

class ReportesScreen extends StatefulWidget {
  const ReportesScreen({super.key});

  @override
  State<ReportesScreen> createState() => _ReportesScreenState();
}

class _ReportesScreenState extends State<ReportesScreen> {
  String? _periodo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const ScreenHeader(title: 'REPORTES'),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
                children: [
                  const Text(
                    'REPORTES LISTOS PARA IMPRIMIR',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                      color: AppColors.blue,
                    ),
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    '¿CUÁL ES EL PERIODO DE REPORTES QUE NECESITA?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1,
                      color: AppColors.navy,
                    ),
                  ),
                  const SizedBox(height: 28),
                  SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'SELECCIONE EL PERIODO',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                            color: AppColors.navy,
                          ),
                        ),
                        const SizedBox(height: 14),
                        DropdownButtonFormField<String>(
                          initialValue: _periodo,
                          isExpanded: true,
                          hint: const Text('Seleccione...'),
                          items: [
                            for (final periodo in periodosReporte)
                              DropdownMenuItem(
                                value: periodo,
                                child: Text(periodo),
                              ),
                          ],
                          onChanged: (valor) =>
                              setState(() => _periodo = valor),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _periodo == null
                        ? null
                        : () => ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Generando reporte de $_periodo...',
                                ),
                              ),
                            ),
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
