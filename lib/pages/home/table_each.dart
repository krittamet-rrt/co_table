import 'package:co_table/bloc/reservation/reservation_bloc.dart';
import 'package:co_table/bloc/reservation/reservation_event.dart';
import 'package:co_table/core.dart';
import 'package:co_table/utils/text_constant.dart';
import 'package:co_table/theme/theme_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/bloc.dart';

class TableEach extends StatelessWidget {
  final int roomId;
  const TableEach({super.key, required this.roomId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TableBloc, TableState>(
      builder: (context, tableState) {
        if (tableState is ReadyTableState) {
          final tableList = tableState.tableList
              .where((table) => table.roomId == roomId)
              .toList();
          return _TableEachContent(boxCount: tableList.length);
        }
        return const CircularProgressIndicator();
      },
    );
  }
}

class _TableEachContent extends StatefulWidget {
  final int boxCount;

  const _TableEachContent({required this.boxCount});

  @override
  _TableEachContentState createState() => _TableEachContentState();
}

class _TableEachContentState extends State<_TableEachContent> {
  late List<bool> _isSelected;
  late List<bool> _isConfirmed;

  @override
  void initState() {
    super.initState();
    _isSelected = List.generate(widget.boxCount, (_) => false);
    _isConfirmed = List.generate(widget.boxCount, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.only(top: 30, left: 40, right: 40, bottom: 90),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 1,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
              ),
              itemCount: widget.boxCount,
              itemBuilder: (context, index) {
                return _buildBoxItem(index);
              },
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: _buildConfirmButton(),
        ),
      ],
    );
  }

  Widget _buildBoxItem(int index) {
    var hoursController = TextEditingController();
    return BlocBuilder<UserBloc, UserState>(builder: (context, userState) {
      return GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('จองโต๊ะ'),
                content: TextField(
                  controller: hoursController,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('ยกเลิก'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: const Text('จอง'),
                    onPressed: () {
                      context.read<ReservationBloc>().add(
                          CreateReservationEvent(
                              durationHours: int.parse(hoursController.text),
                              userId: userState.user.id,
                              tableId: index + 1));
                    },
                  ),
                ],
              );
            },
          );
        },
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: _isConfirmed[index]
                ? const Color(0xFF040261)
                : Colors.grey.withOpacity(0.5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              '${index + 1}',
              style: TextStyle(
                color: _isConfirmed[index] ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildConfirmButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            for (int i = 1; i < widget.boxCount; i++) {
              if (_isSelected[i]) {
                _isConfirmed[i] = true;
                _isSelected[i] = false;
              }
            }
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: ThemeState.buttonSelectTheme.colors[0],
          padding: const EdgeInsets.symmetric(vertical: 20),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
        ),
        child: Text(
          TextConstant.textSelect,
          style: TextStyle(
            fontSize: 20,
            color: ThemeState.lightTheme.colors[0],
          ),
        ),
      ),
    );
  }
}
