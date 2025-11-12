/// Base class for all content elements that can be rendered
abstract class ContentElement {
  const ContentElement();
}

/// Represents a heading with a specific level (h1, h2, h3)
class HeadingElement extends ContentElement {
  final String text;
  final int level;

  const HeadingElement({
    required this.text,
    required this.level,
  });
}

/// Represents a paragraph of text
class ParagraphElement extends ContentElement {
  final String text;

  const ParagraphElement({required this.text});
}

/// Represents a code block (teletype)
class CodeBlockElement extends ContentElement {
  final String text;

  const CodeBlockElement({required this.text});
}

/// Represents a clickable reference/link
class ReferenceElement extends ContentElement {
  final String text;
  final String url;

  const ReferenceElement({
    required this.text,
    required this.url,
  });
}

/// Represents a line break
class LineBreakElement extends ContentElement {
  const LineBreakElement();
}

/// Represents a horizontal separator/divider
class SeparatorElement extends ContentElement {
  const SeparatorElement();
}

/// Represents an unordered (bulleted) list
class UnorderedListElement extends ContentElement {
  final List<String> items;

  const UnorderedListElement({required this.items});
}

/// Represents an ordered (numbered) list
class OrderedListElement extends ContentElement {
  final List<String> items;

  const OrderedListElement({required this.items});
}

/// Represents a table with headers and rows
class TableElement extends ContentElement {
  final List<List<String>> headerRows;
  final List<List<String>> dataRows;

  const TableElement({
    required this.headerRows,
    required this.dataRows,
  });
}

/// Represents an anchor (currently not visible but kept for semantic structure)
class AnchorElement extends ContentElement {
  const AnchorElement();
}

/// Represents a title element
class TitleElement extends ContentElement {
  final String text;

  const TitleElement({required this.text});
}
