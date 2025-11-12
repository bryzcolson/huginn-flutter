import 'package:flutter/material.dart';
import '../utils/client.dart';
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
  late final OdinClient _client;
  String _content = '';
  String _addr = '';

  @override
  void initState() {
    super.initState();
    _navController = NavigationController(widget.history);
    _client = OdinClient();
  }

  @override
  void dispose() {
    _client.dispose();
    super.dispose();
  }

  Future<void> navigate(String url, bool modifyHistory) async {

    try {
      final status = await _client.preflight(url);
      String newContent;

      switch (status) {
        case PreflightStatus.ok:
          try {
            newContent = await _client.pull(url);
          } catch (e) {
            newContent = ErrorBuilder.buildServerError();
          }
          break;

        case PreflightStatus.notFound:
          newContent = ErrorBuilder.buildNotFoundError();
          break;

        case PreflightStatus.serverError:
          newContent = ErrorBuilder.buildMalformedError();
          break;

        case PreflightStatus.clientError:
          newContent = ErrorBuilder.buildServerError();
          break;
      }

      setState(() {
        _content = newContent;
        _addr = url;
      });

      if (modifyHistory) {
        setState(() => _navController.navigateTo(url));
      }
    } catch (e) {
      setState(() {
        _content = ErrorBuilder.buildServerError();
        _addr = url;
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
