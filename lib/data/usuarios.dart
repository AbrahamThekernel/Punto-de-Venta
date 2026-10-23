/// Roles disponibles para iniciar sesión en el sistema.
enum Rol {
  administrador,
  superusuario,
  usuario,
}

/// Secciones (opciones) del programa que pueden ser restringidas por rol.
enum Permiso {
  inventario,
  ventas,
  corteCaja,
  proveedores,
  reportes,
  pagos,
}

class Usuario {
  const Usuario({
    required this.usuario,
    required this.contrasena,
    required this.rol,
  });

  final String usuario;
  final String contrasena;
  final Rol rol;

  String get etiquetaRol => switch (rol) {
        Rol.administrador => 'ADMINISTRADOR',
        Rol.superusuario => 'SUPERUSUARIO',
        Rol.usuario => 'USUARIO',
      };

  bool get esAdministrador => rol == Rol.administrador;
  bool get esSuperusuario => rol == Rol.superusuario;
  bool get esUsuarioNormal => rol == Rol.usuario;

  /// Determina si el usuario puede acceder a una sección del programa.
  ///
  /// - Superusuario: todas las funciones del programa.
  /// - Administrador: todas las opciones excepto la creación de reportes.
  /// - Usuario normal: solo los pagos y el corte de caja.
  bool puedeAcceder(Permiso permiso) {
    if (esSuperusuario) {
      return true;
    }
    if (esAdministrador) {
      return permiso != Permiso.reportes;
    }
    return permiso == Permiso.pagos || permiso == Permiso.corteCaja;
  }
}

/// Usuarios precargados en el sistema.
const List<Usuario> usuariosRegistrados = [
  Usuario(usuario: 'admin', contrasena: 'admin', rol: Rol.administrador),
  Usuario(usuario: 'super', contrasena: 'super', rol: Rol.superusuario),
  Usuario(usuario: 'user', contrasena: 'user', rol: Rol.usuario),
];

/// Valida las credenciales y devuelve el usuario autenticado, o `null` si no
/// coinciden con ningún usuario registrado.
Usuario? autenticar(String usuario, String contrasena) {
  final nombre = usuario.trim();
  for (final registrado in usuariosRegistrados) {
    if (registrado.usuario == nombre && registrado.contrasena == contrasena) {
      return registrado;
    }
  }
  return null;
}
