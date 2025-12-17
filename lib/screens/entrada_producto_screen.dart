
import 'package:flutter/material.dart';
import 'package:ch_movil/models/producto.dart';
import 'package:ch_movil/services/producto_service.dart';

class EntradaProductoScreen extends StatefulWidget {
  final Producto producto;

  const EntradaProductoScreen({Key? key, required this.producto}) : super(key: key);

  @override
  _EntradaProductoScreenState createState() => _EntradaProductoScreenState();
}

class _EntradaProductoScreenState extends State<EntradaProductoScreen> {
  final ProductoService _productoService = ProductoService();
  late List<TextEditingController> _stockControllers;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _stockControllers = List.generate(
      widget.producto.sizes.length,
      (index) => TextEditingController(),
    );
  }

  @override
  void dispose() {
    for (var controller in _stockControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _agregarStock() async {
    final List<Map<String, int>> tallasStock = [];
    for (int i = 0; i < widget.producto.sizes.length; i++) {
      final stockToAdd = int.tryParse(_stockControllers[i].text);
      if (stockToAdd != null && stockToAdd > 0) {
        if (widget.producto.sizes[i].idTalla != null) {
            tallasStock.add({
                "idTalla": widget.producto.sizes[i].idTalla!,
                "stock": stockToAdd,
            });
        }
      }
    }

    if (tallasStock.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se ha ingresado stock para agregar'), backgroundColor: Colors.orange),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Assuming the barcode on the product is the main identifier
      if (widget.producto.codigoBarra == null) {
        throw Exception("El producto no tiene un código de barras válido.");
      }
      await _productoService.agregarStock(widget.producto.codigoBarra!, tallasStock);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Stock actualizado con éxito'), backgroundColor: Colors.green),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar el stock: $e'), backgroundColor: Colors.red),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F1F1F),
      appBar: AppBar(
        title: const Text('Entrada de Producto'),
        backgroundColor: const Color(0xFF1F1F1F),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.producto.nombre,
              style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Código: ${widget.producto.codigoBarra ?? "N/A"}',
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 24),
            const Text(
              'Agregar Stock por Talla',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(color: Colors.white24, height: 20),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.producto.sizes.length,
              itemBuilder: (context, index) {
                final talla = widget.producto.sizes[index];
                return Card(
                  color: const Color(0xFF2C2C2C),
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Talla USA ${talla.usa} / EUR ${talla.eur}',
                                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Stock actual: ${talla.stock}',
                                style: const TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: TextField(
                            controller: _stockControllers[index],
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: 'Añadir',
                              labelStyle: const TextStyle(color: Colors.white54),
                              filled: true,
                              fillColor: const Color(0xFF3B3B3B),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 32),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton.icon(
                    onPressed: _agregarStock,
                    icon: const Icon(Icons.add_shopping_cart),
                    label: const Text('Guardar Entrada'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6A82FB),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
