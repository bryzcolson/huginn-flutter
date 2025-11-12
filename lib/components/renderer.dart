import 'package:flutter/material.dart';
import 'content/models.dart';
import 'content/parser.dart';
import 'content/widgets.dart';

/// Main renderer widget that displays parsed content
class Renderer extends StatefulWidget {
  final String content;
  final NavigateCallback navigate;

  const Renderer({
    super.key,
    required this.content,
    required this.navigate,
  });

  @override
  State<Renderer> createState() => _RendererState();
}

class _RendererState extends State<Renderer> {
  late final FocusNode _focusNode;
  late final ContentParser _parser;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _parser = ContentParser();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final elements = _parser.parse(widget.content);
    final widgets = _buildWidgets(elements);

    return Container(
      constraints: const BoxConstraints(minWidth: 664),
      padding: const EdgeInsets.all(24),
      child: SelectableRegion(
        focusNode: _focusNode,
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

  /// Build widgets from content elements
  List<Widget> _buildWidgets(List<ContentElement> elements) {
    final widgets = <Widget>[];

    for (final element in elements) {
      final widget = _createWidget(element);
      if (widget != null) {
        widgets.add(widget);
      }
    }

    return widgets;
  }

  /// Factory method to create widgets from content elements
  Widget? _createWidget(ContentElement element) => switch (element) {
        HeadingElement() => Heading(
            text: element.text,
            level: element.level,
          ),
        ParagraphElement() => Paragraph(text: element.text),
        CodeBlockElement() => CodeBlock(text: element.text),
        ReferenceElement() => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Reference(
                text: element.text,
                url: element.url,
                onTap: () => widget.navigate(element.url, true),
              ),
              const SizedBox(height: 4),
            ],
          ),
        LineBreakElement() => const SizedBox(height: 8),
        SeparatorElement() => const Divider(color: Colors.black),
        UnorderedListElement() => UnorderedList(items: element.items),
        OrderedListElement() => OrderedList(items: element.items),
        TableElement() => ContentTable(element: element),
        AnchorElement() => const SizedBox.shrink(),
        TitleElement() => const SizedBox.shrink(), // Title handled at app level
        _ => const SizedBox.shrink(), // Unknown element type
      };
}
