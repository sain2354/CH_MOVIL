
import 'package:ch_movil/screens/nuevo_producto_screen.dart';
import 'package:flutter/material.dart';

// HomeScreen is now a simple widget, not a full screen with Scaffold.
// It receives a callback function to notify MainLayout to change the view.
class HomeScreen extends StatelessWidget {
  final VoidCallback onShowPedidos;

  const HomeScreen({super.key, required this.onShowPedidos});

  @override
  Widget build(BuildContext context) {
    // No Scaffold, no AppBar here. The parent (MainLayout) provides them.
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildHeader(),
        const SizedBox(height: 24),
        _buildStockCard(),
        const SizedBox(height: 24),
        _buildSummaryAndAlertsCard(),
        const SizedBox(height: 24),
        _buildActionsGrid(context),
      ],
    );
  }

  Widget _buildHeader() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Inventario General',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Resumen de Almacén',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildStockCard() {
    return Card(
      color: const Color(0xFF2C2C2C),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: const Padding(
        padding: EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'STOCK TOTAL:',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '25,340',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'pares',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
            Icon(Icons.bar_chart, color: Colors.white, size: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryAndAlertsCard() {
    return Card(
      color: const Color(0xFF2C2C2C),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryItem(count: '8', label: 'PENDIENTES', color: Colors.orangeAccent),
                _buildSummaryItem(count: '15', label: 'ENTRADAS HOY', color: Colors.greenAccent),
                _buildSummaryItem(count: '22', label: 'SALIDAS HOY', color: Colors.lightBlueAccent),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(color: Colors.white24, indent: 10, endIndent: 10),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                'Alertas de Stock',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildStockAlertItem(
              icon: Icons.warning_amber_rounded,
              text: 'Zapatilla Runner: Talla 42 bajo stock (3 pares)',
            ),
            const SizedBox(height: 12),
            _buildStockAlertItem(
              icon: Icons.error_outline,
              text: 'Bota Clásica: Talla 38 agotada',
              iconColor: Colors.redAccent,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem({required String count, required String label, required Color color}) {
    return Column(
      children: [
        Text(
          count,
          style: TextStyle(
            color: color,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 11,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildStockAlertItem({required IconData icon, required String text, Color iconColor = Colors.yellowAccent}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionsGrid(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GridView.count(
          crossAxisCount: constraints.maxWidth > 600 ? 4 : 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.5,
          children: [
            // This button now navigates to the new product form
            _buildActionCard(context: context, icon: Icons.file_download_outlined, text: 'Entradas', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const NuevoProductoScreen()))),
            _buildActionCard(context: context, icon: Icons.inventory_2_outlined, text: 'Ver Inventario', onTap: () => Navigator.pushNamed(context, '/inventario')),
            _buildActionCard(context: context, icon: Icons.list_alt_rounded, text: 'Pedidos', onTap: onShowPedidos),
            _buildActionCard(context: context, icon: Icons.assessment_outlined, text: 'Reportes', onTap: () => Navigator.pushNamed(context, '/reportes')),
          ],
        );
      },
    );
  }

  Widget _buildActionCard({required BuildContext context, required IconData icon, required String text, required VoidCallback onTap}) {
    return Card(
      color: const Color(0xFF2C2C2C),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: onTap, // Use the provided onTap callback
        borderRadius: BorderRadius.circular(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 30),
            const SizedBox(height: 12),
            Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
