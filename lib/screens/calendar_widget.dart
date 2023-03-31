import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class EventCalendarScreen extends StatefulWidget {
  const EventCalendarScreen({Key? key}) : super(key: key);

  @override
  State<EventCalendarScreen> createState() => _EventCalendarScreenState();
}





class _EventCalendarScreenState extends State<EventCalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDate;


  Map<String,List> mySelectedEvents = {};

  final titleController = TextEditingController();
  final descpController = TextEditingController();


  loadPreviousEvents(){
    mySelectedEvents = {
      DateFormat('yyy-MM-dd')
        .format(_selectedDate!) : [
        {"eventDescp" : '11',"eventTitle" :"111"},
        {"eventDescp" : '11',"eventTitle" :"111"}
      ],
    };
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
      _selectedDate = _focusedDay;
      loadPreviousEvents();
  }

List _ListofDayEvents(DateTime dateTime){
    if(mySelectedEvents[DateFormat('yyy-MM-dd').format(dateTime)]!=null){
      return mySelectedEvents[DateFormat('yyy-MM-dd').format(dateTime)]!;
    }
    else{
      return [];
    }
}


  _showAddEventDialog() async {
    await showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: const Text("Add the period date",textAlign : TextAlign.center
              ),
              content: Column(
                crossAxisAlignment : CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                    TextField(
                      controller: titleController,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        labelText: 'Title',
                      ),
                    ),
                  TextField(
                    controller: descpController,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                    ),
                  ),
                ]
              ),
                actions:[
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                  ),
                  TextButton(child: const Text('Add'),
                  onPressed: (){
                    if(titleController.text.isEmpty && descpController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Required Title and Description'),
                        duration: Duration(seconds: 2),
                      )
                      );

                      ///Navigator.pop(context);
                      return ;
                    }
                    else{
                      print(titleController.text);
                      print(descpController.text);
                      setState(() {
                        if(
                        mySelectedEvents[DateFormat('yyy-MM-dd')
                            .format(_selectedDate!)] !=
                            null

                        ){
                          mySelectedEvents[DateFormat('yyyy-MM-dd').format(_selectedDate!)]?.add({
                            "eventTitle" : titleController.text,
                            "eventDescp" : descpController.text,
                          });
                        }
                        else{
                          mySelectedEvents[DateFormat('yyyy-MM-dd').format(_selectedDate!)]=[
                            {
                              "eventTitle" : titleController.text,
                              "eventDescp" : descpController.text,
                            }
                          ];
                        }
                      });
                      titleController.clear();
                      descpController.clear();
                      Navigator.pop(context);
                      return ;
                    }
                  },
                  )
                ],
            ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Period Tracking Calendar"),
      ),


      body: Column(
        children: [
          TableCalendar(focusedDay: _focusedDay, firstDay: DateTime(2023), lastDay: DateTime(2027),
          calendarFormat: _calendarFormat,
            onDaySelected :(selectedDay,focusedDay){
            if(!isSameDay(_selectedDate,selectedDay)){
              //Call 'setState()' when updating the selected Day
              setState(() {
                _selectedDate = selectedDay;
                _focusedDay = focusedDay;
              });
            }
      },
            selectedDayPredicate: (day){
              return isSameDay(_selectedDate,day);
            },

            onFormatChanged: (format){
              if (_calendarFormat != format){
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay){
                  _focusedDay = focusedDay;
            },
            eventLoader: _ListofDayEvents,
          ),
          ..._ListofDayEvents(_selectedDate!).map(
              (myevents) => ListTile(
                leading : const Icon(
                  Icons.done,
                  color:Colors.teal,
                ),
                title:Padding(
                  padding : const EdgeInsets.only(bottom : 8.0),
                child:Text('Event Title : ${myevents['eventTitle']}'),
                ),
                subtitle: Text('Description : ${myevents['eventsDesc']}'),
              ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddEventDialog(),
        label: const Text('Add Date'),
      ),
    );
  }

  
}

