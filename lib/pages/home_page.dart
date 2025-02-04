import 'package:camellia_manito/pages/widgets/user_card_widget.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _birdController;
  late Animation<Offset> _birdAnimation;
  final List<String> items = [];

  @override
  void initState() {
    super.initState();
    _birdController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    )..repeat(reverse: true);

    _birdAnimation = Tween<Offset>(
      begin: const Offset(0.01, 0),
      end: const Offset(-0.01, 0),
    ).animate(CurvedAnimation(
      parent: _birdController,
      curve: Curves.linear,
    ));
  }

  @override
  void dispose() {
    _birdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.purple,
              Colors.lightBlue,
              Colors.lightGreen,
              Colors.blue,
              Colors.lightGreenAccent,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text(
                '동백할미네 마 - 니 - 또',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 30),
              ),
              if (items.isEmpty)
                Expanded(child: _buildEmptyCard())
              else
                Expanded(
                  child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        if (index == items.length - 1) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              UserCardWidget(
                                index: index,
                                width: 130,
                                height: 130,
                              ),
                              _buildEnrollButton(),
                            ],
                          );
                        }

                        return UserCardWidget(
                          index: index,
                          width: 130,
                          height: 130,
                        );
                      }),
                ),
              _buildBird(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyCard() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const Expanded(
            child: UserCardWidget(
              index: 5,
              width: 180,
              height: 90,
            ),
          ),
          _buildEnrollButton(),
        ],
      ),
    );
  }

  Widget _buildEnrollButton() {
    return ElevatedButton(
      onPressed: () => {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white.withOpacity(0.4), // 버튼 배경색
        surfaceTintColor: Colors.white.withOpacity(0.4),
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // 버튼의 둥근 모서리 값
        ),
      ),
      child: const Center(
        child: Text(
          "+",
          style: TextStyle(
            fontSize: 34,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildBird() {
    if (items.isEmpty) {
      return Container();
    }

    return SlideTransition(
      position: _birdAnimation,
      child: Align(
        // alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/bird.png',
              color: Colors.white,
              width: 100,
            ),
            const Text(
              '게임 시작',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }
}
