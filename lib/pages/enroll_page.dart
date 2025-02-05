import 'dart:convert';
import 'dart:io';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EnrollPage extends StatefulWidget {
  const EnrollPage({super.key});

  @override
  State<EnrollPage> createState() => _EnrollPageState();
}

class _EnrollPageState extends State<EnrollPage> {
  final TextEditingController _controller = TextEditingController();
  final _focusNode = FocusNode();
  String? _base64Image;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _refresh() {
    setState(() {});
  }

  /// 📌 이미지 선택 및 Base64 인코딩 후 저장
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final bytes = await File(pickedFile.path).readAsBytes();
      final base64String = base64Encode(bytes);

      setState(() {
        _base64Image = base64String;
      });

      // Hive에 저장
      // var box = Hive.box('userBox');
      // await box.put('profileImage', base64String);
    }
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
          appBar: AppBar(
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
                onPressed: () => context.pop(1),
                icon: const Icon(
                  Icons.check_circle,
                  color: Colors.white,
                  size: 35,
                ),
              ),
            ],
          ),
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
                          onTap: _pickImage,
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

  Widget _buildNameField() {
    return TextField(
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
    if (_base64Image != null) {
      return CircleAvatar(
        radius: 60,
        backgroundImage: MemoryImage(base64Decode(_base64Image!)),
      );
    } else {
      return CircleAvatar(
        radius: 60,
        backgroundColor: Colors.white.withOpacity(0.5),
        child: const Icon(Icons.camera_alt, size: 80, color: Colors.white),
      );
    }
  }

  void test() {
    final string = '';
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String token = stringToBase64.encode(string);
  }
}
