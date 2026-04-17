import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/setting_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {

    // Accessing the settings provider so we can read and update values
    final settings = Provider.of<SettingProvider>(context);

    final goalController =
        TextEditingController(text: settings.savingsGoal.toString());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            // Toggle for dark mode
            SwitchListTile(
              title: const Text("Dark Mode"),
              value: settings.darkMode,
              onChanged: (value) {
                // Updates the value in provider + saves it
                settings.setDarkMode(value);
              },
            ),

            // Toggle for notifications
            SwitchListTile(
              title: const Text("Enable Notifications"),
              value: settings.notificationsEnabled,
              onChanged: (value) {
                // Updates notification setting
                settings.setNotifications(value);
              },
            ),

            const SizedBox(height: 20),

            // NEW: currency dropdown
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Currency",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

            DropdownButton<String>(
              value: settings.currency,
              isExpanded: true,
              items: const [
                DropdownMenuItem(value: "£", child: Text("GBP (£)")),
                DropdownMenuItem(value: "\$", child: Text("USD (\$)")),
                DropdownMenuItem(value: "€", child: Text("EUR (€)")),
              ],
              onChanged: (value) {
                if (value != null) {
                  settings.setCurrency(value);
                }
              },
            ),

            const SizedBox(height: 20),

            // NEW: savings goal input
            TextField(
              controller: goalController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Savings Goal",
                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) {
                final goal = double.tryParse(value);
                if (goal != null) {
                  settings.setGoal(goal);
                }
              },
            ),

            const SizedBox(height: 20),

            // NEW: savings jar display
            LinearProgressIndicator(
              value: settings.savingsGoal == 0
                  ? 0
                  : settings.savingsAmount / settings.savingsGoal,
            ),

            const SizedBox(height: 8),

            Text(
              "Saved: ${settings.currency}${settings.savingsAmount.toStringAsFixed(2)} / ${settings.currency}${settings.savingsGoal}",
            ),

            const SizedBox(height: 10),

            // button to add money to savings
            ElevatedButton(
              onPressed: () {
                settings.addSavings(10); // simple demo (£10 each tap)
              },
              child: const Text("Add £10 to Savings"),
            ),

          ],
        ),
      ),
    );
  }
}