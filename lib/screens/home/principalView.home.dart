import 'package:flutter/material.dart';
import 'package:passengercontrol_chaskipass/screens/home/scanner.home.dart';
import 'package:passengercontrol_chaskipass/screens/home/scanner2.dart';
import 'package:passengercontrol_chaskipass/services/frequenciesService.services.dart';

class Principalview extends StatefulWidget {
  @override
  _PrincipalviewState createState() => _PrincipalviewState();
}

class _PrincipalviewState extends State<Principalview> {
  final TextEditingController _idController = TextEditingController();
  List<Map<String, dynamic>> _frequencies = [];

  @override
  void initState() {
    super.initState();
    _loadFrequencies(); // Llama a la función auxiliar para cargar los datos
  }

  Future<void> _loadFrequencies() async {
    FrequenciesService actionService = FrequenciesService();
    try {
      final data = await actionService.getFrequencies();
      setState(() {
        _frequencies = data;
      });
    } catch (e) {
      // Manejar errores de la consulta
      print('Error al cargar las frecuencias: $e');
    }
  }

  void _searchFrequencies() {
    final id = _idController.text.trim();
    if (id.isNotEmpty) {
      final filtered =
          _frequencies.where((freq) => freq['id'].toString() == id).toList();
      setState(() {
        _frequencies = filtered;
      });
    } else {
      _loadFrequencies(); // Recargar todas las frecuencias si el ID está vacío
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Frecuencias de Viaje'),
        backgroundColor: Colors.blue.shade800,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Input para ID de frecuencia
            TextField(
              controller: _idController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'ID de Frecuencia',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            // Botón para buscar frecuencias
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => navigateToNextScreen(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                ),
                child: Text('Validar Frecuencia'),
              ),
            ),
            const SizedBox(height: 20),
            // Tabla de frecuencias
            if (_frequencies.isNotEmpty)
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    showCheckboxColumn: false,
                    columns: const [
                      DataColumn(label: Text('ID')),
                      DataColumn(label: Text('Ciudad Origen')),
                      DataColumn(label: Text('Ciudad Destino')),
                      DataColumn(label: Text('Hora de Partida')),
                    ],
                    rows:
                        _frequencies
                            .map(
                              (frequency) => DataRow(
                                cells: [
                                  DataCell(Text(frequency['id'].toString())),
                                  DataCell(
                                    Text(frequency['departure_city_name']),
                                  ),
                                  DataCell(
                                    Text(frequency['arrival_city_name']),
                                  ),
                                  DataCell(Text(frequency['departure_time'])),
                                ],
                                onSelectChanged: (selected) {
                                  if (selected != null && selected) {
                                    setState(() {
                                      _idController.text =
                                          frequency['id'].toString();
                                    });
                                  }
                                },
                                selected: false,
                              ),
                            )
                            .toList(),
                  ),
                ),
              )
            else
              Center(
                child: Text(
                  'No hay frecuencias disponibles',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  void navigateToNextScreen(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => ScannerScreen2()));
  }
}

void main() => runApp(
  MaterialApp(debugShowCheckedModeBanner: false, home: Principalview()),
);
