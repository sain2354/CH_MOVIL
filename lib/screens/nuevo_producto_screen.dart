
import 'package:flutter/material.dart';

class NuevoProductoScreen extends StatefulWidget {
  const NuevoProductoScreen({super.key});

  @override
  State<NuevoProductoScreen> createState() => _NuevoProductoScreenState();
}

class _NuevoProductoScreenState extends State<NuevoProductoScreen> {
  final _formKey = GlobalKey<FormState>();
  // TODO: Add controllers and variables for state management

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F1F1F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F1F1F),
        elevation: 0,
        title: const Text('Registrar Nuevo Producto'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          children: [
            _buildSectionTitle('Información Básica'),
            _buildTextField(label: 'Código de Barra', initialValue: '3521197130822', icon: Icons.qr_code_scanner),
            _buildTextField(label: 'Nombre del Producto'),
            _buildDropdown(label: 'Categoría (Marca)', items: ['Nike', 'Adidas', 'Puma']),
            _buildDropdown(label: 'Subcategoría', items: ['Running', 'Casual', 'Fútbol']),
            
            const SizedBox(height: 16),
            _buildSectionTitle('Precios y Stock'),
            _buildTextField(label: 'Precio de Compra', keyboardType: TextInputType.number),
            _buildTextField(label: 'Precio de Venta', keyboardType: TextInputType.number),
            _buildTextField(label: 'Stock Disponible', keyboardType: TextInputType.number),
            _buildTextField(label: 'Stock Mínimo', keyboardType: TextInputType.number),
            _buildDropdown(label: 'Unidad de Medida', items: ['Par', 'Unidad']),

            const SizedBox(height: 16),
            _buildSectionTitle('Atributos del Producto'),
            _buildDropdown(label: 'Género', items: ['Hombre', 'Mujer', 'Unisex']),
            _buildDropdown(label: 'Artículo', items: ['Zapatilla', 'Bota', 'Sandalia']),
            _buildDropdown(label: 'Estilo', items: ['Deportivo', 'Urbano']),
            _buildTextField(label: 'MPN (Número de Pieza del Fabricante)'),
            _buildTextField(label: 'Material', hint: 'Ej: Cuero, Sintético'),
            _buildTextField(label: 'Color', hint: 'Ej: Negro / Blanco'),
            _buildFileUploadField(),
            _buildStatusSwitch(),
            _buildShippingInfo(),

            const SizedBox(height: 16),
            _buildSectionTitle('Gestión de Tallas'),
            _buildTallasSection(),

            const SizedBox(height: 32),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6A82FB),
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              onPressed: () {
                // TODO: Validate and save product
              },
              child: const Text('Guardar Producto', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGETS REUTILIZABLES PARA EL FORMULARIO ---

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0, top: 8.0),
      child: Text(title.toUpperCase(), style: const TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
    );
  }

  Widget _buildTextField({required String label, String? initialValue, String? hint, IconData? icon, TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        initialValue: initialValue,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          labelStyle: const TextStyle(color: Colors.white70),
          hintStyle: const TextStyle(color: Colors.white38),
          filled: true,
          fillColor: const Color(0xFF2C2C2C),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF6A82FB))),
          suffixIcon: icon != null ? Icon(icon, color: Colors.white54) : null,
        ),
        // validator: (value) { ... },
      ),
    );
  }

  Widget _buildDropdown({required String label, required List<String> items}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          filled: true,
          fillColor: const Color(0xFF2C2C2C),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
        ),
        dropdownColor: const Color(0xFF2C2C2C),
        style: const TextStyle(color: Colors.white),
        hint: Text('-- Seleccionar --', style: TextStyle(color: Colors.white.withOpacity(0.7))),
        items: items.map((String value) {
          return DropdownMenuItem<String>(value: value, child: Text(value));
        }).toList(),
        onChanged: (newValue) {
          // TODO: Handle state change
        },
        // validator: (value) { ... },
      ),
    );
  }

  Widget _buildFileUploadField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: InkWell(
        onTap: () { /* TODO: File picker logic */ },
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: const Color(0xFF2C2C2C), borderRadius: BorderRadius.circular(10)),
          child: const Row(
            children: [
              Icon(Icons.photo_camera_outlined, color: Colors.white54),
              SizedBox(width: 12),
              Text('Foto del Producto', style: TextStyle(color: Colors.white70, fontSize: 16)),
              Spacer(),
              Text('Sin archivos', style: TextStyle(color: Colors.white38)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusSwitch() {
    return Card(
      color: const Color(0xFF2C2C2C),
      margin: const EdgeInsets.only(bottom: 12.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: SwitchListTile(
        title: const Text('Estado: Activo', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
        value: true, // TODO: manage state
        onChanged: (bool value) { /* TODO: manage state */ },
        activeColor: Colors.greenAccent,
      ),
    );
  }

  Widget _buildShippingInfo() {
    return Card(
      color: const Color(0xFF2C2C2C),
      margin: const EdgeInsets.only(bottom: 12.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: const ListTile(
        leading: Icon(Icons.local_shipping_outlined, color: Colors.white54),
        title: Text('Envío', style: TextStyle(color: Colors.white)),
        subtitle: Text('Precio de delivery no incluido', style: TextStyle(color: Colors.white70, fontSize: 13)),
      ),
    );
  }

  Widget _buildTallasSection() {
    // This is a complex widget, will need its own state management
    return Card(
      color: const Color(0xFF2C2C2C),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            _buildDropdown(label: 'Seleccione Talla', items: ['38', '39', '40', '41', '42', '43']),
            _buildTextField(label: 'Stock para esta Talla', keyboardType: TextInputType.number),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 44)),
              onPressed: () { /* TODO: Add talla to list */ },
              icon: const Icon(Icons.add_circle_outline),
              label: const Text('Agregar Talla'),
            ),
            const Divider(height: 24, color: Colors.white24),
            const Text('Tallas Agregadas', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            // TODO: Replace with a DataTable or a ListView.builder for dynamic tallas
            const Center(child: Text('No hay tallas agregadas', style: TextStyle(color: Colors.white54, fontStyle: FontStyle.italic))),
          ],
        ),
      ),
    );
  }
}
