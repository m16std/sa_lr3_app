import 'package:flutter/cupertino.dart';
import 'package:sa_lr1_app/pages/result_page.dart';
import 'package:sa_lr1_app/widgets/widgets.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dynamic List Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TablePage(),
    );
  }
}

class TablePage extends StatefulWidget {
  @override
  _TablePageState createState() => _TablePageState();
}

class _TablePageState extends State<TablePage> {
  int rowCount = 2;
  int columnCount = 2;
  List<List<int>> tableData = [[]];
  List<List<TextEditingController>> controllers = [[]];

  @override
  void initState() {
    super.initState();
    _initializeTable();
  }

  void _initializeTable() {
    //tableData.clear();
    List<List<int>> newData = [];
    for (int i = 0; i < tableData.length; i++) {
      List<int> row = [];
      for (int j = 1; j <= tableData[i].length; j++) {
        int value = int.parse(controllers[i][j].text);
        row.add(value);
      }
      newData.add(row);
    }
    setState(() {
      tableData = newData;
    });

    int n1 = tableData.length;
    if (n1 < rowCount) {
      for (int i = 0; i < rowCount - n1; i++) {
        List<int> row = <int>[0];
        tableData.add(row);
      }
    } else {
      for (int i = 0; i < n1 - rowCount; i++) {
        tableData.removeLast();
      }
    }
    for (int i = 0; i < rowCount; i++) {
      int n2 = tableData[i].length;
      if (n2 < columnCount) {
        for (int j = 0; j < columnCount - n2; j++) {
          tableData[i].add(0);
        }
      } else {
        for (int j = 0; j < n2 - columnCount; j++) {
          tableData[i].removeLast();
        }
      }
    }

    _initializeControllers();
  }

  void _initializeControllers() {
    controllers.clear();
    for (int i = 0; i < rowCount; i++) {
      List<TextEditingController> rowControllers = [];
      TextEditingController controller = TextEditingController();
      controller.text = (i + 1).toString();
      rowControllers.add(controller);
      for (int j = 0; j < columnCount; j++) {
        TextEditingController controller = TextEditingController();
        controller.text = tableData[i][j].toString();
        rowControllers.add(controller);
      }
      controllers.add(rowControllers);
    }
  }

  void _saveTableData() {
    List<List<int>> newData = [];
    for (int i = 0; i < rowCount; i++) {
      List<int> row = [];
      for (int j = 1; j <= columnCount; j++) {
        int value = int.parse(controllers[i][j].text);
        row.add(value);
      }
      newData.add(row);
    }
    setState(() {
      tableData = newData;
    });
    _compute(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: Colors.white,
        title: const Text('Матрица инцидентности'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Вершин: '),
                SizedBox(width: 10),
                DropdownButton<int>(
                  value: rowCount,
                  onChanged: (value) {
                    setState(() {
                      rowCount = value!;
                      _initializeTable();
                    });
                  },
                  items: List.generate(20, (index) {
                    return DropdownMenuItem<int>(
                      value: index + 1,
                      child: Text('${index + 1}'),
                    );
                  }),
                ),
                SizedBox(width: 20),
                Text('Дуг: '),
                SizedBox(width: 10),
                DropdownButton<int>(
                  value: columnCount,
                  onChanged: (value) {
                    setState(() {
                      columnCount = value!;
                      _initializeTable();
                    });
                  },
                  items: List.generate(20, (index) {
                    return DropdownMenuItem<int>(
                      value: index + 1,
                      child: Text('${index}'),
                    );
                  }),
                ),
              ],
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  DataTable(
                    horizontalMargin: 0,
                    columnSpacing: 0,
                    columns: collumns(columnCount),
                    rows: List.generate(rowCount, (i) {
                      return DataRow(
                        cells: List.generate(columnCount, (j) {
                          return DataCell(
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 16) /
                                  columnCount,
                              child: Center(
                                child: TextField(
                                  controller: controllers[i][j],
                                  decoration: InputDecoration(
                                    //border: OutlineInputBorder(),
                                    hintText: 'Enter data (-1, 0, 1)',
                                  ),
                                  onChanged: (value) {
                                    if (value != '-' &&
                                        value != '0' &&
                                        value != '1' &&
                                        value != '-1') {
                                      controllers[i][j].text = '';
                                    }
                                  },
                                ),
                              ),
                            ),
                          );
                        }),
                      );
                    }),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveTableData,
              child: Text('Перевести'),
            ),
          ],
        ),
      ),
    );
  }

  List<DataColumn> collumns(int count) {
    List<DataColumn> collumns_list = [];
    collumns_list.add(DataColumn(label: Text('')));
    for (int i = 1; i < columnCount; i++) {
      collumns_list.add(DataColumn(label: Text('${(i).toString()}')));
    }

    //${String.fromCharCode(97 + index).toUpperCase()}
    return collumns_list;
  }

  List<DataCell> cells(int i, int count) {
    List<DataCell> cells_list = <DataCell>[DataCell(Text(' '))];

    for (int j = 0; j < count; j++) {
      cells_list.add(DataCell(
        SizedBox(
          width: (MediaQuery.of(context).size.width - 16) / columnCount,
          child: Center(
            child: TextField(
              controller: controllers[i][j],
              decoration: InputDecoration(
                //border: OutlineInputBorder(),
                hintText: 'Enter only -1, 0, 1',
              ),
              onChanged: (value) {
                if (value != '-' &&
                    value != '0' &&
                    value != '1' &&
                    value != '-1') {
                  controllers[i][j].text = '';
                }
              },
            ),
          ),
        ),
      ));
    }
    return cells_list;
  }

  List<int> stringToList(String input) {
    List<String> numbersAsString = input.split(' ');
    List<int> numbers = numbersAsString.map((str) => int.parse(str)).toList();
    return numbers;
  }

  List<List<int>> getIncidenceMatrix(List<List<int>> ListOfincidence) {
    int arc_count = 0;

    for (int j = 0; j < ListOfincidence.length; j++) {
      for (int i = 0; i < ListOfincidence[j].length; i++) {
        arc_count += 1;
      }
    }

    List<List<int>> IncidenceMatrix = List.generate(
        ListOfincidence.length, (_) => List<int>.filled(arc_count, 0));

    int arc_num = 0;

    for (int j = 0; j < ListOfincidence.length; j++) {
      for (int i = 0; i < ListOfincidence[j].length; i++) {
        if (ListOfincidence[j][i] < ListOfincidence.length) {
          IncidenceMatrix[ListOfincidence[j][i]][arc_num] = -1;
          IncidenceMatrix[j][arc_num] = 1;
          if (ListOfincidence[j][i] == j) {
            IncidenceMatrix[j][arc_num] = 2;
          }
          arc_num += 1;
        }
      }
    }
    return IncidenceMatrix;
  }

  List<List<int>> getListOfincidence_r() {
    List<List<int>> ListOfincidence = List.generate(rowCount, (_) => <int>[]);

    for (int j = 0; j < columnCount; j++) {
      for (int i = 0; i < rowCount; i++) {
        if (tableData[i][j] == 1) {
          for (int k = 0; k < rowCount; k++) {
            if (tableData[k][j] == -1) {
              ListOfincidence[i].add(k);
              break;
            }
          }
        }
        if (tableData[i][j] == 2) {
          ListOfincidence[i].add(i);
        }
      }
    }

    if (ListOfincidence.isEmpty) print('suka pustoy spisok');

    return ListOfincidence;
  }

  List<List<int>> getListOfincidence_l() {
    List<List<int>> ListOfincidence = List.generate(rowCount, (_) => <int>[]);

    for (int j = 0; j < columnCount; j++) {
      for (int i = 0; i < rowCount; i++) {
        if (tableData[i][j] == -1) {
          for (int k = 0; k < rowCount; k++) {
            if (tableData[k][j] == 1) {
              ListOfincidence[i].add(k);
              break;
            }
          }
        }
        if (tableData[i][j] == 2) {
          ListOfincidence[i].add(i);
        }
      }
    }

    if (ListOfincidence.isEmpty) print('suka pustoy spisok');

    return ListOfincidence;
  }

  List<List<int>> getAdjacencyMatrix(List<List<int>> ListOfincidence) {
    List<List<int>> AdjacencyMatrix = List.generate(ListOfincidence.length,
        (_) => List<int>.filled(ListOfincidence.length, 0));

    for (int j = 0; j < ListOfincidence.length; j++) {
      for (int i = 0; i < ListOfincidence[j].length; i++) {
        if (ListOfincidence[j][i] < ListOfincidence.length)
          AdjacencyMatrix[j][ListOfincidence[j][i]] = 1;
      }
    }

    return AdjacencyMatrix;
  }

  List<List<int>> swap(
      List<List<int>> matrix, List<int> position, int a, int b) {
    int n = matrix.length;
    int bufer;
    for (int i = 0; i < n; i++) {
      bufer = matrix[i][a];
      matrix[i][a] = matrix[i][b];
      matrix[i][b] = bufer;
    }
    for (int i = 0; i < n; i++) {
      bufer = matrix[a][i];
      matrix[a][i] = matrix[b][i];
      matrix[b][i] = bufer;
    }
    bufer = position[a];
    position[a] = position[b];
    position[b] = bufer;

    return matrix;
  }

  List<int> getRenames(List<List<int>> AdjacencyMatrix) {
    List<int> sums = List<int>.filled(AdjacencyMatrix.length, 0);
    List<int> renamed = [];
    List<int> last_renamed = [];
    List<int> rename = List<int>.filled(AdjacencyMatrix.length, 0);
    int n = AdjacencyMatrix.length;

    for (int j = 0; j < n; j++) {
      for (int i = 0; i < n; i++) {
        sums[j] += AdjacencyMatrix[i][j];
      }
    }

    //print(sums);

    int k = 0;

    while (k < n) {
      int flag = -1;

      for (int j = 0; j < n; j++) {
        if (sums[j] == 0 && !renamed.contains(j)) {
          rename[k] = j;
          renamed.add(j);
          last_renamed.add(j);
          flag = 1;
          k += 1;
        }
      }

      if (flag == -1) {
        print('Невозможно выполнить');
        return rename;
      }

      for (int i = 0; i < last_renamed.length; i++) {
        for (int j = 0; j < n; j++) {
          sums[j] -= AdjacencyMatrix[last_renamed[i]][j];
        }
      }

      last_renamed = [];

      //print(sums);
    }
    return rename;
  }

  List<List<int>> orderFunction(List<List<int>> AdjacencyMatrix) {
    List<int> rename = getRenames(AdjacencyMatrix);
    int n = AdjacencyMatrix.length;

    List<int> position = [];
    for (int i = 0; i < n; i++) {
      position.add(i);
    }

    for (int i = 0; i < n; i++) {
      if (position[i] != rename[i]) {
        swap(AdjacencyMatrix, position, position.indexOf(rename[i]), i);
      }
    }

    return AdjacencyMatrix;
  }

  List<int> getReachableSet(
      int point, List<List<int>> listOfincidence_r, List<int> reachable_set) {
    if (reachable_set.contains(point)) return reachable_set;
    reachable_set.add(point);
    for (int i = 0; i < listOfincidence_r[point].length; i++) {
      List<int> bufer = getReachableSet(
          listOfincidence_r[point][i], listOfincidence_r, reachable_set);
      for (int j = 0; j < bufer.length; j++) {
        if (!reachable_set.contains(bufer[j])) reachable_set.add(bufer[j]);
      }
    }
    return reachable_set;
  }

  List<int> intersection(List<int> a, List<int> b) {
    List<int> intersected_set = [];
    for (int i = 0; i < a.length; i++) {
      if (b.contains(a[i])) {
        intersected_set.add(a[i]);
      }
    }
    return intersected_set;
  }

  void _compute(BuildContext context) {
    try {
      List<List<int>> listOfincidenceR = getListOfincidence_r();
      List<List<int>> listOfincidenceL = getListOfincidence_l();
      List<List<int>> adjacencyMatrix = getAdjacencyMatrix(listOfincidenceR);
      List<List<int>> subgraphs = [];
      List<int> points_flag = [];
      for (int i = 0; i < listOfincidenceR.length; i++) {
        points_flag.add(i);
      }

      while (points_flag.length != 0) {
        List<int> reachable_set =
            getReachableSet(points_flag[0], listOfincidenceR, []);
        List<int> unreachable_set =
            getReachableSet(points_flag[0], listOfincidenceL, []);
        List<int> subgraph = intersection(reachable_set, unreachable_set);
        for (int i = 0; i < subgraph.length; i++) {
          listOfincidenceR[subgraph[i]] = [];
          listOfincidenceL[subgraph[i]] = [];
          points_flag.remove(subgraph[i]);
        }
        for (int j = 0; j < listOfincidenceR.length; j++) {
          for (int i = 0; i < subgraph.length; i++) {
            listOfincidenceR[j].remove(subgraph[i]);
            listOfincidenceL[j].remove(subgraph[i]);
          }
        }
        subgraphs.add(subgraph);
      }
      print(subgraphs);

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ResultPage(
            subgraphs: subgraphs,
            listOfincidenceL: getListOfincidence_l(),
            adjacencyMatrix: adjacencyMatrix,
            incidenceMatrix: tableData,
          ),
        ),
      );
    } catch (e) {}
  }
}
