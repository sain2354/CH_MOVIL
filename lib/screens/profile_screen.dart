
import 'package:flutter/material.dart';

// ProfileScreen es un widget simple que se muestra dentro del MainLayout.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Usamos un ListView para que el contenido sea scrollable si excede la pantalla.
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      children: [
        // --- ENCABEZADO CON FOTO Y NOMBRE ---
        _buildProfileHeader(),
        const SizedBox(height: 32.0),

        // --- SECCIÓN DE CUENTA ---
        const _SectionTitle(title: 'CUENTA'),
        _buildOptionCard(
          icon: Icons.person_outline,
          title: 'Editar Perfil',
          subtitle: 'Cambia tu nombre, foto, etc.',
          onTap: () { /* TODO: Navegar a pantalla de edición */ },
        ),
        
        const SizedBox(height: 24.0),

        // --- SECCIÓN DE CONFIGURACIÓN ---
        const _SectionTitle(title: 'CONFIGURACIÓN'),
        _buildOptionCard(
          icon: Icons.notifications_outlined,
          title: 'Notificaciones',
          subtitle: 'Administra los avisos de la app',
          onTap: () { /* TODO: Navegar a pantalla de notificaciones */ },
        ),
        _buildOptionCard(
          icon: Icons.palette_outlined,
          title: 'Apariencia',
          subtitle: 'Personaliza la interfaz de la app',
          onTap: () { /* TODO: Navegar a pantalla de apariencia */ },
        ),
        const SizedBox(height: 32.0),

        // --- BOTÓN DE CERRAR SESIÓN ---
        _buildLogoutButton(context),
      ],
    );
  }

  // Widget para el encabezado del perfil
  Widget _buildProfileHeader() {
    return Column(
      children: [
        const CircleAvatar(
          radius: 50,
          backgroundColor: Color(0xFF2C2C2C),
          backgroundImage: AssetImage('assets/avatar.png'), // Asegúrate de tener un avatar de ejemplo
          child: Text(''), // Placeholder para que la imagen se muestre
        ),
        const SizedBox(height: 16.0),
        const Text(
          'Carlos Villegas', // Nombre de ejemplo
          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4.0),
        const Text(
          'Personal de Almacén', // Rol de ejemplo
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
      ],
    );
  }

  // Widget reutilizable para cada opción en la lista
  Widget _buildOptionCard({required IconData icon, required String title, required String subtitle, required VoidCallback onTap}) {
    return Card(
      color: const Color(0xFF2C2C2C),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.only(bottom: 12.0),
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        leading: Icon(icon, color: const Color(0xFF6A82FB), size: 28),
        title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        subtitle: Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 13)),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
      ),
    );
  }

  // Widget para los títulos de sección
  Widget _buildLogoutButton(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF2C2C2C),
        foregroundColor: Colors.redAccent,
        padding: const EdgeInsets.symmetric(vertical: 14.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
        elevation: 0,
      ),
      onPressed: () {
        // TODO: Lógica para cerrar sesión
      },
      icon: const Icon(Icons.logout, size: 20),
      label: const Text('Cerrar Sesión', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }
}

// Widget interno para los títulos de las secciones (CUENTA, CONFIGURACIÓN)
class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, bottom: 12.0),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 13,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}
