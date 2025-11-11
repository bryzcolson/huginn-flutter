import 'package:flutter/material.dart';

class Renderer extends StatelessWidget {
  final String content;
  final Function(String, bool) navigate;

  const Renderer({
    super.key,
    required this.content,
    required this.navigate,
  });

  @override
  Widget build(BuildContext context) {
    final lines = content.split('\n');
    final widgets = <Widget>[];
    final items = <Widget>[];
    final rows = <TableRow>[];
    bool inTeleType = false;
    final ttLines = <String>[];

    for (final line in lines) {
      final args = line.split('\t');
      final type = args.isNotEmpty ? args.removeAt(0) : '';

      if (inTeleType && type != 'untt') {
        ttLines.add(line.startsWith('\t') ? line.substring(1) : line);
      } else if (type == 'tt') {
        inTeleType = true;
      } else if (type == 'untt') {
        widgets.add(_CodeBlock(text: ttLines.join('\n')));
        ttLines.clear();
        inTeleType = false;
      } else if (type == 't') {
        // Title - in Flutter we could update window title if needed
        // For now, we'll skip this as it's handled at app level
      } else if (type == 'a') {
        // Anchor - could be used for internal navigation
        widgets.add(const SizedBox.shrink());
      } else if (type == 'h1') {
        widgets.add(_Heading(text: args.isNotEmpty ? args[0] : '', level: 1));
      } else if (type == 'h2') {
        widgets.add(_Heading(text: args.isNotEmpty ? args[0] : '', level: 2));
      } else if (type == 'h3') {
        widgets.add(_Heading(text: args.isNotEmpty ? args[0] : '', level: 3));
      } else if (type == 'p') {
        widgets.add(_Paragraph(text: args.isNotEmpty ? args[0] : ''));
      } else if (type == 'r') {
        if (args.length >= 2) {
          widgets.add(_Reference(
            text: args[0],
            url: args[1],
            onTap: () => navigate(args[1], true),
          ));
          widgets.add(const SizedBox(height: 4));
        }
      } else if (type == 'lbr') {
        widgets.add(const SizedBox(height: 8));
      } else if (type == 'lsep') {
        widgets.add(const Divider(color: Colors.black));
      } else if (type == 'unel') {
        widgets.add(_UnorderedList(items: List.from(items)));
        items.clear();
      } else if (type == 'unbl') {
        widgets.add(_OrderedList(items: List.from(items)));
        items.clear();
      } else if (type == 'it') {
        items.add(Text(
          args.isNotEmpty ? args[0] : '',
          style: const TextStyle(
            color: Colors.black,
            decoration: TextDecoration.none,
            fontWeight: FontWeight.normal,
            fontSize: 12,
          ),
        ));
      } else if (type == 'untbl') {
        widgets.add(_DataTable(rows: List.from(rows)));
        rows.clear();
      } else if (type == 'tblh') {
        rows.add(TableRow(
          decoration: const BoxDecoration(color: Colors.white),
          children: args.map((arg) => _TableCell(text: arg, isHeader: true)).toList(),
        ));
      } else if (type == 'tblr') {
        rows.add(TableRow(
          children: args.map((arg) => _TableCell(text: arg, isHeader: false)).toList(),
        ));
      }
    }

    return Container(
      constraints: const BoxConstraints(minWidth: 664),
      padding: const EdgeInsets.all(24),
      child: SelectableRegion(
        focusNode: FocusNode(),
        selectionControls: materialTextSelectionControls,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widgets,
          ),
        ),
      ),
    );
  }
}

class _CodeBlock extends StatelessWidget {
  final String text;

  const _CodeBlock({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF1F6),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.black,
          decoration: TextDecoration.none,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }
}

class _Heading extends StatelessWidget {
  final String text;
  final int level;

  const _Heading({required this.text, required this.level});

  @override
  Widget build(BuildContext context) {
    double fontSize;
    FontWeight fontWeight;

    switch (level) {
      case 1:
        fontSize = 24;
        fontWeight = FontWeight.bold;
        break;
      case 2:
        fontSize = 20;
        fontWeight = FontWeight.bold;
        break;
      case 3:
        fontSize = 16;
        fontWeight = FontWeight.bold;
        break;
      default:
        fontSize = 14;
        fontWeight = FontWeight.normal;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: Colors.black,
          decoration: TextDecoration.none,
        ),
      ),
    );
  }
}

class _Paragraph extends StatelessWidget {
  final String text;

  const _Paragraph({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.black,
          decoration: TextDecoration.none,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }
}

class _Reference extends StatefulWidget {
  final String text;
  final String url;
  final VoidCallback onTap;

  const _Reference({
    required this.text,
    required this.url,
    required this.onTap,
  });

  @override
  State<_Reference> createState() => _ReferenceState();
}

class _ReferenceState extends State<_Reference> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          color: _isHovered ? const Color(0xFFEAF1F6) : Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: DefaultTextStyle(
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF0366D6),
              decoration: TextDecoration.underline,
              decorationColor: Color(0xFF0366D6),
            ),
            child: Text(
              widget.text,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF0366D6),
                decoration: TextDecoration.underline,
                decorationColor: Color(0xFF0366D6),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _UnorderedList extends StatelessWidget {
  final List<Widget> items;

  const _UnorderedList({required this.items});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items.map((item) {
          return Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('• ', style: TextStyle(fontSize: 12, color: Colors.black, decoration: TextDecoration.none, fontWeight: FontWeight.normal)),
                Expanded(
                  child: DefaultTextStyle(
                    style: const TextStyle(fontSize: 12, color: Colors.black, decoration: TextDecoration.none, fontWeight: FontWeight.normal),
                    child: item,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _OrderedList extends StatelessWidget {
  final List<Widget> items;

  const _OrderedList({required this.items});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${index + 1}. ', style: const TextStyle(fontSize: 12, color: Colors.black, decoration: TextDecoration.none, fontWeight: FontWeight.normal)),
                Expanded(
                  child: DefaultTextStyle(
                    style: const TextStyle(fontSize: 12, color: Colors.black, decoration: TextDecoration.none, fontWeight: FontWeight.normal),
                    child: item,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _DataTable extends StatelessWidget {
  final List<TableRow> rows;

  const _DataTable({required this.rows});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Table(
        border: TableBorder.all(color: Colors.black, width: 1),
        children: rows,
      ),
    );
  }
}

class _TableCell extends StatelessWidget {
  final String text;
  final bool isHeader;

  const _TableCell({required this.text, required this.isHeader});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          color: Colors.black,
          decoration: TextDecoration.none,
        ),
      ),
    );
  }
}
