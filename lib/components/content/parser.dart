import 'models.dart';

/// Constants for content type identifiers
class ContentTypes {
  static const teletype = 'tt';
  static const unteletypeEnd = 'untt';
  static const title = 't';
  static const anchor = 'a';
  static const heading1 = 'h1';
  static const heading2 = 'h2';
  static const heading3 = 'h3';
  static const paragraph = 'p';
  static const reference = 'r';
  static const lineBreak = 'lbr';
  static const separator = 'lsep';
  static const unorderedListEnd = 'unel';
  static const orderedListEnd = 'unbl';
  static const item = 'it';
  static const tableEnd = 'untbl';
  static const tableHeader = 'tblh';
  static const tableRow = 'tblr';
}

/// Parses raw content string into structured content elements
class ContentParser {
  /// Parse content string into a list of content elements
  List<ContentElement> parse(String content) {
    if (content.isEmpty) {
      return [];
    }

    final lines = content.split('\n');
    final elements = <ContentElement>[];

    // State for multi-line constructs
    var inTeletype = false;
    final teletypeLines = <String>[];
    final listItems = <String>[];
    final tableHeaders = <List<String>>[];
    final tableRows = <List<String>>[];

    for (final line in lines) {
      final parsedLine = _parseLine(line);
      final type = parsedLine.type;
      final args = parsedLine.args;

      // Handle teletype (code block) mode
      if (inTeletype && type != ContentTypes.unteletypeEnd) {
        teletypeLines.add(line.startsWith('\t') ? line.substring(1) : line);
        continue;
      }

      // Process each content type
      switch (type) {
        case ContentTypes.teletype:
          inTeletype = true;
          break;

        case ContentTypes.unteletypeEnd:
          if (teletypeLines.isNotEmpty) {
            elements.add(CodeBlockElement(text: teletypeLines.join('\n')));
            teletypeLines.clear();
          }
          inTeletype = false;
          break;

        case ContentTypes.title:
          if (args.isNotEmpty) {
            elements.add(TitleElement(text: args[0]));
          }
          break;

        case ContentTypes.anchor:
          elements.add(const AnchorElement());
          break;

        case ContentTypes.heading1:
          if (args.isNotEmpty) {
            elements.add(HeadingElement(text: args[0], level: 1));
          }
          break;

        case ContentTypes.heading2:
          if (args.isNotEmpty) {
            elements.add(HeadingElement(text: args[0], level: 2));
          }
          break;

        case ContentTypes.heading3:
          if (args.isNotEmpty) {
            elements.add(HeadingElement(text: args[0], level: 3));
          }
          break;

        case ContentTypes.paragraph:
          if (args.isNotEmpty) {
            elements.add(ParagraphElement(text: args[0]));
          }
          break;

        case ContentTypes.reference:
          if (args.length >= 2) {
            elements.add(ReferenceElement(text: args[0], url: args[1]));
          }
          break;

        case ContentTypes.lineBreak:
          elements.add(const LineBreakElement());
          break;

        case ContentTypes.separator:
          elements.add(const SeparatorElement());
          break;

        case ContentTypes.item:
          if (args.isNotEmpty) {
            listItems.add(args[0]);
          }
          break;

        case ContentTypes.unorderedListEnd:
          if (listItems.isNotEmpty) {
            elements.add(UnorderedListElement(items: List.from(listItems)));
            listItems.clear();
          }
          break;

        case ContentTypes.orderedListEnd:
          if (listItems.isNotEmpty) {
            elements.add(OrderedListElement(items: List.from(listItems)));
            listItems.clear();
          }
          break;

        case ContentTypes.tableHeader:
          if (args.isNotEmpty) {
            tableHeaders.add(args);
          }
          break;

        case ContentTypes.tableRow:
          if (args.isNotEmpty) {
            tableRows.add(args);
          }
          break;

        case ContentTypes.tableEnd:
          if (tableHeaders.isNotEmpty || tableRows.isNotEmpty) {
            elements.add(TableElement(
              headerRows: List.from(tableHeaders),
              dataRows: List.from(tableRows),
            ));
            tableHeaders.clear();
            tableRows.clear();
          }
          break;

        default:
          // Unknown type, skip silently
          break;
      }
    }

    return elements;
  }

  /// Parse a single line into type and arguments
  _ParsedLine _parseLine(String line) {
    final parts = line.split('\t');

    if (parts.isEmpty) {
      return const _ParsedLine(type: '', args: []);
    }

    final type = parts[0];
    final args = parts.length > 1 ? parts.sublist(1) : <String>[];

    return _ParsedLine(type: type, args: args);
  }
}

/// Internal class to represent a parsed line
class _ParsedLine {
  final String type;
  final List<String> args;

  const _ParsedLine({
    required this.type,
    required this.args,
  });
}
