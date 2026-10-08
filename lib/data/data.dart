class Venta {
  const Venta({
    required this.numero,
    required this.fecha,
    required this.total,
  });

  final int numero;
  final String fecha;
  final double total;
}

class ProveedorEntrega {
  const ProveedorEntrega({
    required this.nombre,
    required this.fecha,
    required this.total,
  });

  final String nombre;
  final String fecha;
  final double total;
}

class Producto {
  const Producto({
    required this.nombre,
    required this.cantidad,
    this.porAgotarse = false,
  });

  final String nombre;
  final int cantidad;
  final bool porAgotarse;
}

const List<Venta> ventasDelDia = [
  Venta(numero: 6, fecha: '20/09/2026, 13:00 HRS', total: 1500.00),
  Venta(numero: 5, fecha: '20/09/2026, 12:00 HRS', total: 700.00),
  Venta(numero: 4, fecha: '20/09/2026, 11:40 HRS', total: 150.00),
  Venta(numero: 3, fecha: '20/09/2026, 11:35 HRS', total: 300.00),
  Venta(numero: 2, fecha: '20/09/2026, 11:00 HRS', total: 117.00),
  Venta(numero: 1, fecha: '20/09/2026, 10:50 HRS', total: 500.00),
];

const List<ProveedorEntrega> entregasDelDia = [
  ProveedorEntrega(
    nombre: 'BIMBO',
    fecha: '20/09/2026 - 10:00 HRS',
    total: 1500.00,
  ),
];

const List<Producto> productosInventario = [
  Producto(nombre: 'CIGARROS MARLBORO CLAVO', cantidad: 5, porAgotarse: true),
  Producto(nombre: 'AGUA PURIFICADA 1L', cantidad: 24),
  Producto(nombre: 'REFRESCO COCA COLA 600ML', cantidad: 18),
  Producto(nombre: 'GALLO FRIJOLES', cantidad: 12),
  Producto(nombre: 'GOMITAS SKWINKLES', cantidad: 30),
  Producto(nombre: 'PAN BLANCO GRANDE', cantidad: 8),
];

const List<String> proveedoresDisponibles = [
  'BIMBO',
  'CAMMEL',
  'MARLBORO',
  'PALL MALL',
];

const List<String> periodosReporte = [
  'ENERO',
  'FEBRERO',
  'MARZO',
  'ABRIL',
  'MAYO',
  'JUNIO',
  'JULIO',
  'AGOSTO',
  'SEPTIEMBRE',
  'OCTUBRE',
  'NOVIEMBRE',
  'DICIEMBRE',
];

String formatearMoneda(double valor) => '\$${valor.toStringAsFixed(2)}MXN';
