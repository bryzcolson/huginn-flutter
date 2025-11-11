import 'package:flutter/material.dart';
import '../utils/client.dart';
import 'toolbar.dart';
import 'renderer.dart';

class Browser extends StatefulWidget {
  final List<String> history;
  
  const Browser({super.key, required this.history});
  
  @override
  State<Browser> createState() => _BrowserState();
}

class _BrowserState extends State<Browser> {
  late List<String> _history;
  int _pos = -1;
  String _content = '';
  String _addr = '';

  @override
  void initState() {
    super.initState();
    _history = List.from(widget.history);
  }

  Future<void> navigate(String url, bool modifyHistory) async {
    try {
      final res = await OdinClient.preflight(url);
      
      if (res == 'A') {
        try {
          final content = await OdinClient.pull(url);
          setState(() {
            _content = content;
          });
        } catch (e) {
          setState(() {
            _content = 't\tOdin Error E\nh1\tOdin Error E\np\tServer request error';
          });
        }
      } else if (res == 'B') {
        setState(() {
          _content = 't\tOdin Error B\nh1\tOdin Error B\np\tFile not found';
        });
      } else if (res == 'C') {
        setState(() {
          _content = 't\tOdin Error C\nh1\tOdin Error C\np\tMalformed request';
        });
      } else {
        setState(() {
          _content = 't\tOdin Error D\nh1\tOdin Error D\np\tServer request error';
        });
      }
    } catch (e) {
      setState(() {
        _content = 't\tOdin Error D\nh1\tOdin Error D\np\tServer request error';
      });
    }
    
    if (modifyHistory) {
      setState(() {
        _history = _history.sublist(0, _pos + 1)..add(url);
        _pos++;
      });
    }
    
    setState(() {
      _addr = url;
    });
  }

  void _back() {
    if (_pos > 0) {
      navigate(_history[_pos - 1], false);
      setState(() {
        _pos--;
      });
    }
  }

  void _next() {
    if (_pos < _history.length - 1) {
      navigate(_history[_pos + 1], false);
      setState(() {
        _pos++;
      });
    }
  }

  void _refresh() {
    if (_pos > -1) {
      navigate(_history[_pos], false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final canBack = _pos > 0;
    final canNext = _pos < _history.length - 1;
    final canRefresh = _pos > -1;

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
