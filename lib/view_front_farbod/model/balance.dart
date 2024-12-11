class Balance {
  final String name;
  final String balance;

  Balance({required this.name, required this.balance});

  factory Balance.fromMap(Map<String, dynamic> map) {
    return Balance(
      name: map['name'] ?? 'Unknown',
      balance: map['balance'] ?? '0',
    );
  }
}
