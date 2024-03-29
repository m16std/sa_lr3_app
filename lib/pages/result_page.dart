import 'package:sa_lr1_app/pages/tree_view_page.dart';
import 'package:sa_lr1_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';

class ResultPage extends StatefulWidget {
  const ResultPage(
      {super.key, this.adjacencyMatrix, this.subgraphs, this.listOfincidenceL});

  final List<List<int>>? adjacencyMatrix;
  final List<List<int>>? subgraphs;
  final List<List<int>>? listOfincidenceL;

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          scrolledUnderElevation: 0.0,
          backgroundColor: Colors.white,
          title: Center(child: const Text('Полученные матрицы')),
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
                margin: const EdgeInsets.all(10),
                alignment: Alignment.center,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(15)),
                child: const Icon(Icons.arrow_back_ios)),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TreeViewPage(
                        adjacencyMatrix: widget.adjacencyMatrix,
                        subgraphs: widget.subgraphs),
                  ),
                );
              },
              child: Container(
                  margin: const EdgeInsets.all(10),
                  alignment: Alignment.center,
                  width: 37,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(15)),
                  child: const Icon(Icons.arrow_forward_ios)),
            ),
          ]),
      body: Container(
        //width: widget.adjacencyMatrix!.length * 55,
        height: 1000,
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            DataTable(
              columns: list_buildColumns('Подсистемы'),
              rows: list_buildRows(widget.subgraphs!),
              columnSpacing: 0.0,
            ),
            SizedBox(
              height: 20,
            ),
            Center(child: const Text('Матрица смежности')),
            DataTable(
              columns: matrix_buildColumns(widget.adjacencyMatrix!),
              rows: matrix_buildRows(widget.adjacencyMatrix!),
              columnSpacing: 0.0,
            ),
            SizedBox(
              height: 20,
            ),
            DataTable(
              columns: list_buildColumns('Левые инциденции'),
              rows: list_buildRows(widget.listOfincidenceL!),
              columnSpacing: 0.0,
            ),
          ],
        ),
      ),
    );
  }

  // Создание столбцов таблицы
  List<DataColumn> list_buildColumns(String name) {
    List<DataColumn> columns = [];
    columns.add(const DataColumn(label: Text(' ')));
    columns.add(DataColumn(label: Text(name)));
    return columns;
  }

  // Создание строк таблицы
  List<DataRow> list_buildRows(List<List<int>> list) {
    return list.asMap().entries.map((entry) {
      int rowIndex = entry.key;
      List<int> rowData = entry.value;
      return DataRow(
        cells: list_buildCellsForRow(rowIndex, rowData, list),
      );
    }).toList();
  }

  // Создание ячеек для строки таблицы
  List<DataCell> list_buildCellsForRow(
      int rowIndex, List<int> rowData, List<List<int>> list) {
    List<DataCell> cells = [];
    cells.add(DataCell(
        Text('${rowIndex + 1}'))); // Добавляем цифровую метку слева от строки
    String text = '';
    for (int i = 0; i < list[rowIndex].length; i++) {
      text += (list[rowIndex][i] + 1).toString() + '    ';
    }
    cells.add(DataCell(Text(text)));
    return cells;
  }

  // Создание столбцов таблицы
  List<DataColumn> matrix_buildColumns(List<List<int>> matrix) {
    List<DataColumn> columns = [];
    columns.add(const DataColumn(label: Text(' ')));
    for (int i = 0; i < matrix.first.length; i++) {
      columns.add(DataColumn(label: Text((i + 1).toString())));
    }
    return columns;
  }

  // Создание строк таблицы
  List<DataRow> matrix_buildRows(List<List<int>> matrix) {
    return matrix.asMap().entries.map((entry) {
      int rowIndex = entry.key;
      List<int> rowData = entry.value;
      return DataRow(
        cells: matrix_buildCellsForRow(rowIndex, rowData),
      );
    }).toList();
  }

  // Создание ячеек для строки таблицы
  List<DataCell> matrix_buildCellsForRow(int rowIndex, List<int> rowData) {
    List<DataCell> cells = [];
    cells.add(DataCell(
        Text('${rowIndex + 1}'))); // Добавляем цифровую метку слева от строки
    for (int cellData in rowData) {
      cells.add(DataCell(Text('$cellData')));
    }
    return cells;
  }
}
