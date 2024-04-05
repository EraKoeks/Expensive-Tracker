import 'package:expense_tracker/widget/expenses_list/expenses_list.dart';
import 'package:expense_tracker/widget/new_expense.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widget/chart/chart.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
      title: 'Benzine',
      amount: 30.00,
      date: DateTime.now(),
      category: Category.work,
    ),
    Expense(
      title: 'Boodschappen',
      amount: 29.95,
      date: DateTime.now(),
      category: Category.food,
    ),
  ];

void _openAddExpenseOverlay() {
  showModalBottomSheet(
    useSafeArea: true,
    isScrollControlled: true,
    context: context,
    builder: (ctx) => NewExpense(onAddExpense: _addExpense),
  );
}

void _addExpense(Expense expense) {
  setState(() {
    _registeredExpenses.add(expense);
  });
}

void _removeExpense(Expense expense) {
  final expenseIndex = _registeredExpenses.indexOf(expense);
  setState(() {
    _registeredExpenses.remove(expense);
  });
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(
        duration: const Duration(seconds: 3),
          content: const Text('Expense deleted'),
        action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              setState(() {
                _registeredExpenses.insert(expenseIndex, expense);
              });

        }),
      ),
  );

}

  @override
  Widget build(BuildContext context) {
  Widget mainContent = const Center(
    child: Text('No expenses found. Start adding some!'),
  );

  if (_registeredExpenses.isNotEmpty) {
    mainContent = ExpensesList(
      expenses: _registeredExpenses,
      onRemoveExpense: _removeExpense,
    );
  }


    return Scaffold(
      appBar: AppBar(
        title: const Text('ExpenseTracker',
        style: TextStyle(
          letterSpacing: 2,
          fontSize: 18
        ),),
        backgroundColor: const Color.fromARGB(255, 144, 93, 155),

        actions: [
            IconButton(onPressed: _openAddExpenseOverlay,
              icon: const Icon(Icons.add_rounded, size: 35),
            ),
        ],
      ),
      body: Column(
        children: [
          Chart(expenses: _registeredExpenses),
          //),
          Expanded(
            child: mainContent,
          ),
        ],
      ),
    );
  }
}
