import 'package:camellia_manito/pages/dialog/result_alert.dart';
import 'package:camellia_manito/pages/result_page_viewmodel.dart';
import 'package:camellia_manito/pages/widgets/user_info_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({super.key});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  late ResultPageViewModel _viewModel;

  @override
  void initState() {
    super.initState();

    _viewModel = context.read<ResultPageViewModel>();
    _viewModel.usersListenable.addListener(_refresh);
    _viewModel.showResultListenable.addListener(_refresh);

    _viewModel.init();
  }

  @override
  void dispose() {
    _viewModel.usersListenable.removeListener(_refresh);
    _viewModel.showResultListenable.removeListener(_refresh);

    super.dispose();
  }

  void _refresh() {
    setState(() {});
  }

  void _showCustomAlertDialog(int index) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return GestureDetector(
            onDoubleTap: () {
              context.pop();
            },
            child: ResultAlert(
              name: _viewModel.resultUsers[index]['name'],
              image: _viewModel.resultUsers[index]['image'],
            ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: _buildAppbar(),
        body: SafeArea(
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: 60, left: 16, right: 16),
            itemCount: _viewModel.users.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildAvatar(index),
                        const Text(
                          '>',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: Colors.white,
                          ),
                        ),
                        _buildResultAvatar(index)
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  AppBar _buildAppbar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      leading: IconButton(
        onPressed: () => context.pop(),
        icon: const Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
        ),
      ),
      actions: [
        IconButton(
            onPressed: () => _viewModel.setAllShowResult(true),
            icon: const Icon(
              Icons.done_all,
              size: 30,
              color: Colors.white,
            ))
      ],
    );
  }

  Widget _buildAvatar(int index) {
    if (_viewModel.users.isEmpty) {
      return Container();
    }

    return UserInfoWidget(
      name: _viewModel.users[index]['name'],
      imagePath: _viewModel.users[index]['image'],
    );
  }

  Widget _buildResultAvatar(int index) {
    if (_viewModel.showResult.isEmpty) {
      return Container();
    }

    return ValueListenableBuilder(
      valueListenable: _viewModel.showResult[index],
      builder: (BuildContext context, var value, Widget? child) {
        if (!_viewModel.showResult[index].value) {
          return _buildWho(index);
        }

        return UserInfoWidget(
          name: _viewModel.resultUsers[index]['name'],
          imagePath: _viewModel.resultUsers[index]['image'],
        );
      },
    );
  }

  Widget _buildWho(int index) {
    return GestureDetector(
      // onLongPress: () => _showResult(index),
      onLongPress: () => _showCustomAlertDialog(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(100),
              border: Border.all(
                width: 1,
                color: Colors.grey.shade200,
              ),
            ),
            child: const Icon(
              Icons.lock,
              color: Colors.grey,
              size: 30,
            ),
          ),
          SizedBox(
            child: Text(
              '?',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
