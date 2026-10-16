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
│   ├── widget_test.dart          # Prueba original (login)
│   └── rooms_screen_test.dart    # Pruebas del rediseño de RoomsScreen
├── web/                          # Plataforma web (para `flutter run -d chrome`)
├── evidencias/                   # Capturas y registro de pruebas (PRUEBAS.md)
├── informe/                      # Informe breve (md, html, docx, pdf)
├── presentacion/                 # Presentación de la actividad de rediseño
├── actividad_anterior/           # PDFs de "Descubriendo el código" (Grupo 4)
├── pubspec.yaml
├── analysis_options.yaml
├── INSTALACION.md
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
   habitaciones disponibles agrupadas por tipo (RF03). **Rediseñada**
   en la actividad de septiembre (ver sección 8): resumen del hotel,
   filtro por número de personas, botón "Reservar" por habitación y
   actualización automática/manual.
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

> 📄 La guía completa y actualizada (requisitos, comandos, primer uso y
> solución de problemas) está en **[INSTALACION.md](INSTALACION.md)**.

**Requisitos:** tener instalado el
[SDK de Flutter](https://docs.flutter.dev/get-started/install) y un
dispositivo/emulador, un navegador o soporte de escritorio habilitado.

El repositorio ya incluye la carpeta `web/`, así que para correrlo en
Chrome basta con `flutter pub get` y `flutter run -d chrome`. Para
otras plataformas (`android/`, `windows/`, etc.) ejecuta una vez
`flutter create --project-name hotel_cartagena_flutter .` en la raíz
(ver INSTALACION.md). La alternativa manual es:

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
- **Refrescar la lista de habitaciones disponibles:** en la versión
  original había que salir y volver a entrar a la pantalla. En el
  rediseño, `RoomsScreen` es `StatefulWidget`: se reconstruye al volver
  de `ReserveScreen` y tiene un botón "Actualizar" en la barra superior
  (además del gesto `RefreshIndicator`, que en Chrome/escritorio no
  funciona con el mouse).
- **Validaciones duplicadas entre la interfaz y `Hotel`:** algunas
  validaciones simples (como "los días deben ser mayores que cero")
  se repiten en el formulario y en `Hotel`. Esto es intencional: la
  validación del formulario da feedback inmediato en el campo, y la
  validación de `Hotel` garantiza que la regla se cumpla sin importar
  desde dónde se llame al servicio.

## 8. Actividad de rediseño: mejoras propuestas para RoomsScreen

Pantalla asignada: **`lib/screens/rooms_screen.dart` (RoomsScreen, RF03)** —
Grupo 4 en la actividad "Descubriendo el código de Hotel Cartagena".

### 8.1 Necesidad del usuario

> *El recepcionista necesita encontrar rápido una habitación que le sirva al
> huésped y reservarla sin equivocarse de número.*

### 8.2 Diagnóstico de la pantalla original

| # | Problema observado | Consecuencia para el usuario | Evidencia en el código |
|---|---|---|---|
| P1 | El chip de estado siempre dice "Disponible" en verde. | Ruido visual: ocupa espacio sin aportar información. | Solo se listan disponibles (`consultarDisponiblesAgrupadas()`); el propio comentario de `_EstadoChip` lo reconoce. |
| P2 | La pantalla no lleva a ninguna acción. | Para reservar hay que volver al menú, entrar a Reservar y escribir el número de memoria; riesgo de error y pérdida de tiempo. | Los `ListTile` no tienen `onTap` ni botones. |
| P3 | No ayuda a elegir según el número de huéspedes. | Con un grupo de 3, el recepcionista debe deducir que solo sirve una Suite. | La capacidad solo aparece como texto en el `subtitle`. |
| P4 | No hay panorama general del hotel. | Con "0 disponibles" no se sabe si el hotel está lleno o qué está reservado/ocupado. | Solo se muestran habitaciones disponibles; no hay totales. |
| P5 | Los datos pueden quedar desactualizados. | Si se vuelve a la pantalla desde otra, no se refresca y no hay forma de actualizar. | `RoomsScreen` es `StatelessWidget`, sin `RefreshIndicator`. |
| P6 | Textos poco naturales y estado vacío sin orientación. | Lectura menos clara ("disponible(s)", "persona(s)"); el aviso vacío no sugiere qué hacer. | Cadenas en el `title` del `ExpansionTile` y en el `ListTile` de aviso. |

### 8.3 Mejoras priorizadas

| Prioridad | Mejora | Problema que resuelve | Cambio en Flutter | Beneficio esperado | Cómo se comprobará |
|---|---|---|---|---|---|
| 1 | Botón **Reservar** en cada habitación que abre `ReserveScreen` con el número precargado. | P2 | `ListTile.trailing` con `FilledButton.tonal` + `Navigator.push`; parámetro opcional `numeroInicial` en `ReserveScreen`. | Menos pasos y cero errores al digitar el número. | Contar toques antes/después; reservar desde la lista sin escribir el número. |
| 2 | Filtro **"¿Cuántas personas?"** (1 · 2 · 3–4). | P3 | `ChoiceChip` en un `Wrap`; filtra por `habitacion.capacidad` solo para mostrar. | Ver solo habitaciones que sirven al huésped. | Seleccionar "3–4" y verificar que solo aparecen Suites. |
| 3 | **Resumen superior** con disponibles, reservadas y ocupadas. | P4 | `Row` de tarjetas de conteo leyendo `hotel.habitaciones` (solo lectura). | Panorama del hotel de un vistazo. | Reservar/check-in y verificar que los contadores cambian. |
| 4 | **Actualización automática y manual.** | P5 | Pasar a `StatefulWidget`; `setState` al volver de `ReserveScreen`; `RefreshIndicator`. | La lista siempre refleja el estado real. | Reservar desde la lista y comprobar que la habitación desaparece al volver. |
| 5 | **Limpieza visual y textos.** | P1, P6 | Quitar el chip redundante; capacidad con ícono `Icons.person`; plurales correctos; estado vacío con sugerencia. | Pantalla más limpia y fácil de leer. | Comparar capturas antes/después; prueba en pantalla pequeña sin desbordes. |

### 8.4 Restricciones respetadas

- **No se modifican las reglas de negocio** de `lib/services/hotel.dart`; la
  validación de capacidad sigue ocurriendo en el check-in y la de disponibilidad
  en la reserva.
- El filtro y el resumen son **solo de presentación** (leen datos, no validan).
- Único cambio fuera de la pantalla: parámetro opcional `numeroInicial` en
  `ReserveScreen` (no altera su comportamiento si no se envía).

### 8.5 Pruebas previstas

| Escenario | Acción | Resultado esperado |
|---|---|---|
| Uso normal | Filtrar por 2 personas y reservar la 104 desde la lista. | `ReserveScreen` abre con "104"; al volver, la 104 ya no aparece y el resumen se actualiza. |
| Datos incorrectos | En la reserva precargada, poner 0 días. | El formulario y `Hotel` rechazan la reserva con mensaje de error. |
| Error de negocio | Reservar dos veces la misma habitación (otra pestaña/flujo). | `HotelException`: "La habitación X no está disponible." |
| Sin resultados | Reservar las 3 Suites y filtrar por 3–4 personas. | Estado vacío con sugerencia, sin errores. |
| Otro tamaño de pantalla | Ejecutar en ventana angosta (≈360 px) y ancha. | Sin desbordes; contenido legible. |

### 8.6 Estado de la implementación

Las 5 mejoras están **implementadas** en `lib/screens/rooms_screen.dart`
(más el parámetro `numeroInicial` en `reserve_screen.dart`).
`lib/services/hotel.dart` **no se modificó**.

| Mejora | Estado | Evidencia |
|---|---|---|
| 1. Botón Reservar con número precargado | Comprobado | Prueba A3 (`test/rooms_screen_test.dart`) |
| 2. Filtro "¿Cuántas personas?" | Comprobado | Prueba A2 |
| 3. Resumen superior | Comprobado | Prueba A1 |
| 4. Actualización automática y manual (gesto + botón "Actualizar") | Observado | Código; prueba A5 y manuales M1/M6 por ejecutar |
| 5. Limpieza visual y textos | Comprobado | Pruebas A1 y A4 + capturas antes/después |
| Beneficio "elegir más rápido" | Esperado | Requiere prueba con un compañero/usuario |

Detalle completo en [`informe/INFORME_RoomsScreen.md`](informe/INFORME_RoomsScreen.md)
y registro de pruebas en [`evidencias/PRUEBAS.md`](evidencias/PRUEBAS.md).

## 9. Entregables de la actividad

| Entregable (guía) | Dónde está |
|---|---|
| Proyecto Flutter actualizado | `lib/`, `test/`, `web/`, `pubspec.yaml` |
| Informe breve de diagnóstico y mejora | `informe/` (md, html, docx, pdf) |
| Presentación académica | `presentacion/` |
| Evidencias visuales y funcionales | `evidencias/` (capturas 01–07) |
| Registro de pruebas | `evidencias/PRUEBAS.md` |

Pruebas automatizadas: `flutter test` (6 pruebas: 1 de login + 5 de RoomsScreen).
