import 'package:flutter/material.dart';

class Pagination<T> extends StatefulWidget {
  final List<T> data;
  final int numPerPage;
  final void Function(List<T> data) onChange;

  const Pagination(
      {Key? key,
      required this.data,
      this.numPerPage = 10,
      required this.onChange})
      : super(key: key);

  @override
  _PaginationState createState() => _PaginationState<T>();
}

class _PaginationState<T> extends State<Pagination> {
  final List<_PaginationElement> buttons = [];

  late int totalData;
  late int totalButtons;
  late int numPerPage;
  int currentPosition = 1;

  construct() {
    totalData = widget.data.length;
    totalButtons = totalData ~/ widget.numPerPage;
    totalButtons = totalButtons < 1 ? 1 : totalButtons;
    numPerPage = widget.numPerPage;
  }

  createExpansionButton() => buttons.add(_PaginationElement(0, "...", 0));

  createFirstButton() => buttons.add(_PaginationElement(1, "1", 1));

  createLastButton() =>
      buttons.add(_PaginationElement(1, totalButtons.toString(), totalButtons));

  init() {
    if (currentPosition > 1) {
      buttons.add(_PaginationElement(1, "Prev", currentPosition - 1));
    }

    if (currentPosition < 5) {
      for (int i = 1; i <= (totalButtons < 5 ? totalButtons : 5); i++) {
        buttons.add(_PaginationElement(1, i.toString(), i));
      }
    } else if (currentPosition >= 5 && currentPosition < totalButtons - 1) {
      createFirstButton();
      createExpansionButton();

      for (int i = currentPosition - 1; i <= currentPosition + 1; i++) {
        buttons.add(_PaginationElement(1, i.toString(), i));
      }

      createExpansionButton();
      createLastButton();
    } else if (currentPosition >= totalButtons - 2) {
      createFirstButton();
      createExpansionButton();

      for (int i = totalButtons - 2; i <= totalButtons; i++) {
        buttons.add(_PaginationElement(1, i.toString(), i));
      }
    }

    if (currentPosition < totalButtons) {
      buttons.add(_PaginationElement(1, "Next", currentPosition + 1));
    }
  }

  jump(int position) {
    setState(() {
      currentPosition = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    final listPosition = currentPosition - 1;
    final data = widget.data;
    late List<dynamic> slicedData;

    construct();

    if (currentPosition == totalButtons || totalData < numPerPage) {
      slicedData =
          data.getRange(listPosition * numPerPage, data.length).toList();
    } else {
      slicedData = data
          .getRange(listPosition * numPerPage, currentPosition * numPerPage)
          .toList();
    }

    if (data.length != widget.data.length) {}

    widget.onChange(slicedData);
    buttons.clear();
    init();

    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: buttons.map((e) {
          return Flexible(
            // child: text(
            //     onPressed: () => e.type == 0 ? null : jump(e.position),
            //     child: Text(e.value)),
            child: GestureDetector(
                onTap: () => jump(e.position),
                child: Container(
                    padding: const EdgeInsets.all(6),
                    child: Text(
                      e.value,
                      style: TextStyle(
                          color: const Color(0xFF555555),
                          fontWeight: e.position == currentPosition
                              ? FontWeight.bold
                              : FontWeight.normal),
                    ))),
          );
        }).toList());
  }
}

class _PaginationElement {
  final int type; // 0 = expansion, 1 = number
  final String value;
  final int position;

  _PaginationElement(this.type, this.value, this.position);
}
