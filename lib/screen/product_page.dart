import 'package:flutter/material.dart';
import 'checkout_page.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int _quantity = 1;
  final double _price = 50.99;

  @override
  Widget build(BuildContext context) {

    final total = _price* _quantity;
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: const Text('Shop')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
                height: 220,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 220,
                  color: Colors.grey[800],
                  child: const Icon(
                    Icons.headphones,
                    size: 80,
                    color: Colors.white54,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 50),
            const Text(
              'Wireless Headphones',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ), // Text
            const SizedBox(height: 8),
            Text(
              '₱${_price.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 20, color: Colors.greenAccent),
            ), // Text
            const SizedBox(height: 12),
            Text(
              'Premium noise-cancelling wireless headphone with 1000-hour battery life hehe.',
              style: TextStyle(fontSize: 14, color: Colors.grey[400]),
            ), // Text
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton.filled(
                  onPressed: _quantity > 1
                      ? () => setState(() => _quantity--)
                      : null,
                  icon: const Icon(Icons.remove),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.grey[800],
                    disabledBackgroundColor: Colors.grey[900],
                  ),
                ), // IconButton.filled
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    '$_quantity',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ), // TextStyle
                  ), // Text
                ), // Padding
                IconButton(
                  onPressed: () => setState(() => _quantity++),
                  icon: const Icon(Icons.add),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                  ),
                ), // IconButton
              ],
            ), // Row
            const SizedBox(height: 30),
            Center(
              child: Text(
                'Total: ₱${total.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 26, color: Colors.white70),
              ), // Text
            ), // Center
            const Spacer(),
            
            ElevatedButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CheckoutPage(
                    productName: 'Wireless Headphones',
                    price: _price,
                    quantity: _quantity,
                  ),
                ), // MaterialPageRoute
              ),
              icon: const Icon(Icons.shopping_cart),
              label: Text(
                'Buy Now - ₱${total.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 16),
              ), // Text
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
