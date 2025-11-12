import 'package:flutter/material.dart';
import 'models.dart';
import 'theme.dart';

/// Callback type for navigation actions
typedef NavigateCallback = void Function(String url, bool addToHistory);

/// Displays a code block with syntax highlighting background
class CodeBlock extends StatelessWidget {
  final String text;

  const CodeBlock({super.key, required this.text});

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        margin: RendererTheme.codeBlockMargin,
        padding: RendererTheme.codeBlockPadding,
        decoration: BoxDecoration(
          color: RendererTheme.codeBackgroundColor,
          borderRadius: BorderRadius.circular(RendererTheme.codeBlockBorderRadius),
        ),
        child: Text(text, style: RendererTheme.codeTextStyle),
      );
}

/// Displays a heading with the appropriate level styling
class Heading extends StatelessWidget {
  final String text;
  final int level;

  const Heading({
    super.key,
    required this.text,
    required this.level,
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: RendererTheme.headingVerticalPadding,
    child: Text(
      text,
      style: RendererTheme.getHeadingStyle(level),
    ),
  );
}

/// Displays a paragraph of text
class Paragraph extends StatelessWidget {
  final String text;

  const Paragraph({super.key, required this.text});

  @override
  Widget build(BuildContext context) => Padding(
    padding: RendererTheme.paragraphVerticalPadding,
    child: Text(text, style: RendererTheme.baseTextStyle),
  );
}

/// Displays a clickable reference/link with hover effect
class Reference extends StatefulWidget {
  final String text;
  final String url;
  final VoidCallback onTap;

  const Reference({
    super.key,
    required this.text,
    required this.url,
    required this.onTap,
  });

  @override
  State<Reference> createState() => _ReferenceState();
}

class _ReferenceState extends State<Reference> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) => MouseRegion(
    cursor: SystemMouseCursors.click,
    onEnter: (_) => setState(() => _isHovered = true),
    onExit: (_) => setState(() => _isHovered = false),
    child: GestureDetector(
      onTap: widget.onTap,
      child: Container(
        color: _isHovered
          ? RendererTheme.hoverBackgroundColor
          : Colors.transparent,
        padding: RendererTheme.referencePadding,
        child: Text(
          widget.text,
          style: RendererTheme.linkTextStyle,
        ),
      ),
    ),
  );
}

/// Displays an unordered (bulleted) list
class UnorderedList extends StatelessWidget {
  final List<String> items;

  const UnorderedList({super.key, required this.items});

  @override
  Widget build(BuildContext context) => Padding(
    padding: RendererTheme.listVerticalPadding,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
        .map((itemText) => Padding(
          padding: RendererTheme.listItemPadding,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                RendererTheme.listItemBullet,
                style: RendererTheme.baseTextStyle,
              ),
              Expanded(
                child: Text(itemText, style: RendererTheme.baseTextStyle),
              ),
            ],
          ),
        ),
      ).toList(),
    ),
  );
}

/// Displays an ordered (numbered) list
class OrderedList extends StatelessWidget {
  final List<String> items;

  const OrderedList({super.key, required this.items});

  @override
  Widget build(BuildContext context) => Padding(
    padding: RendererTheme.listVerticalPadding,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
        .asMap()
        .entries
        .map((entry) {
          final index = entry.key;
          final itemText = entry.value;
          return Padding(
            padding: RendererTheme.listItemPadding,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${index + 1}. ',
                  style: RendererTheme.baseTextStyle,
                ),
                Expanded(
                  child: Text(itemText, style: RendererTheme.baseTextStyle),
                ),
              ],
            ),
          );
        }
      ).toList(),
    ),
  );
}

/// Displays a data table with headers and rows
class ContentTable extends StatelessWidget {
  final TableElement element;

  const ContentTable({super.key, required this.element});

  @override
  Widget build(BuildContext context) {
    final allRows = <TableRow>[];

    // Add header rows
    for (final headerRow in element.headerRows) {
      allRows.add(
        TableRow(
          decoration: const BoxDecoration(color: Colors.white),
          children: headerRow
            .map((cell) => TableCell(text: cell, isHeader: true))
            .toList(),
        ),
      );
    }

    // Add data rows
    for (final dataRow in element.dataRows) {
      allRows.add(
        TableRow(
          children: dataRow
            .map((cell) => TableCell(text: cell, isHeader: false))
            .toList(),
        ),
      );
    }

    return Padding(
      padding: RendererTheme.tableVerticalPadding,
      child: Table(
        border: TableBorder.all(
          color: RendererTheme.tableBorderColor,
          width: RendererTheme.tableBorderWidth,
        ),
        children: allRows,
      ),
    );
  }
}

/// Displays a single table cell
class TableCell extends StatelessWidget {
  final String text;
  final bool isHeader;

  const TableCell({
    super.key,
    required this.text,
    required this.isHeader,
  });

  @override
  Widget build(BuildContext context) => Container(
    padding: RendererTheme.tableCellPadding,
    child: Text(
      text,
      style: RendererTheme.baseTextStyle.copyWith(
        fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
      ),
    ),
  );
}
