import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_paystack/flutter_paystack.dart';

class PaymentCheckOutPage extends StatefulWidget {
  const PaymentCheckOutPage({Key? key}) : super(key: key);

  @override
  State<PaymentCheckOutPage> createState() => _PaymentCheckOutPageState();
}

class _PaymentCheckOutPageState extends State<PaymentCheckOutPage> {
  final payStackClient = PaystackPlugin();
  final amountController = TextEditingController();

  void _startPaystack() async {
    await dotenv.load(fileName: '.env');
    String? publicKey = dotenv.env['PUBLIC_KEY'];
    payStackClient.initialize(publicKey: publicKey!);
  }

  final snackBarSuccess = const SnackBar(
    content: Text('Payment Successful, Thanks for your patronage !'),
  );

  final snackBarFailure = const SnackBar(
    content: Text('Payment Unsuccessful, Please Try Again.'),
  );

  final snackBarEmptyPrice = const SnackBar(
    content: Text('Please input the price and try again.'),
  );

  final int amount = 1000;
  final String reference =
      "unique_transaction_ref_${Random().nextInt(1000000)}";

  void _makePayment() async {
    final Charge charge = Charge()
      ..email = 'paystackcustomer@qa.team'
      ..amount = int.parse("${amountController.text}00")
      ..reference = reference;

    final CheckoutResponse response = await payStackClient.checkout(context,
        charge: charge, method: CheckoutMethod.card);

    if (response.status && response.reference == reference) {
      ScaffoldMessenger.of(context).showSnackBar(snackBarSuccess);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(snackBarFailure);
    }
  }

  @override
  void initState() {
    super.initState();
    _startPaystack();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Paystack Integrations Assessment',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CheckOutCard(),
        ],
      ),
    );
  }

  Widget CheckOutSummary() {
    return Padding(
      padding: const EdgeInsets.all(22.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Total: ₦ ${(amount / 100).toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget CheckOutCard() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.all(Radius.circular(3)),
                ),
                child: TextFormField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 5.0,
                      horizontal: 12.0,
                    ),
                    hintText: "20",
                    border: InputBorder.none,
                  ),
                  obscureText: false,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (amountController.text.isNotEmpty) {
                    _makePayment();
                  }
                  ScaffoldMessenger.of(context)
                      .showSnackBar(snackBarEmptyPrice);
                },
                child: const Text(
                  "Make Payment",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
