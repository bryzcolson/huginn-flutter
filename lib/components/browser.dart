import 'package:flutter/material.dart';
import '../utils/client.dart';
import 'browser/constants.dart';
import 'browser/error_builder.dart';
import 'browser/navigation_controller.dart';
import 'toolbar.dart';
import 'renderer.dart';

class Browser extends StatefulWidget {
  final List<String> history;

  const Browser({super.key, required this.history});

  @override
  State<Browser> createState() => _BrowserState();
}

class _BrowserState extends State<Browser> {
  late final NavigationController _navController;
  String _content = '';
  String _addr = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _navController = NavigationController(widget.history);
  }

  Future<void> navigate(String url, bool modifyHistory) async {
    setState(() => _isLoading = true);

    try {
      final res = await OdinClient.preflight(url);
      String newContent;

      switch (res) {
        case BrowserConstants.responseSuccess:
          try {
            newContent = await OdinClient.pull(url);
          } catch (e) {
            newContent = ErrorBuilder.buildServerError();
          }
          break;

        case BrowserConstants.responseNotFound:
          newContent = ErrorBuilder.buildNotFoundError();
          break;

        case BrowserConstants.responseMalformed:
          newContent = ErrorBuilder.buildMalformedError();
          break;

        default:
          newContent = ErrorBuilder.buildServerError();
          break;
      }

      setState(() {
        _content = newContent;
        _addr = url;
        _isLoading = false;
      });

      if (modifyHistory) {
        setState(() => _navController.navigateTo(url));
      }
    } catch (e) {
      setState(() {
        _content = ErrorBuilder.buildServerError();
        _addr = url;
        _isLoading = false;
      });
    }
  }

  void _back() {
    final url = _navController.goBack();
    if (url != null) {
      navigate(url, false);
    }
  }

  void _next() {
    final url = _navController.goForward();
    if (url != null) {
      navigate(url, false);
    }
  }

  void _refresh() {
    final url = _navController.getRefreshUrl();
    if (url != null) {
      navigate(url, false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final canBack = _navController.canGoBack;
    final canNext = _navController.canGoForward;
    final canRefresh = _navController.canRefresh;

    return Container(
      color: const Color(0xFFFAFAFA),
      child: Column(
        children: [
          Toolbar(
            addr: _addr,
            onAddrChanged: (value) => setState(() => _addr = value),
            onNavigate: navigate,
            canBack: canBack,
            onBack: _back,
            canNext: canNext,
            onNext: _next,
            canRefresh: canRefresh,
            onRefresh: _refresh,
          ),
          Expanded(
            child: Renderer(
              content: _content,
              navigate: navigate,
            ),
          ),
        ],
      ),
    );
  }
}
