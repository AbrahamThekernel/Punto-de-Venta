import 'package:flutter_test/flutter_test.dart';

import 'package:punto_de_venta/main.dart';

void main() {
  testWidgets('La pantalla de inicio de sesión se muestra', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const PuntoDeVentaApp());

    expect(find.text('INICIO DE SESIÓN'), findsOneWidget);
    expect(find.text('ENTRAR'), findsOneWidget);
    expect(find.text('SALIR'), findsOneWidget);
  });
}
