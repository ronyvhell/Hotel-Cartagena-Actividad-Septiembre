# Guía de instalación y ejecución — Hotel Cartagena (Flutter)

Esta guía explica todo lo necesario para descargar, configurar, ejecutar y
probar el proyecto **Hotel Cartagena - Actividad Septiembre** desde cero.

> **Importante:** el repositorio contiene solo el código fuente (`lib/`,
> `test/`, `pubspec.yaml`, `analysis_options.yaml`). Las carpetas de cada
> plataforma (`android/`, `web/`, `windows/`, etc.) **no vienen incluidas**;
> se generan con un solo comando en el paso 4.

---

## 1. Requisitos

| Herramienta | Versión recomendada | Para qué sirve |
|---|---|---|
| [Flutter SDK](https://docs.flutter.dev/get-started/install) | 3.16 o superior (incluye Dart 3) | Compilar y ejecutar la app |
| [Git](https://git-scm.com/downloads) | Cualquiera reciente | Descargar el repositorio |
| Google Chrome o Edge | Cualquiera reciente | Ejecutar la app en el navegador (opción más sencilla) |
| [VS Code](https://code.visualstudio.com/) + extensión **Flutter** | Opcional | Editar y ejecutar con un clic |
| Android Studio + emulador | Opcional | Probar la app como en un celular |
| Visual Studio 2022 con "Desarrollo de escritorio con C++" | Opcional | Ejecutar como app de escritorio en Windows |

> El pubspec exige `sdk: '>=3.0.0 <4.0.0'`, por lo que cualquier Flutter con
> Dart 3 funciona.

### Instalar Flutter en Windows (resumen)

Opción rápida con `winget` (PowerShell):

```powershell
winget install --id Git.Git -e
winget install --id Google.Flutter -e   # si no está disponible, usa la instalación manual
```

Instalación manual:

1. Descarga el SDK desde <https://docs.flutter.dev/get-started/install/windows>.
2. Descomprímelo en una ruta **sin espacios**, por ejemplo `C:\src\flutter`.
3. Agrega `C:\src\flutter\bin` a la variable de entorno **Path**.
4. Abre una terminal **nueva** y verifica:

```powershell
flutter --version
flutter doctor
```

`flutter doctor` muestra qué falta. Para correr en Chrome basta con que
aparezcan en verde **Flutter** y **Chrome**; lo de Android o Visual Studio
solo es necesario si vas a usar esas plataformas.

---

## 2. Descargar el proyecto

```bash
git clone https://github.com/ronyvhell/Hotel-Cartagena-Actividad-Septiembre.git
cd Hotel-Cartagena-Actividad-Septiembre
```

---

## 3. Instalar dependencias

```bash
flutter pub get
```

Descarga `cupertino_icons`, `flutter_test` y `flutter_lints`.

---

## 4. Generar las carpetas de plataforma (solo la primera vez)

Desde la raíz del proyecto:

```bash
flutter create --project-name hotel_cartagena_flutter --platforms=web,windows,android .
```

- El punto (`.`) indica "el proyecto actual". **No reemplaza** el código de
  `lib/` ni `test/`; solo agrega las carpetas que faltan.
- `--project-name hotel_cartagena_flutter` es obligatorio: el nombre de la
  carpeta tiene guiones y mayúsculas, que Dart no acepta como nombre de
  paquete, y las pruebas importan `package:hotel_cartagena_flutter/...`.
- Puedes dejar solo las plataformas que vayas a usar (por ejemplo
  `--platforms=web`).

---

## 5. Ejecutar la aplicación

Ver los dispositivos disponibles:

```bash
flutter devices
```

Ejecutar según la plataforma:

```bash
flutter run -d chrome     # navegador (la más sencilla)
flutter run -d edge       # navegador Edge
flutter run -d windows    # escritorio Windows (requiere Visual Studio C++)
flutter run               # emulador/celular Android conectado
```

Atajos mientras la app corre en la terminal:

| Tecla | Acción |
|---|---|
| `r` | *Hot reload*: aplica cambios del código sin perder el estado |
| `R` | *Hot restart*: reinicia la app (se borran los datos en memoria) |
| `q` | Salir |

Desde VS Code: abre la carpeta, elige el dispositivo en la barra inferior y
presiona **F5**.

---

## 6. Primer uso de la app

La app **no trae un usuario de prueba** y guarda los datos solo en memoria
(se pierden al cerrar o al hacer *hot restart*).

1. En la pantalla de inicio de sesión, toca **Registrarse**.
2. Crea un recepcionista, por ejemplo `admin` / `admin123`.
3. Inicia sesión con ese usuario.
4. Desde el menú principal puedes consultar habitaciones, reservar, hacer
   check-in y check-out.

Habitaciones creadas automáticamente al iniciar:

| Números | Tipo | Capacidad |
|---|---|---|
| 101 – 103 | Sencilla | 1 persona |
| 104 – 106 | Doble | 2 personas |
| 107 – 109 | Suite | 4 personas |

Flujo de estados: `Disponible → Reservada (reserva) → Ocupada (check-in) → Disponible (check-out)`.

### Recorrido de prueba sugerido

1. **Consultar habitaciones** → deben aparecer las 9 disponibles.
2. **Reservar** la habitación `104` por `2` días.
3. Volver a **Consultar habitaciones** → la 104 ya no aparece.
4. **Check-in** en la `104` con `3` personas → debe mostrar error de capacidad.
5. **Check-in** en la `104` con `2` personas → éxito.
6. **Check-out** de la `104` → vuelve a estar disponible.

---

## 7. Pruebas y calidad del código

```bash
flutter test        # ejecuta test/widget_test.dart (verifica que abre el login)
flutter analyze     # análisis estático con las reglas de flutter_lints
dart format .       # formatea el código
```

Resultado esperado de `flutter test`: `All tests passed!`

---

## 8. Estructura del proyecto

```
lib/
├── main.dart              # Punto de entrada; crea la única instancia de Hotel
├── enums/                 # TipoHabitacion (capacidad) y EstadoHabitacion
├── models/                # Habitacion, Huesped, Recepcionista, Reserva, CheckIn, CheckOut
├── services/hotel.dart    # TODAS las reglas de negocio (no modificar en el rediseño)
├── widgets/mensajes.dart  # SnackBars de éxito y error
└── screens/               # login, register, home, rooms, reserve, checkin, checkout
test/
└── widget_test.dart
diapositivas/              # Entregables de la actividad "Descubriendo el código" (Grupo 4)
```

La pantalla trabajada en la actividad de rediseño es
`lib/screens/rooms_screen.dart` (**RoomsScreen**).

---

## 9. Solución de problemas

| Problema | Solución |
|---|---|
| `flutter` no se reconoce como comando | Revisa que `flutter\bin` esté en el Path y abre una terminal nueva. |
| `No supported devices connected` | Faltan las carpetas de plataforma: ejecuta el paso 4. |
| `Target of URI doesn't exist: package:hotel_cartagena_flutter/...` | Ejecuta `flutter pub get` y verifica que `name:` en `pubspec.yaml` sea `hotel_cartagena_flutter`. |
| Error de Visual Studio al usar `-d windows` | Instala Visual Studio 2022 con "Desarrollo de escritorio con C++", o usa `-d chrome`. |
| Advertencia `withOpacity is deprecated` | Es solo un aviso en versiones nuevas de Flutter; la app funciona igual. |
| Los datos desaparecieron | Es normal: la app guarda todo en memoria. Registra el usuario de nuevo. |
| `flutter create .` falla por el nombre del proyecto | Asegúrate de incluir `--project-name hotel_cartagena_flutter`. |

---

## 10. Autor

**Rony Andrés Valdelamar Vergara** — Pantalla asignada: RoomsScreen (Grupo 4).

---

## Publicar en Vercel (versión web)

Flutter puede compilar la app a una página web estática (`build/web`), y eso
sí se puede alojar en Vercel. Vercel no trae Flutter instalado, así que el
archivo `vercel.json` de este repo lo descarga en cada despliegue y luego
ejecuta `flutter build web --release`.

1. Entra a <https://vercel.com/new> e importa el repositorio
   `ronyvhell/Hotel-Cartagena-Actividad-Septiembre`.
2. En **Framework Preset** deja **Other**. No cambies los comandos: Vercel
   toma los de `vercel.json`.
3. Pulsa **Deploy**. El primer build tarda unos minutos porque descarga
   el SDK de Flutter.

Alternativa sin esperar el build en Vercel: compilar en tu PC y subir solo
la carpeta generada.

```powershell
flutter build web --release
npx vercel deploy build/web --prod
```

> **Limitación:** la app guarda todo en memoria (no tiene base de datos).
> Al recargar la página se pierden los usuarios y reservas creados.
