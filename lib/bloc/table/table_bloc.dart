import 'package:co_table/bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repositories/table/table_repo.dart';

class TableBloc extends Bloc<TableEvent, TableState> {
  final TableRepo tableRepo;

  TableBloc({required this.tableRepo}) : super(LoadingTableState()) {
    on<LoadTableEvent>(_onLoadTableEvent);
    on<CreateTableEvent>(_onCreateTableEvent);
    on<DeleteTableEvent>(_onDeleteTableEvent);
  }

  _onLoadTableEvent(LoadTableEvent event, Emitter<TableState> emit) async {
    if (state is LoadingTableState) {
      final table = await tableRepo.getTable();
      emit(ReadyTableState(table: table, tableList: emptyTableList));
    }
  }

  _onCreateTableEvent(CreateTableEvent event, Emitter<TableState> emit) async {
    if (state is ReadyTableState) {
      final currentRoom = (state as ReadyRoomState).room;
      final response = await tableRepo.createTable(
        number: event.number,
        roomId: currentRoom.id,
      );
      emit(LoadingTableState(responseText: response));
      if (response.contains("สร้างโต๊ะสำเร็จ")) {
        add(LoadTableEvent());
      }
    }
  }

  _onDeleteTableEvent(DeleteTableEvent event, Emitter<TableState> emit) async {
    if (state is ReadyTableState) {
      final currentTable = (state as ReadyTableState).table;
      final response = await tableRepo.deleteTable(tableId: currentTable.id);
      emit(LoadingTableState(responseText: response));
      add(LoadTableEvent());
    }
  }
}
