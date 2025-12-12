
import 'package:ch_movil/screens/pedido_detalle_screen.dart';
import 'package:flutter/material.dart';

// PedidosScreen is now a simple widget to be displayed within MainLayout.
class PedidosScreen extends StatelessWidget {
  const PedidosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // No Scaffold or AppBar. MainLayout provides them.
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: const [
        PedidoCard(
          numeroPedido: '#1023',
          cliente: 'Juan Pérez',
          fecha: '12/12/2025 – 3:45 PM',
          estado: 'Pendiente',
          items: 3,
        ),
        PedidoCard(
          numeroPedido: '#1024',
          cliente: 'Rosa Díaz',
          fecha: '12/12/2025 – 4:00 PM',
          estado: 'En preparación',
          items: 2,
        ),
        PedidoCard(
          numeroPedido: '#1025',
          cliente: 'Luis Gómez',
          fecha: '12/12/2025 – 4:15 PM',
          estado: 'Preparado',
          items: 5,
        ),
      ],
    );
  }
}

class PedidoCard extends StatelessWidget {
  final String numeroPedido;
  final String cliente;
  final String fecha;
  final String estado;
  final int items;

  const PedidoCard({
    super.key,
    required this.numeroPedido,
    required this.cliente,
    required this.fecha,
    required this.estado,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF2C2C2C),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.only(bottom: 16.0),
      child: InkWell(
        // This navigation remains the same, pushing a new full screen
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PedidoDetalleScreen(
                numeroPedido: numeroPedido,
                cliente: cliente,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Pedido $numeroPedido',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                  _buildStatusChip(estado),
                ],
              ),
              const SizedBox(height: 12.0),
              Text(
                'Cliente: $cliente',
                style: const TextStyle(color: Colors.white70, fontSize: 15),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Fecha: $fecha',
                style: const TextStyle(color: Colors.white70, fontSize: 15),
              ),
              const SizedBox(height: 16.0),
              const Divider(color: Colors.white24),
              const SizedBox(height: 12.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$items productos',
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const Row(
                    children: [
                      Text(
                        'Ver Detalle',
                        style: TextStyle(color: Color(0xFF6A82FB), fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward_ios, color: Color(0xFF6A82FB), size: 16),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String estado) {
    Color color;
    Color textColor;

    switch (estado) {
      case 'En preparación':
        color = Colors.orangeAccent.withOpacity(0.2);
        textColor = Colors.orangeAccent;
        break;
      case 'Preparado':
        color = Colors.greenAccent.withOpacity(0.2);
        textColor = Colors.greenAccent;
        break;
      case 'Pendiente':
      default:
        color = Colors.amber.withOpacity(0.2);
        textColor = Colors.amber;
    }

    return Chip(
      label: Text(
        estado,
        style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 12),
      ),
      backgroundColor: color,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
       shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.black.withOpacity(0.1)),
      ),
    );
  }
}
