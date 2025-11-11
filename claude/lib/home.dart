import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sorteio/comment.dart';

class RaffleHomePage extends StatefulWidget {
  const RaffleHomePage({super.key});

  @override
  State<RaffleHomePage> createState() => _RaffleHomePageState();
}

class _RaffleHomePageState extends State<RaffleHomePage> {
  final TextEditingController _urlController = TextEditingController();
  List<Comment> _comments = [];
  bool _isLoading = false;
  bool _isRaffling = false;
  String? _error;
  Comment? _winner;
  int _currentIndex = 0;
  Timer? _raffleTimer;

  @override
  void dispose() {
    _urlController.dispose();
    _raffleTimer?.cancel();
    super.dispose();
  }

  Future<void> _analyzePost() async {
    setState(() {
      _isLoading = true;
      _error = null;
      _comments = [];
      _winner = null;
    });

    try {
      final url = _urlController.text.trim();

      if (url.isEmpty) {
        throw Exception('Por favor, insira uma URL');
      }

      if (!url.contains('instagram.com')) {
        throw Exception('URL inválida. Use uma URL do Instagram.');
      }

      await Future.delayed(const Duration(seconds: 2));

      final mockComments = [
        Comment(
          username: 'joao_silva',
          comment: 'Participando! @maria_santos',
          taggedUser: '@maria_santos',
          isValid: true,
        ),
        Comment(
          username: 'ana_costa',
          comment: 'Quero ganhar @pedro_oliveira',
          taggedUser: '@pedro_oliveira',
          isValid: true,
        ),
        Comment(
          username: 'carlos_souza',
          comment: 'Boa sorte! @lucas_ferreira',
          taggedUser: '@lucas_ferreira',
          isValid: true,
        ),
        Comment(
          username: 'beatriz_lima',
          comment: 'Participando @fernanda_rocha',
          taggedUser: '@fernanda_rocha',
          isValid: true,
        ),
        Comment(
          username: 'rafael_santos',
          comment: 'Tô dentro! @julia_martins',
          taggedUser: '@julia_martins',
          isValid: true,
        ),
        Comment(
          username: 'mariana_alves',
          comment: 'Vamos lá @roberto_costa',
          taggedUser: '@roberto_costa',
          isValid: true,
        ),
        Comment(
          username: 'gustavo_pereira',
          comment: 'Quero muito @camila_souza',
          taggedUser: '@camila_souza',
          isValid: true,
        ),
        Comment(
          username: 'patricia_mendes',
          comment: 'Participando @diego_lima',
          taggedUser: '@diego_lima',
          isValid: true,
        ),
        Comment(
          username: 'fernando_ramos',
          comment: 'Boa sorte @amanda_silva',
          taggedUser: '@amanda_silva',
          isValid: true,
        ),
        Comment(
          username: 'isabela_cardoso',
          comment: 'Tô na área @thiago_almeida',
          taggedUser: '@thiago_almeida',
          isValid: true,
        ),
        Comment(
          username: 'ricardo_barbosa',
          comment: 'Participando @paula_gomes',
          taggedUser: '@paula_gomes',
          isValid: true,
        ),
        Comment(
          username: 'leticia_moura',
          comment: 'Quero ganhar @bruno_santana',
          taggedUser: '@bruno_santana',
          isValid: true,
        ),
      ];

      setState(() {
        _comments = mockComments;
      });
    } catch (e) {
      setState(() {
        _error = e.toString().replaceAll('Exception: ', '');
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _startRaffle() {
    if (_comments.isEmpty) return;

    setState(() {
      _isRaffling = true;
      _winner = null;
      _currentIndex = 0;
    });

    const duration = Duration(seconds: 10);
    final totalItems = _comments.length;
    final minCycles = 2;
    final totalIterations = totalItems * minCycles;
    final intervalMs = (duration.inMilliseconds / totalIterations).floor();

    int iterationCount = 0;

    _raffleTimer = Timer.periodic(Duration(milliseconds: intervalMs), (timer) {
      iterationCount++;

      if (iterationCount >= totalIterations) {
        timer.cancel();
        _finishRaffle();
      } else {
        setState(() {
          _currentIndex = iterationCount % totalItems;
        });
      }
    });
  }

  void _finishRaffle() {
    final random = Random();
    final winnerIndex = random.nextInt(_comments.length);

    setState(() {
      _winner = _comments[winnerIndex];
      _currentIndex = winnerIndex;
      _isRaffling = false;
    });

    _showWinnerDialog();
  }

  void _showWinnerDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.emoji_events, color: Colors.amber, size: 30),
            SizedBox(width: 10),
            Text('Vencedor!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '@${_winner!.username}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
            const SizedBox(height: 10),
            Text('Marcou: ${_winner!.taggedUser}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.card_giftcard),
            SizedBox(width: 10),
            Text('Sorteio Instagram'),
          ],
        ),
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'URL do Post do Instagram',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _urlController,
                      decoration: const InputDecoration(
                        hintText: 'https://www.instagram.com/p/...',
                        prefixIcon: Icon(Icons.link),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _isLoading ? null : _analyzePost,
                        icon: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.search),
                        label: Text(
                          _isLoading ? 'Analisando...' : 'Analisar Post',
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(15),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Card(
                  color: Colors.red.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const Icon(Icons.error, color: Colors.red),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _error!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            if (_comments.isNotEmpty) ...[
              const SizedBox(height: 20),
              Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.people, color: Colors.purple),
                              const SizedBox(width: 10),
                              Text(
                                'Participantes: ${_comments.length}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          ElevatedButton.icon(
                            onPressed: _isRaffling ? null : _startRaffle,
                            icon: const Icon(Icons.casino),
                            label: Text(
                              _isRaffling ? 'Sorteando...' : 'Sortear',
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Container(
                        height: 400,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListView.builder(
                          itemCount: _comments.length,
                          itemBuilder: (context, index) {
                            final comment = _comments[index];
                            final isHighlighted =
                                _isRaffling && _currentIndex == index;
                            final isWinner =
                                _winner != null && _winner == comment;

                            return Container(
                              color: isWinner
                                  ? Colors.amber.shade100
                                  : isHighlighted
                                  ? Colors.purple.shade100
                                  : index % 2 == 0
                                  ? Colors.grey.shade50
                                  : Colors.white,
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: isWinner
                                      ? Colors.amber
                                      : Colors.purple,
                                  child: Text(
                                    comment.username[0].toUpperCase(),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                                title: Text(
                                  '@${comment.username}',
                                  style: TextStyle(
                                    fontWeight: isWinner
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                                subtitle: Text(comment.comment),
                                trailing: isWinner
                                    ? const Icon(
                                        Icons.emoji_events,
                                        color: Colors.amber,
                                        size: 30,
                                      )
                                    : Text(
                                        comment.taggedUser,
                                        style: const TextStyle(
                                          color: Colors.blue,
                                        ),
                                      ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
