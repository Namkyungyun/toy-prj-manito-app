import 'package:camellia_manito/pages/home_page_viewmodel.dart';
import 'package:camellia_manito/pages/widgets/user_card_widget.dart';
import 'package:camellia_manito/routes/route_info.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _birdController;
  late Animation<Offset> _birdAnimation;
  final List<String> items = [];

  late HomePageViewModel _viewModel;

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

    _viewModel = context.read<HomePageViewModel>();
    _viewModel.userListenable.addListener(_refresh);
    _viewModel.enabledResultListenable.addListener(_refresh);

    _viewModel.init();
  }

  void _pushEnrollPage() async {
    final result = await context.push(RouteInfo.enroll.path);
    if (result != null) {
      _refresh();
    }
  }

  @override
  void dispose() {
    _viewModel.userListenable.removeListener(_refresh);
    _viewModel.enabledResultListenable.removeListener(_refresh);
    _birdController.dispose();

    super.dispose();
  }

  void _refresh() {
    print('ddd');
    setState(() {});
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
              Colors.red,
              Colors.lightGreen,
              Colors.red,
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
              Image.asset(
                'assets/images/title.png',
                width: 300,
              ),
              if (items.isEmpty)
                Expanded(child: _buildEmptyCard())
              else
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    margin:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.white.withOpacity(0.2),
                        border: Border.all(
                          width: 1.5,
                          color: Colors.white,
                        )),
                    child: ListView.builder(
                        // padding: const EdgeInsets.all(8),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              UserCardWidget(
                                index: index,
                                size: 110,
                              ),
                              if (index == items.length - 1)
                                _buildEnrollButton(),
                            ],
                          );
                        }),
                  ),
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
              size: 180,
            ),
          ),
          _buildEnrollButton(),
        ],
      ),
    );
  }

  Widget _buildEnrollButton() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      child: ElevatedButton(
        onPressed: _pushEnrollPage,
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
            Image.asset(
              'assets/images/start.png',
              width: 80,
            ),
          ],
        ),
      ),
    );
  }
}
