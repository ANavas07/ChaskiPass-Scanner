import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:passengercontrol_chaskipass/services/clientsFrequency.services.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:open_file/open_file.dart';

const bgColor = Color(0xfffafafa);

class ScannerScreen2 extends StatefulWidget {
  const ScannerScreen2({super.key});

  @override
  State<ScannerScreen2> createState() => _ScannerScreen2State();
}

class _ScannerScreen2State extends State<ScannerScreen2> {
  bool isScanCompleted = false;
  String scannedResult = ''; // Almacena el resultado del escaneo
  List<String> dataList = []; // Lista para mostrar debajo del input
  List<Map<String, dynamic>> _frequencyClients = [];
  List<Map<String, dynamic>> _validatedClients = [];
  String validationMessage = ''; // Mensaje de validación

  @override
  void initState() {
    super.initState();
    _loadClientFrequency();
  }

  Future<void> _loadClientFrequency() async {
    ClientsFrequencyService actionService = ClientsFrequencyService();
    try {
      final data = await actionService.getClientsFrequency();
      setState(() {
        _frequencyClients = data;
      });
    } catch (e) {
      throw Exception('Error al obtener las frecuencias: $e');
    }
  }

  /// Función para validar el cliente escaneado
  void validateClient(String id) {
    final filtered =
        _frequencyClients
            .where((freq) => freq['ticket_code'].toString() == id)
            .toList();

    if (filtered.isNotEmpty) {
      if (_validatedClients.any(
        (client) => client['ticket_code'].toString() == id,
      )) {
        setState(() {
          validationMessage = 'El ticket ya ha sido validado.';
          scannedResult = '';
        });
      } else {
        setState(() {
          _validatedClients.add(filtered.first); // Añade el cliente validado
          validationMessage =
              'Cliente validado: ${filtered.first['client_name']}';
          scannedResult = '';
        });
      }
    } else {
      setState(() {
        validationMessage = 'Cliente no encontrado';
        scannedResult = '';
      });

      // Mostrar un mensaje en pantalla
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cliente no encontrado'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  //Funcion para generar el reporte en PDF
  /// Función para generar el reporte en PDF
  Future<void> generatePdfReport() async {
    try {
      final pdf = pw.Document();

      // Lista de clientes no validados
      final unvalidatedClients =
          _frequencyClients
              .where((client) => !_validatedClients.contains(client))
              .toList();

      // Construye el contenido del PDF
      pdf.addPage(
        pw.Page(
          build:
              (context) => pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Reporte de Pasajeros',
                    style: pw.TextStyle(
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  // Tabla de clientes validados
                  pw.Text(
                    'Clientes Validados',
                    style: pw.TextStyle(
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Table(
                    border: pw.TableBorder.all(),
                    children: [
                      pw.TableRow(
                        children: [
                          pw.Text(
                            'DNI',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                          pw.Text(
                            'Nombre',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                          pw.Text(
                            'Código de Boleto',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                          pw.Text(
                            'Asiento',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                        ],
                      ),
                      ..._validatedClients.map(
                        (client) => pw.TableRow(
                          children: [
                            pw.Text(client['client_dni']),
                            pw.Text(client['client_name']),
                            pw.Text(client['ticket_code']),
                            pw.Text(client['seat_id']),
                          ],
                        ),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 20),
                  // Tabla de clientes no validados
                  pw.Text(
                    'Clientes No Validados',
                    style: pw.TextStyle(
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Table(
                    border: pw.TableBorder.all(),
                    children: [
                      pw.TableRow(
                        children: [
                          pw.Text(
                            'DNI',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                          pw.Text(
                            'Nombre',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                          pw.Text(
                            'Código de Boleto',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                          pw.Text(
                            'Asiento',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                        ],
                      ),
                      ...unvalidatedClients.map(
                        (client) => pw.TableRow(
                          children: [
                            pw.Text(client['client_dni']),
                            pw.Text(client['client_name']),
                            pw.Text(client['ticket_code']),
                            pw.Text(client['seat_id']),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
        ),
      );

      // Obtiene la ruta de la carpeta de Documentos
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/reporte_pasajeros.pdf';
      final file = File(filePath);

      // Guarda el archivo PDF
      await file.writeAsBytes(await pdf.save());

      // Abre el archivo
      await OpenFile.open(file.path);

      // Mostrar un mensaje de éxito si el widget sigue montado
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Reporte Generado'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      // Mostrar error si el widget sigue montado
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al generar el reporte: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void closeScreen() {
    isScanCompleted = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Scanner de QR",
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Enfoca el código QR en el área de escaneo",
              style: TextStyle(
                color: Colors.black87,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Se escaneará automáticamente",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 16,
                fontWeight: FontWeight.w400,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 16),
            // Escáner más pequeño
            AspectRatio(
              aspectRatio:
                  4 / 3, // Define un tamaño más pequeño para el escáner
              child: MobileScanner(
                onDetect: (barcodeCapture) {
                  // if (!isScanCompleted) {
                  if (barcodeCapture.barcodes.isNotEmpty) {
                    String resultString =
                        barcodeCapture.barcodes.first.rawValue ?? '';
                    setState(() {
                      scannedResult =
                          resultString; // Muestra el resultado en el input
                      validateClient(resultString); // Valida el cliente
                      // isScanCompleted = true;
                    });
                  }
                  // }
                },
              ),
            ),
            const SizedBox(height: 16),
            // Input con el resultado escaneado
            TextField(
              controller: TextEditingController(text: scannedResult),
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Resultado escaneado',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            // Mensaje de validación
            Text(
              validationMessage,
              style: TextStyle(
                color:
                    validationMessage.contains('no encontrado')
                        ? Colors.red
                        : Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            // Botón para generar reporte
            ElevatedButton(
              onPressed: generatePdfReport,
              child: const Text('Generar Reporte en PDF'),
            ),
            const SizedBox(height: 16),
            // Tabla de clientes validados
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('DNI')),
                    DataColumn(label: Text('Nombre')),
                    DataColumn(label: Text('Código de Boleto')),
                    DataColumn(label: Text('Asiento')),
                  ],
                  rows:
                      _validatedClients
                          .map(
                            (client) => DataRow(
                              cells: [
                                DataCell(Text(client['client_dni'].toString())),
                                DataCell(Text(client['client_name'])),
                                DataCell(Text(client['ticket_code'])),
                                DataCell(Text(client['seat_id'])),
                              ],
                            ),
                          )
                          .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
