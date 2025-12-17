
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ch_movil/models/categoria.dart';
import 'package:ch_movil/models/producto.dart';
import 'package:ch_movil/models/talla.dart';
import 'package:ch_movil/services/producto_service.dart';
import 'package:ch_movil/services/categoria_service.dart';
import 'package:ch_movil/services/talla_service.dart';

class NuevoProductoScreen extends StatefulWidget {
  const NuevoProductoScreen({super.key});

  @override
  State<NuevoProductoScreen> createState() => _NuevoProductoScreenState();
}

class _NuevoProductoScreenState extends State<NuevoProductoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _productoService = ProductoService();
  final _categoriaService = CategoriaService();
  final _tallaService = TallaService();

  // Controllers for text fields
  final _codigoBarraController = TextEditingController();
  final _nombreController = TextEditingController();
  final _precioCompraController = TextEditingController();
  final _precioVentaController = TextEditingController();
  final _stockController = TextEditingController();
  final _stockMinimoController = TextEditingController();
  final _mpnController = TextEditingController();
  final _materialController = TextEditingController();
  final _colorController = TextEditingController();
  final _stockTallaController = TextEditingController();

  // State variables
  Categoria? _selectedCategoria;
  String? _selectedMarca;
  int? _selectedUnidadMedida;
  String? _selectedGenero;
  String? _selectedArticulo;
  String? _selectedEstilo;
  Talla? _selectedTalla;
  bool _estado = true;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  // Data from services
  List<Categoria> _categorias = [];
  List<Talla> _tallasDisponibles = [];
  final List<String> _marcas = ['Nike', 'Adidas', 'Puma', 'I-Run', 'Reebok'];
  final List<Map<String, dynamic>> _unidadesMedida = [
    {'id': 1, 'nombre': 'Pieza'},
    {'id': 2, 'nombre': 'Caja'},
    {'id': 3, 'nombre': 'Par'}
  ];
  final List<String> _generos = ['Masculino', 'Femenino', 'Unisex'];
  final List<String> _articulos = ['Zapatillas', 'Sandalias', 'Botas', 'Zapatos'];
  final List<String> _estilos = ['Casual', 'Urbano', 'Deportivo', 'Fiesta'];

  final List<SizeWithStock> _tallasSeleccionadas = [];
  bool _isLoading = false;
  bool _isDataLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    try {
      final categorias = await _categoriaService.getAll();
      final tallas = await _tallaService.getTallas();
      setState(() {
        _categorias = categorias;
        _tallasDisponibles = tallas;
        _isDataLoading = false;
      });
    } catch (e) {
      setState(() {
        _isDataLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar datos iniciales: $e'), backgroundColor: Colors.red),
      );
    }
  }

  void _guardarProducto() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final producto = Producto(
        codigoBarra: _codigoBarraController.text,
        nombre: _nombreController.text,
        idCategoria: _selectedCategoria?.idCategoria,
        marca: _selectedMarca,
        precioCompra: double.tryParse(_precioCompraController.text),
        precioVenta: double.parse(_precioVentaController.text),
        stock: int.parse(_stockController.text),
        stockMinimo: int.tryParse(_stockMinimoController.text),
        idUnidadMedida: _selectedUnidadMedida,
        estado: _estado,
        genero: _selectedGenero,
        articulo: _selectedArticulo,
        estilo: _selectedEstilo,
        mpn: _mpnController.text,
        material: _materialController.text,
        color: _colorController.text,
        sizes: _tallasSeleccionadas,
        imagen: _selectedImage,
      );

      try {
        if (producto.imagen != null) {
          await _productoService.crearProductoConArchivo(producto, producto.imagen!);
        } else {
          await _productoService.crearProducto(producto);
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Producto guardado con éxito'), backgroundColor: Colors.green),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar el producto: $e'), backgroundColor: Colors.red),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  
  void _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _agregarTalla() {
    if (_selectedTalla != null && _stockTallaController.text.isNotEmpty) {
      final stock = int.tryParse(_stockTallaController.text);
      if (stock != null && stock > 0) {
        final existingIndex = _tallasSeleccionadas.indexWhere((t) => t.idTalla == _selectedTalla!.idTalla);
        
        if (existingIndex != -1) {
          setState(() {
            _tallasSeleccionadas[existingIndex].stock += stock;
          });
        } else {
          setState(() {
            _tallasSeleccionadas.add(SizeWithStock(
              idTalla: _selectedTalla!.idTalla,
              usa: _selectedTalla!.usa,
              eur: _selectedTalla!.eur,
              cm: _selectedTalla!.cm,
              stock: stock,
            ));
          });
        }
        _stockTallaController.clear();
        setState(() {
          _selectedTalla = null;
        });
      }
    }
  }

  void _eliminarTalla(int index) {
    setState(() {
      _tallasSeleccionadas.removeAt(index);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F1F1F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F1F1F),
        elevation: 0,
        title: const Text('Registrar Nuevo Producto'),
      ),
      body: _isDataLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                children: [
                  _buildSectionTitle('Información Básica'),
                  _buildTextField(controller: _codigoBarraController, label: 'Código de Barra', icon: Icons.qr_code_scanner, readOnly: true),
                  _buildTextField(controller: _nombreController, label: 'Nombre del Producto', validator: (v) => v!.isEmpty ? 'Campo requerido' : null),
                  _buildDropdown<Categoria>(label: 'Categoría', value: _selectedCategoria, items: _categorias, onChanged: (v) => setState(() => _selectedCategoria = v), itemText: (c) => c.descripcion),
                  _buildDropdown<String>(label: 'Marca', value: _selectedMarca, items: _marcas, onChanged: (v) => setState(() => _selectedMarca = v)),
                  
                  const SizedBox(height: 16),
                  _buildSectionTitle('Precios y Stock'),
                  _buildTextField(controller: _precioCompraController, label: 'Precio de Compra', keyboardType: TextInputType.number),
                  _buildTextField(controller: _precioVentaController, label: 'Precio de Venta', keyboardType: TextInputType.number, validator: (v) => v!.isEmpty ? 'Campo requerido' : null),
                  _buildTextField(controller: _stockController, label: 'Stock Disponible', keyboardType: TextInputType.number, validator: (v) => v!.isEmpty ? 'Campo requerido' : null),
                  _buildTextField(controller: _stockMinimoController, label: 'Stock Mínimo', keyboardType: TextInputType.number),
                  _buildDropdown<int>(label: 'Unidad de Medida', value: _selectedUnidadMedida, items: _unidadesMedida.map((u) => u['id'] as int).toList(), onChanged: (v) => setState(() => _selectedUnidadMedida = v), itemText: (id) => _unidadesMedida.firstWhere((u) => u['id'] == id)['nombre'] as String),

                  const SizedBox(height: 16),
                  _buildSectionTitle('Atributos del Producto'),
                  _buildDropdown<String>(label: 'Género', value: _selectedGenero, items: _generos, onChanged: (v) => setState(() => _selectedGenero = v)),
                  _buildDropdown<String>(label: 'Artículo', value: _selectedArticulo, items: _articulos, onChanged: (v) => setState(() => _selectedArticulo = v)),
                  _buildDropdown<String>(label: 'Estilo', value: _selectedEstilo, items: _estilos, onChanged: (v) => setState(() => _selectedEstilo = v)),
                  _buildTextField(controller: _mpnController, label: 'MPN (Número de Pieza del Fabricante)'),
                  _buildTextField(controller: _materialController, label: 'Material', hint: 'Ej: Cuero, Sintético'),
                  _buildTextField(controller: _colorController, label: 'Color', hint: 'Ej: Negro / Blanco'),
                  _buildFileUploadField(),
                  _buildStatusSwitch(),
                  _buildShippingInfo(),

                  const SizedBox(height: 16),
                  _buildTallasSection(),

                  const SizedBox(height: 32),
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6A82FB),
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          ),
                          onPressed: _guardarProducto,
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

  Widget _buildTextField({required TextEditingController controller, required String label, String? hint, IconData? icon, TextInputType keyboardType = TextInputType.text, bool readOnly = false, String? Function(String?)? validator}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
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
          errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.redAccent)),
          focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.redAccent, width: 2)),
          suffixIcon: icon != null ? Icon(icon, color: Colors.white54) : null,
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildDropdown<T>({required String label, required T? value, required List<T> items, required void Function(T?) onChanged, String Function(T)? itemText}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: DropdownButtonFormField<T>(
        value: value,
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
        items: items.map((T item) {
          return DropdownMenuItem<T>(value: item, child: Text(itemText != null ? itemText(item) : item.toString()));
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildFileUploadField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: InkWell(
        onTap: _pickImage,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: const Color(0xFF2C2C2C), borderRadius: BorderRadius.circular(10)),
          child: Row(
            children: [
              Icon(_selectedImage != null ? Icons.check_circle : Icons.photo_camera_outlined, color: _selectedImage != null ? Colors.greenAccent : Colors.white54),
              const SizedBox(width: 12),
              const Text('Foto del Producto', style: TextStyle(color: Colors.white70, fontSize: 16)),
              const Spacer(),
              Text(_selectedImage != null ? '1 archivo seleccionado' : 'Sin archivos', style: const TextStyle(color: Colors.white38)),
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
        title: Text('Estado: ${_estado ? "Activo" : "Inactivo"}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
        value: _estado,
        onChanged: (bool value) => setState(() => _estado = value),
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
    return Card(
      color: const Color(0xFF2C2C2C),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildDropdown<Talla>(label: 'Seleccione Talla', value: _selectedTalla, items: _tallasDisponibles, onChanged: (v) => setState(() => _selectedTalla = v), itemText: (t) => 'USA ${t.usa} - EUR ${t.eur} - CM ${t.cm}'),
            _buildTextField(controller: _stockTallaController, label: 'Stock para esta Talla', keyboardType: TextInputType.number),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 44)),
              onPressed: _agregarTalla,
              icon: const Icon(Icons.add_circle_outline),
              label: const Text('Agregar Talla'),
            ),
            const Divider(height: 24, color: Colors.white24),
            const Text('Tallas Agregadas', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            _tallasSeleccionadas.isEmpty
              ? const Center(child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('No hay tallas agregadas', style: TextStyle(color: Colors.white54, fontStyle: FontStyle.italic)),
                ))
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _tallasSeleccionadas.length,
                  itemBuilder: (context, index) {
                    final talla = _tallasSeleccionadas[index];
                    return Card(
                      color: const Color(0xFF3B3B3B),
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        title: Text('USA ${talla.usa} - EUR ${talla.eur}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        subtitle: Text('Stock: ${talla.stock}', style: const TextStyle(color: Colors.white70)),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                          onPressed: () => _eliminarTalla(index),
                        ),
                      ),
                    );
                  },
                ),
          ],
        ),
      ),
    );
  }
}
