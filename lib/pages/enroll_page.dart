import 'dart:convert';
import 'package:camellia_manito/pages/enroll_page%20_viewmodel.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class EnrollPage extends StatefulWidget {
  const EnrollPage({super.key});

  @override
  State<EnrollPage> createState() => _EnrollPageState();
}

class _EnrollPageState extends State<EnrollPage> {
  final TextEditingController _controller = TextEditingController();
  final _focusNode = FocusNode();

  late EnrollPageViewModel _viewModel;

  @override
  void initState() {
    super.initState();

    _viewModel = context.read<EnrollPageViewModel>();
    _viewModel.imageDataListenable.addListener(_refresh);
    _viewModel.enabledEnrollListenable.addListener(_refresh);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();

    _viewModel.imageDataListenable.removeListener(_refresh);
    _viewModel.enabledEnrollListenable.removeListener(_refresh);

    super.dispose();
  }

  void _refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _focusNode.unfocus,
      child: Container(
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
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: _viewModel.setImage,
                          child: SizedBox(
                              width: 250,
                              height: 250,
                              child: _buildProfileImage()), // 동그란 프로필 이미지
                        ),
                        const SizedBox(height: 30),
                        _buildNameField(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
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
          onPressed: () async {
            if (_viewModel.enabledEnrollment) {
              await _viewModel.save();
              if (mounted) {
                context.pop(1);
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('프로필 사진과 이름을 입력해주세요.')),
              );
            }
          },
          icon: const Icon(
            Icons.check_circle,
            color: Colors.white,
            size: 35,
          ),
        ),
      ],
    );
  }

  Widget _buildNameField() {
    return TextField(
      onChanged: (text) {
        _viewModel.setName(text);
      },
      controller: _controller,
      focusNode: _focusNode,
      style: const TextStyle(color: Colors.white), // ✅ 텍스트 색상 흰색
      inputFormatters: [
        FilteringTextInputFormatter.allow(
            RegExp(r'^[a-zA-Z가-힣\s]*$')), // ✅ 한글 & 영문만 입력 가능
      ],
      decoration: InputDecoration(
        labelText: '이름 입력',
        labelStyle: const TextStyle(color: Colors.white), // ✅ 라벨 색상 흰색
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white), // ✅ 기본 테두리 흰색
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
              color: Colors.white, width: 2.0), // ✅ 포커스 시 테두리 흰색
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    if (_viewModel.imageData != null) {
      return CircleAvatar(
        radius: 60,
        backgroundImage: MemoryImage(base64Decode(_viewModel.imageData)),
      );
    } else {
      return CircleAvatar(
        radius: 60,
        backgroundColor: Colors.white.withOpacity(0.5),
        child: const Icon(Icons.camera_alt, size: 80, color: Colors.white),
      );
    }
  }
}
