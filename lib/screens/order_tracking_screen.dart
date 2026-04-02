import 'package:flutter/material.dart';
import '../models/order_model.dart';

class OrderTrackingScreen extends StatelessWidget {
  final Order order;

  const OrderTrackingScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Order Tracking")),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            /// 🔹 ORDER ID
            Text(
              "Order Status",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            /// 🔥 TIMELINE
            _buildStep("Processing", Icons.access_time, order.status),
            _buildStep("Shipped", Icons.local_shipping, order.status),
            _buildStep("Out for Delivery", Icons.delivery_dining, order.status),
            _buildStep("Delivered", Icons.check_circle, order.status),
          ],
        ),
      ),
    );
  }

  /// 🔥 STEP BUILDER
  Widget _buildStep(String step, IconData icon, String currentStatus) {
    bool isCompleted = _getStepIndex(step) <= _getStepIndex(currentStatus);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [

        /// ICON + LINE
        Column(
          children: [
            Icon(
              icon,
              color: isCompleted ? Colors.green : Colors.grey,
            ),

            Container(
              width: 2,
              height: 40,
              color: Colors.grey.shade300,
            ),
          ],
        ),

        const SizedBox(width: 10),

        /// TEXT
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              step,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isCompleted ? Colors.green : Colors.grey,
              ),
            ),
            const SizedBox(height: 5),
          ],
        ),
      ],
    );
  }

  /// 🔥 STATUS ORDER
  int _getStepIndex(String status) {
    switch (status) {
      case "Processing":
        return 0;
      case "Shipped":
        return 1;
      case "Out for Delivery":
        return 2;
      case "Delivered":
        return 3;
      default:
        return 0;
    }
  }
}