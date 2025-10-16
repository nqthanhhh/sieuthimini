import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();
  bool _remember = false;
  bool _obscurePass = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmPassCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    final email = _emailCtrl.text.trim();
    final pass = _passCtrl.text;
    final confirm = _confirmPassCtrl.text;
    if (email.isEmpty || pass.isEmpty || confirm.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng điền đầy đủ thông tin')),
      );
      return;
    }
    if (pass != confirm) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mật khẩu xác nhận không khớp')),
      );
      return;
    }
    // For MVP we just show a snackbar and pop back to login
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tạo tài khoản thành công (demo)')),
    );
    Navigator.of(context).pop();
  }

  Widget _socialButton(String assetName) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SvgPicture.asset(assetName),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Tạo tài khoản của bạn',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _emailCtrl,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email),
                  hintText: 'Email',
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _passCtrl,
                obscureText: _obscurePass,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock),
                  hintText: 'Mật khẩu',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePass ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePass = !_obscurePass),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _confirmPassCtrl,
                obscureText: _obscureConfirm,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock_outline),
                  hintText: 'Nhập lại mật khẩu',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirm ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () =>
                        setState(() => _obscureConfirm = !_obscureConfirm),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Checkbox(
                    value: _remember,
                    onChanged: (v) => setState(() => _remember = v ?? false),
                  ),
                  const Text('Nhớ tài khoản'),
                ],
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 0, 73, 125),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(36),
                  ),
                ),
                child: const Text('Tạo tài khoản'),
              ),
              const SizedBox(height: 50),
              Row(
                children: const [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text('Hoặc tiếp tục với'),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _socialButton('assets/images/material-icon-theme_google.svg'),
                  _socialButton('assets/images/Vector.svg'),
                  _socialButton('assets/images/ic_baseline-apple.svg'),
                ],
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Bạn đã có tài khoản? '),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Đăng nhập'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
