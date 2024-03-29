import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';

class TreeViewPage extends StatefulWidget {
  final List<List<int>>? adjacencyMatrix;
  final List<List<int>>? subgraphs;
  const TreeViewPage({super.key, this.adjacencyMatrix, this.subgraphs});
  @override
  _TreeViewPageState createState() => _TreeViewPageState();
}

class _TreeViewPageState extends State<TreeViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Просмотр графа'),
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
                //margin: const EdgeInsets.all(10),
                alignment: Alignment.center,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(15)),
                child: const Icon(Icons.arrow_back_ios)),
          ),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: InteractiveViewer(
                  //constrained: false,
                  //boundaryMargin: EdgeInsets.all(10),
                  minScale: 0.1,
                  maxScale: 10.0,
                  child: GraphView(
                    graph: graph,
                    paint: Paint()
                      ..color = Colors.green
                      ..strokeWidth = 1
                      ..style = PaintingStyle.stroke,
                    algorithm: FruchtermanReingoldAlgorithm(),
                    builder: (Node node) {
                      var a = node.key!.value as int;
                      var l = widget.subgraphs!.length;
                      var s = 0;
                      var m = Color.fromARGB(147, 134, 16, 170);
                      for (int i = 0; i < l; i++) {
                        if (widget.subgraphs![i].contains(a)) {
                          s = i;
                        }
                      }
                      int color = (255 * (s / (l - 1))).round();
                      int b = ((color - 127) * 2).clamp(0, 255);
                      int r = ((127 - color) * 2).clamp(0, 255) +
                          ((color * 4 - 850)).clamp(0, 255);
                      int g = ((color * 2 - 10).clamp(0, 255) -
                          ((color * 1.5 - 127) * 2).round().clamp(0, 255));
                      print(r);
                      print(g);
                      print(b);
                      print(' ');
                      return rectangleWidget(
                          (a + 1).toString(), Color.fromARGB(150, r, g, b));
                    },
                  )),
            ),
          ],
        ));
  }

  Widget rectangleWidget(String a, Color point_color) {
    return InkWell(
      child: Container(
          width: 50,
          height: 50,
          margin: EdgeInsets.only(top: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(color: point_color, spreadRadius: 0),
            ],
          ),
          child: Center(
              child: Text(
            a,
            style: TextStyle(
                fontSize: 16,
                color: Color.fromARGB(255, 255, 255, 255),
                fontWeight: FontWeight.bold),
          ))),
    );
  }

  final Graph graph = Graph();

  @override
  void initState() {
    List<Node> ListNode = List.generate(
        widget.adjacencyMatrix!.length, (int index) => Node.Id(index));

    // Создаем ребра на основе таблицы смежности
    for (int i = 0; i < widget.adjacencyMatrix!.length; i++) {
      for (int j = 0; j < widget.adjacencyMatrix![i].length; j++) {
        if (widget.adjacencyMatrix![i][j] == 1) {
          // Добавляем ребро от i-й вершины к j-й вершине
          if (i == j) continue;
          graph.addEdge(ListNode[i], ListNode[j]);
        }
      }
    }
    var builder = FruchtermanReingoldAlgorithm();
  }
}
