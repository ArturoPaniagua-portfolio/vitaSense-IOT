import 'package:flutter/material.dart';
import 'sql.dart';
import 'graficas.dart'; // Asegúrate de usar el path correcto

//Variables globales
String globalUser = 'U';
String globalPassword = 'C';
String globalName = 'Arturo';
String globalMail = '';
String globalSourname = '';
String globalTelephone= '';


void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VitaSENSE Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const AuthScreen(),
    );
  }
}
// Cambiamos AuthScreen a un StatefulWidget para que pueda mantener el estado
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}
//Pantalla de Inicio de sesion
class _AuthScreenState extends State<AuthScreen> {
  // Variables para almacenar el usuario y contraseña
  String usuario = '';
  String contra = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Autenticación'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(labelText: 'Usuario'),
              onChanged: (value) {
                // Actualizamos el usuario cada vez que cambie
                usuario = value;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
              onChanged: (value) {
                // Actualizamos la contraseña cada vez que cambie
                contra = value;
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('Iniciar Sesión'),
              onPressed: () {
                // Supongamos que estas son las credenciales correctas
                if (usuario == globalUser && contra == globalPassword) {
                  // Mostrar SnackBar para inicio de sesión exitoso
                  ScaffoldMessenger.of(context).showSnackBar(
                     const SnackBar(
                      content: Text('Inicio de sesión exitoso'),
                      duration: Duration(seconds: 1),
                    ),
                  );

                  // Navegar a DashboardScreen después de un pequeño retraso
                  Future.delayed(const Duration(seconds: 1), () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const DashboardScreen()),
                    );
                  });
                } else {
                  // Mostrar mensaje si las credenciales son incorrectas
                  showDialog(
                    context: context,
                    builder: (context) {
                      return const AlertDialog(
                        content: Text('Usuario o contraseña incorrectos'),
                      );
                    },
                  );
                }
              },
            ),
            TextButton(
              child: const Text('Crear cuenta nueva'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignUpScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}
//Pantalla de Crear una cuenta nueva
class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(); // Clave global para el Scaffold

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Asignar la clave al Scaffold
      appBar: AppBar(
        title: const Text('Crear Cuenta Nueva'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            TextFormField(
              controller: _surnameController,
              decoration: const InputDecoration(labelText: 'Apellido'),
            ),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Correo Electrónico'),
            ),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Teléfono'),
            ),
            TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Usuario'),
            ),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('Registrarse'),
              onPressed: () {
                // Actualizar las variables globales con los valores ingresados
                globalUser = _usernameController.text;
                globalPassword = _passwordController.text;
                globalMail = _emailController.text;
                globalName = _nameController.text;
                globalSourname = _surnameController.text;
                globalTelephone = _phoneController.text;

                // Mostrar SnackBar con ScaffoldMessenger
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Usuario registrado'),
                    duration: Duration(seconds: 1),
                  ),
                );

                // Esperar un segundo antes de navegar de regreso
                Future.delayed(const Duration(seconds: 1), () {
                  Navigator.pop(context);
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
//Pantalla del dashboard principal
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Future<Map<String, dynamic>> latestValues;
  @override
  void initState() {
    super.initState();
    latestValues = fetchLatestValues();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
        ],
      ),
      endDrawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              child: Text('Menú', style: TextStyle(color: Colors.white)),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            _buildDrawerItem(icon: Icons.history, title: 'Historial', onTap: () {/* Navega a la pantalla Historial */}),
            _buildDrawerItem(icon: Icons.settings, title: 'Config', onTap: () {/* Navega a la pantalla Configuración */}),
            _buildDrawerItem(icon: Icons.folder, title: 'Datos', onTap: () {/* Navega a la pantalla Datos */}),
            _buildDrawerItem(icon: Icons.notifications, title: 'Alertas', onTap: () {/* Navega a la pantalla Alertas */
              // Cerrar el drawer antes de navegar a la nueva pantalla
              Navigator.of(context).pop(); // Cierra el drawer
              // Navegar a FamiliaScreen
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const AlertasScreen(),
              ));}),
            _buildDrawerItem(icon: Icons.help, title: 'Ayuda', onTap: () {/* Navega a la pantalla Ayuda */}),
            _buildDrawerItem(icon: Icons.person, title: 'Personal', onTap: () {/* Navega a la pantalla Personal */}),
            _buildDrawerItem(icon: Icons.group, title: 'Familia', onTap: () {
              // Cerrar el drawer antes de navegar a la nueva pantalla
              Navigator.of(context).pop(); // Cierra el drawer
              // Navegar a FamiliaScreen
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const FamiliaScreen(),
              ));
            }),
          ],
        ),
      ),
      body: SingleChildScrollView( // Usa SingleChildScrollView para evitar desbordamientos
        child: Column(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.account_circle),
              title: Text(globalName),
              trailing: IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  // Acciones de configuración
                },
              ),
            ),
            // Aquí podrías añadir más widgets para mostrar más información
            // Resto de tus widgets...
            FutureBuilder<Map<String, dynamic>>(
              future: latestValues,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(child: _buildInfoCard('Humedad', '${snapshot.data!['humedad']}%')),
                        Expanded(child: _buildInfoCard('Temperatura', '${snapshot.data!['temperatura']}°C')),
                        Expanded(child: _buildInfoCard('Frecuencia Cardiaca', '${snapshot.data!['frecuenciaCardiaca']} bpm')),
                      ],
                    ),
                  );
                } else {
                  return const Text('No hay datos disponibles');
                }
              },
            ),
          const GraficaTitulo('Temperatura', 'temperatura'),
          const GraficaTitulo('Humedad', 'humedad'),
          const GraficaTitulo('Frecuencia Cardiaca', 'frecuencia_cardiaca'),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Resumen de Información'),
          ),
            
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    // Aquí se construye el drawer
    return const Drawer(
      // ... El contenido del Drawer ...
    );
  }
  
    Widget _buildDrawerItem({required IconData icon, required String title, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }

  Widget _buildInfoCard(String title, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}

Widget _buildInfoCard(String title, String value) {
    return Card(
      margin: const EdgeInsets.all(4.0), // Ajusta el margen según sea necesario
      child: Container(
        padding: const EdgeInsets.all(16.0), // Ajusta el padding según sea necesario
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
//Pantalla de Familia
class FamiliaScreen extends StatelessWidget {
  const FamiliaScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Familia'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // Código para agregar un nuevo miembro de la familia
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          _buildFamilyMemberCard(
            name: 'Abuelita',
            state: 'Excelente',
            heartRate: '92',
            temperature: '36°',
            roomHumidity: '26%',
          ),
            _buildFamilyMemberCard(
            name: 'José',
            state: 'Excelente',
            heartRate: '87',
            temperature: '36°',
            roomHumidity: '29%',
          ),
            _buildFamilyMemberCard(
            name: 'Rogelio',
            state: 'Excelente',
            heartRate: '87',
            temperature: '35°',
            roomHumidity: '29%',
          ),
            _buildFamilyMemberCard(
            name: 'Chona',
            state: 'Con Fiebre',
            heartRate: '87',
            temperature: '38°',
            roomHumidity: '30%',
          ),
          // Repite para cada miembro de la familia...
        ],
      ),
    );
  }

  Widget _buildFamilyMemberCard({
    required String name,
    required String state,
    required String heartRate,
    required String temperature,
    required String roomHumidity,
  }) {
    return Card(
      child: ListTile(
        leading: const CircleAvatar(
          child: Icon(Icons.person),
          backgroundColor: Colors.blueAccent,
        ),
        title: Text(name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Estado: $state'),
            Text('Frecuencia cardíaca: $heartRate'),
            Text('Temperatura: $temperature'),
            Text('Humedad del ambiente: $roomHumidity'),
          ],
        ),
      ),
    );
  }
}

//Pantalla de Alertas
class AlertasScreen extends StatelessWidget {
  const AlertasScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alertas'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Alertas',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildAlertCard(
              icon: Icons.favorite,
              text: 'Tu frecuencia cardíaca aumentó hasta 110 a las 11:27 am, cuida tu presión.',
            ),
            _buildAlertCard(
              icon: Icons.wb_sunny,
              text: 'La humedad del ambiente es un poco alta, recuerda llevar tu inhalador para evitar problemas.',
            ),
            const SizedBox(height: 20),
            const Text(
              'Recomendaciones',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
            ),
            const SizedBox(height: 10),
            const Text('• Mantén una temperatura corporal estable evitando cambios bruscos de clima.'),
            const Text('• Si tienes problemas de sangre, evita esfuerzos físicos durante picos de temperatura alta.'),
            const Text('• Para las personas con asma, es importante mantener un ambiente con humedad controlada.'),
            const Text('• Los adultos mayores deben mantenerse hidratados y evitar el calor excesivo.'),
            const Text('• Controla tu frecuencia cardíaca después de hacer ejercicio y mantén un registro.'),
            // Añade más recomendaciones según sea necesario
          ],
        ),
      ),
    );
  }

  Widget _buildAlertCard({required IconData icon, required String text}) {
    return Card(
      child: ListTile(
        leading: Icon(icon, size: 40),
        title: Text(text),
      ),
    );
  }
}
