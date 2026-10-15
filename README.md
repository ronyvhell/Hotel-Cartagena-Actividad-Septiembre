# Hotel Cartagena - Aplicación Flutter

Versión con interfaz gráfica (Flutter) del sistema de administración de
habitaciones y huéspedes del Hotel Cartagena, construida a partir del
proyecto de consola original en Dart. Conserva exactamente las mismas
reglas de negocio (RF01-RF08); lo único que cambia es la forma de
interactuar con el sistema: en vez de un menú de texto, se usan
ventanas (pantallas) de Material Design.

## 1. Objetivo

Permitir a los recepcionistas del hotel registrar usuarios, iniciar
sesión, consultar habitaciones disponibles, reservar, hacer check-in y
hacer check-out desde una aplicación gráfica sencilla, funcional en
Android, iOS, web y escritorio (Flutter es multiplataforma).

## 2. Estructura del proyecto

```
hotel_cartagena_flutter/
├── lib/
│   ├── main.dart                 # Punto de entrada de la app
│   ├── enums/
│   │   ├── tipo_habitacion.dart
│   │   └── estado_habitacion.dart
│   ├── models/
│   │   ├── habitacion.dart
│   │   ├── huesped.dart
│   │   ├── recepcionista.dart
│   │   ├── reserva.dart
│   │   ├── check_in.dart
│   │   └── check_out.dart
│   ├── services/
│   │   └── hotel.dart            # Toda la lógica/reglas de negocio
│   ├── widgets/
│   │   └── mensajes.dart         # Helpers para SnackBars de éxito/error
│   └── screens/                  # Una ventana por pantalla
│       ├── login_screen.dart
│       ├── register_screen.dart
│       ├── home_screen.dart
│       ├── rooms_screen.dart
│       ├── reserve_screen.dart
│       ├── checkin_screen.dart
│       └── checkout_screen.dart
├── test/
│   └── widget_test.dart
├── pubspec.yaml
├── analysis_options.yaml
└── README.md
```

**Separación de responsabilidades:**
- `models/` y `enums/`: representan los datos del sistema, igual que
  en la versión de consola.
- `services/hotel.dart`: es la ÚNICA clase que aplica reglas de
  negocio (crear/validar reservas, check-in, check-out, etc.). Lanza
  `HotelException` cuando algo no cumple una regla.
- `screens/`: son las ventanas de la interfaz. Solo leen datos de
  formularios, llaman a métodos de `Hotel` y muestran el resultado
  (éxito o error). No validan reglas de negocio por su cuenta.
- `widgets/mensajes.dart`: evita repetir el mismo código de SnackBar
  en cada pantalla.

## 3. Ventanas de la aplicación

1. **Login** (`login_screen.dart`): inicio de sesión (RF02). Desde
   aquí también se puede ir a la ventana de registro.
2. **Registro** (`register_screen.dart`): crear un nuevo recepcionista
   (RF01), con validación de que las contraseñas coincidan.
3. **Menú principal** (`home_screen.dart`): cuadrícula con accesos a
   las cuatro operaciones del sistema, y botón de cerrar sesión.
4. **Consultar habitaciones** (`rooms_screen.dart`): lista las
   habitaciones disponibles agrupadas por tipo (RF03).
5. **Reservar habitación** (`reserve_screen.dart`): formulario con los
   datos del huésped, número de habitación y días (RF04, RF05).
6. **Check-in** (`checkin_screen.dart`): número de habitación y
   cantidad de personas (RF06).
7. **Check-out** (`checkout_screen.dart`): número de habitación a
   liberar (RF07).

El estado del hotel (`Hotel hotel = Hotel();`) se crea una sola vez en
`main.dart` y se pasa por el constructor de cada pantalla, de forma
que todas comparten la misma información mientras la app esté abierta.

## 4. Cómo instalar y ejecutar el proyecto

**Requisitos:** tener instalado el
[SDK de Flutter](https://docs.flutter.dev/get-started/install) y un
dispositivo/emulador, un navegador o soporte de escritorio habilitado.

Como este código se entrega solo con la carpeta `lib/`, `test/` y los
archivos de configuración (sin las carpetas nativas `android/`, `ios/`,
`web/`, que Flutter genera automáticamente), sigue estos pasos:

1. Crear un proyecto Flutter nuevo con el mismo nombre:
   ```bash
   flutter create hotel_cartagena_flutter
   ```
2. Dentro del proyecto recién creado, reemplazar la carpeta `lib/`
   generada por la carpeta `lib/` de este entregable, y copiar también
   `test/widget_test.dart` y `analysis_options.yaml`.
3. Abrir `pubspec.yaml` del proyecto generado y agregar/verificar las
   dependencias `cupertino_icons` y `flutter_lints` como se muestra en
   el `pubspec.yaml` de este entregable (la sección `name:` debe
   coincidir con `hotel_cartagena_flutter`).
4. Instalar las dependencias:
   ```bash
   flutter pub get
   ```
5. Ejecutar la aplicación (elige un dispositivo/emulador, o usa
   `-d chrome` para correrla en el navegador):
   ```bash
   flutter run
   ```
6. Ejecutar las pruebas:
   ```bash
   flutter test
   ```

## 5. Reglas de negocio implementadas

Las mismas reglas del proyecto original, ahora validadas por
`lib/services/hotel.dart` y mostradas como mensajes de error/éxito en
la interfaz gráfica:

- Una habitación nueva comienza en estado `disponible`.
- Una habitación solo puede reservarse si está `disponible`.
- Al reservarse, la habitación pasa a estado `reservada`.
- Una habitación `reservada` puede pasar a `ocupada` mediante check-in.
- El número de personas del check-in debe ser mayor que cero.
- El número de personas no puede superar la capacidad de la habitación
  (sencilla = 1, doble = 2, suite = 4).
- Una habitación `ocupada` puede volver a `disponible` mediante
  check-out.
- No se permiten usuarios (recepcionistas) duplicados.
- No se permiten reservas sobre habitaciones inexistentes o con días
  menores o iguales a cero.
- No se permite check-in sin una reserva activa asociada.
- No se permite check-out sobre una habitación que no esté ocupada.

**Decisión sobre el cierre de la reserva:** al hacer check-out, la
reserva no se elimina; se marca con `activa = false` y queda como
historial, igual que en la versión de consola. Esto permitiría en el
futuro mostrar un historial de estadías por huésped.

## 6. Comentarios en el código

Todo el código fuente incluye comentarios en español explicando:
- El propósito de cada clase y método.
- Por qué se tomaron ciertas decisiones de diseño (por ejemplo, por
  qué la capacidad vive en `TipoHabitacion` y no en `Habitacion`, o por
  qué se usa `pushReplacement` en vez de `push` al iniciar sesión).
- Qué reglas de negocio corresponden a cada validación.

## 7. Dificultades encontradas y cómo fueron solucionadas

- **Compartir el estado del hotel entre pantallas:** en vez de usar un
  paquete de manejo de estado externo (Provider, Riverpod, Bloc), se
  optó por crear una única instancia de `Hotel` en `main.dart` y
  pasarla por el constructor de cada pantalla. Es la solución más
  sencilla para un proyecto académico de este tamaño.
- **Refrescar la lista de habitaciones disponibles:** como
  `RoomsScreen` vuelve a llamar a `hotel.consultarDisponiblesAgrupadas()`
  cada vez que se construye, basta con navegar a esa pantalla de nuevo
  (por ejemplo, volviendo al menú principal y entrando otra vez) para
  ver los cambios hechos desde otra ventana.
- **Validaciones duplicadas entre la interfaz y `Hotel`:** algunas
  validaciones simples (como "los días deben ser mayores que cero")
  se repiten en el formulario y en `Hotel`. Esto es intencional: la
  validación del formulario da feedback inmediato en el campo, y la
  validación de `Hotel` garantiza que la regla se cumpla sin importar
  desde dónde se llame al servicio.
