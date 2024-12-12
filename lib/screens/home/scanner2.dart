import 'package:flutter/material.dart';

class ScannerScreen2 extends StatefulWidget {
  const ScannerScreen2({super.key});

  @override
  State<ScannerScreen2> createState() => _ScannerScreen2State();
}

class _ScannerScreen2State extends State<ScannerScreen2> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          automaticallyImplyLeading: false,
          title: const Row(
            children: [
              Icon(Icons.storefront),
              SizedBox(width: 12.0),
              Text(
                'Mercado Mayorista',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () {
                // showLogoutConfirmation(context);
              },
              icon: const Icon(Icons.exit_to_app),
            ),
          ],
        ),
        body: Column(children: [Expanded(child: _buildInputAndTable())]),
      ),
    );
  }

  Widget _buildInputAndTable() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Input',
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Column 1')),
                DataColumn(label: Text('Column 2')),
                DataColumn(label: Text('Column 3')),
              ],
              rows: const [
                DataRow(
                  cells: [
                    DataCell(Text('Row 1, Col 1')),
                    DataCell(Text('Row 1, Col 2')),
                    DataCell(Text('Row 1, Col 3')),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text('Row 2, Col 1')),
                    DataCell(Text('Row 2, Col 2')),
                    DataCell(Text('Row 2, Col 3')),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
