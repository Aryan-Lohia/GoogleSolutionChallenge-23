import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import 'peroid.dart';
import 'period_data.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final _periodData = PeriodData();
  late final ValueNotifier<List<Period>> _selectedPeriods;
  late final ValueNotifier<DateTime> _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedPeriods = ValueNotifier(_periodData.periods);
    _selectedDay = ValueNotifier(DateTime.now());
    _periodData.load().then((_) {
      _selectedPeriods.value = _periodData.periods;
    });
  }

  @override
  void dispose() {
    _selectedPeriods.dispose();
    _selectedDay.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    _selectedDay.value = selectedDay;
  }

  void _onPeriodsChanged() {
    _selectedPeriods.value = _periodData.periods;
  }

  void _showAddPeriodDialog(BuildContext context) {
    final startDateController = TextEditingController();
    final endDateController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Period'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: startDateController,
                decoration: InputDecoration(
                  labelText: 'Start Date',
                ),
                keyboardType: TextInputType.datetime,
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2100),
                  );
                  if (date != null) {
                    startDateController.text = date.toString();
                  }
                },
              ),
              TextField(
                controller: endDateController,
                decoration: InputDecoration(
                  labelText: 'End Date',
                ),
                keyboardType: TextInputType.datetime,
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2100),
                  );
                  if (date != null) {
                    endDateController.text = date.toString();
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final startDate = DateTime.parse(startDateController.text);
                final endDate = DateTime.parse(endDateController.text);
                final period = Period(startDate, endDate);
                _periodData.addPeriod(period);
                _onPeriodsChanged();
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Period Tracker'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ValueListenableBuilder<DateTime>(
            valueListenable: _selectedDay,
            builder: (context, selectedDay, _) {
              return Text(
                '${selectedDay.year}-${selectedDay.month.toString().padLeft(2, '0')}-${selectedDay.day.toString().padLeft(2, '0')}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
          TableCalendar(
            firstDay: DateTime.utc(2021, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _selectedDay.value,
            selectedDayPredicate: (day) {
              return isSameDay(day, _selectedDay.value);
            },
            onDaySelected: _onDaySelected,
            calendarStyle: CalendarStyle(
              selectedDecoration: BoxDecoration(
                color: Theme.of(context).accentColor,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: Colors.grey[300],
                shape: BoxShape.circle,
              ),
            ),
            calendarBuilders: CalendarBuilders(
              selectedBuilder: (context, date, _) {
                return CircleAvatar(
                  backgroundColor: Theme.of(context).accentColor,
                  child: Text(
                    date.day.toString(),
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                );
              },
              todayBuilder: (context, date, _) {
                return CircleAvatar(
                  backgroundColor: Colors.grey[300],
                  child: Text(
                    date.day.toString(),
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                );
              },
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
          ),
          Expanded(
            child: ValueListenableBuilder<List<Period>>(
              valueListenable: _selectedPeriods,
              builder: (context, periods, _) {
                return ListView.builder(
                  itemCount: periods.length,
                  itemBuilder: (context, index) {
                    final period = periods[index];
                    final startDay = period.startDate.day;
                    final endDay = period.endDate.day;
                    final startMonth = period.startDate.month;
                    final endMonth = period.endDate.month;
                    final startYear = period.startDate.year;
                    final endYear = period.endDate.year;
                    return ListTile(
                      title: Text('Period $index'),
                      subtitle: Text(
                          '$startDay/$startMonth/$startYear - $endDay/$endMonth/$endYear'),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddPeriodDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

