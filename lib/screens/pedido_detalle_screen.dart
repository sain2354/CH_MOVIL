
import 'package:ch_movil/screens/scanner_screen.dart';
import 'package:flutter/material.dart';

class PedidoDetalleScreen extends StatelessWidget {
  final String numeroPedido;
  final String cliente;

  const PedidoDetalleScreen({
    super.key,
    required this.numeroPedido,
    required this.cliente,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F1F1F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F1F1F),
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Pedido $numeroPedido'),
            Text(
              'Cliente: $cliente',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
        children: const [
          ProductoCard(
            imagenUrl: 'assets/nike_air_max.png', 
            nombre: 'Nike Air Max 2024',
            talla: '42',
            cantidadPedida: 2,
            cantidadPreparada: 1,
            estado: 'En preparación',
          ),
          ProductoCard(
            imagenUrl: 'assets/adidas_run_falcon.png',
            nombre: 'Adidas Run Falcon',
            talla: '40',
            cantidadPedida: 1,
            cantidadPreparada: 0,
            estado: 'Pendiente',
          ),
           ProductoCard(
            imagenUrl: 'assets/producto_x.png',
            nombre: 'Otro producto de prueba',
            talla: '38',
            cantidadPedida: 3,
            cantidadPreparada: 3,
            estado: 'Producto listo',
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomButton(),
    );
  }

  Widget _buildBottomButton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      decoration: const BoxDecoration(
        color: Color(0xFF1F1F1F),
        boxShadow: [
          BoxShadow(
            color: Colors.black38,
            blurRadius: 15,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6A82FB),
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        onPressed: () {
          // TODO: Implementar lógica para marcar el pedido como preparado
        },
        child: const Text(
          'Marcar Pedido como Preparado',
          style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}


class ProductoCard extends StatelessWidget {
  final String imagenUrl;
  final String nombre;
  final String talla;
  final int cantidadPedida;
  final int cantidadPreparada;
  final String estado;

  const ProductoCard({
    super.key,
    required this.imagenUrl,
    required this.nombre,
    required this.talla,
    required this.cantidadPedida,
    required this.cantidadPreparada,
    required this.estado,
  });

  @override
  Widget build(BuildContext context) {
    final bool isCompleted = cantidadPreparada >= cantidadPedida;

    return Card(
      color: const Color(0xFF2C2C2C),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.only(bottom: 12.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // --- INFO PRINCIPAL: IMAGEN Y DETALLES ---
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    imagenUrl,
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 70,
                        height: 70,
                        color: Colors.black26,
                        child: const Icon(Icons.image_not_supported_outlined, color: Colors.white38, size: 35),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nombre,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        'Talla: $talla',
                        style: const TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                      const SizedBox(height: 6.0),
                      Text(
                        'Cant: $cantidadPreparada / $cantidadPedida',
                        style: TextStyle(
                          color: isCompleted ? Colors.greenAccent : Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // --- SECCIÓN DE ESTADO ---
            Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 4.0),
              child: Divider(color: Colors.white.withOpacity(0.15)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Estado del producto',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                _buildStatusChip(estado),
              ],
            ),

            // --- BOTÓN DE ESCANEAR (si es necesario) ---
            if (!isCompleted)
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6A82FB).withOpacity(0.15),
                    foregroundColor: const Color(0xFF8A9EFF),
                    minimumSize: const Size(double.infinity, 44),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(color: Color(0xFF6A82FB), width: 1.5),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ScannerScreen()),
                    );
                  },
                  icon: const Icon(Icons.qr_code_scanner, size: 18),
                  label: const Text('Escanear Producto', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String estado) {
    Color color;
    Color textColor;
    IconData icon;

    switch (estado) {
      case 'En preparación':
        color = Colors.orangeAccent.withOpacity(0.2);
        textColor = Colors.orangeAccent;
        icon = Icons.hourglass_top_rounded;
        break;
      case 'Producto listo':
        color = Colors.greenAccent.withOpacity(0.2);
        textColor = Colors.greenAccent;
        icon = Icons.check_circle_rounded;
        break;
      case 'Pendiente':
      default:
        color = Colors.amber.withOpacity(0.2);
        textColor = Colors.amber;
        icon = Icons.warning_amber_rounded;
    }

    return Chip(
      avatar: Icon(icon, color: textColor, size: 16),
      label: Text(
        estado,
        style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 12),
      ),
      backgroundColor: color,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.black.withOpacity(0.1)),
      ),
    );
  }
}
