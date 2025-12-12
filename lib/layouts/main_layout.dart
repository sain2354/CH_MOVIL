
import 'package:ch_movil/screens/pedidos_screen.dart';
import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/scanner_screen.dart';
import '../screens/profile_screen.dart';

// Enum to manage the main views inside the layout
enum MainView { home, pedidos }

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _bottomNavIndex = 0;
  bool _isScannerMenuVisible = false;
  
  // State for the body content
  MainView _currentView = MainView.home;

  // --- Navigation Methods ---
  void _onBottomNavItemTapped(int index) {
    if (index == 1) { // Scanner button
      setState(() {
        _isScannerMenuVisible = !_isScannerMenuVisible;
      });
    } else {
      // If we are on a different screen, first go back to home view
      if (_currentView != MainView.home) {
        setState(() {
          _currentView = MainView.home;
        });
      }
      
      setState(() {
        // Adjust index for the actual screens (0 -> Home, 2 -> Profile)
        _bottomNavIndex = (index > 1) ? index - 1 : index;
        _isScannerMenuVisible = false; 
      });
    }
  }

  // Callback for children to request showing the Pedidos view
  void _showPedidos() {
    setState(() {
      _currentView = MainView.pedidos;
    });
  }
  
  // Method to go back to the home view
  void _goBackToHome() {
    setState(() {
      _currentView = MainView.home;
    });
  }

  // --- Build Methods ---
  @override
  Widget build(BuildContext context) {
    // The list of main screens for the bottom navigation
    final List<Widget> mainScreens = <Widget>[
      HomeScreen(onShowPedidos: _showPedidos), 
      const ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF1F1F1F),
      appBar: _buildAppBar(),
      body: _buildBody(mainScreens),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: _isScannerMenuVisible
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ScannerScreen()));
              },
              label: const Text('Entrada de producto'),
              icon: const Icon(Icons.arrow_upward),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  PreferredSizeWidget _buildAppBar() {
    // The AppBar changes based on the current view
    if (_currentView == MainView.pedidos) {
      return AppBar(
        backgroundColor: const Color(0xFF1F1F1F),
        elevation: 0,
        // Back button to return to the home screen view
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: _goBackToHome,
        ),
        title: const Text('Pedidos Pendientes'),
      );
    }
    
    // Default AppBar for HomeScreen and others
    return AppBar(
      backgroundColor: const Color(0xFF1F1F1F),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.menu, color: Colors.white),
        onPressed: () { /* TODO: Drawer logic */ },
      ),
      title: Image.asset(
        'assets/images/pantallaprincipal-logo.png',
        height: 45,
        fit: BoxFit.contain,
      ),
      centerTitle: true,
    );
  }

  Widget _buildBody(List<Widget> mainScreens) {
    // The body also changes based on the view
    switch (_currentView) {
      case MainView.pedidos:
        return const PedidosScreen();
      case MainView.home:
      default:
        // Use IndexedStack to keep state of HomeScreen and ProfileScreen
        return IndexedStack(
          index: _bottomNavIndex,
          children: mainScreens,
        );
    }
  }
  
  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner),
            label: 'Escanear',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
        // The selected item is only visually updated for Home and Profile
        currentIndex: _currentView == MainView.home 
                      ? ((_bottomNavIndex >= 1) ? _bottomNavIndex + 1: _bottomNavIndex)
                      : 0, // Highlight "Home" when in a subsection like Pedidos
        selectedItemColor: const Color(0xFF6A82FB),
        unselectedItemColor: Colors.grey,
        onTap: _onBottomNavItemTapped,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
      );
  }
}
